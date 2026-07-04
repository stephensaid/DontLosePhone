# DLH State Machine & Implementation Guide

## Application States

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DLH Application States                             │
└─────────────────────────────────────────────────────────────────────────────┘

                              NORMAL_MONITORING
                              ├─ BT Connected
                              ├─ Lock GPS continuously
                              ├─ Listen for BT disconnect
                              └─ Update settings

                                     │
                                     │ BT Disconnect
                                     ▼

                              CONNECTION_TIMEOUT
                              ├─ Start timeout countdown
                              ├─ Disable GPS (save battery)
                              ├─ Wait for BT reconnect
                              └─ Timeout = user-configured seconds

                                     │
                    ┌────────────────┴────────────────┐
                    │                                 │
              BT Reconnect                     Timeout Expires
              (Reset State)                          │
                    │                                 ▼
                    │                          MOTION_CHECK
                    │                          ├─ Monitor accelerometer
                    │                          ├─ Detect walking cadence
                    │                          ├─ Detect speed increase
                    │                          └─ Wait for motion trigger
                    │                                 │
                    │                  ┌──────────────┼──────────────┐
                    │                  │              │              │
                    │            Motion Detected   No Motion    Transport Mode
                    │            (Walking)        (Stationary)  (Speed↑)
                    │                  │              │              │
                    │                  ▼              ▼              ▼
                    │            GPS_PROXIMITY   Stay Silent   ALARM_ACTIVE
                    │            ├─ Lock Point A │              (Immediate)
                    │            ├─ Start GPS    │
                    │            ├─ Measure      │
                    │            │  distance     │
                    │            └─ Check        │
                    │              threshold     │
                    │                  │              │
                    │    ┌─────────────┴──────────────┤
                    │    │              │              │
                    │    ▼              ▼              ▼
                    │ ALARM_ACTIVE   Stay Silent   ALARM_ACTIVE
                    │ (Proximity     (< Threshold) (Transport)
                    │  Exceeded)                    │
                    │    │                          │
                    └────┤                          │
                         │                          │
                         └──────────────┬───────────┘
                                        │
                              ┌─────────┴─────────┐
                              │                   │
                         User Dismisses      User Snoozes
                              │                   │
                              ▼                   ▼
                         NORMAL_MONITORING   SNOOZED
                                            ├─ Start snooze timer
                                            ├─ Hide alarm screen
                                            └─ Background monitoring
                                                  │
                                      ┌───────────┼───────────┐
                                      │           │           │
                              BT Reconnect  Snooze Expires   User Dismisses
                              (Interrupt)        │              │
                                      │           │              ▼
                              NORMAL_MONITORING  Recheck Tiers  NORMAL_MONITORING
                                      │           └─────┬────────┘
                                      │                 │
                                      └────────┬────────┘
                                               ▼
                                        NORMAL_MONITORING
```

## Data Structures

### AppState
```monkey-c
class AppState {
    NORMAL_MONITORING = 0
    CONNECTION_TIMEOUT = 1
    MOTION_CHECK = 2
    GPS_PROXIMITY = 3
    ALARM_ACTIVE = 4
    SNOOZED = 5
}
```

### BluetoothMonitor
```monkey-c
class BluetoothMonitor {
    var isConnected
    var disconnectTime
    var timeoutSeconds (user-configurable)
}
```

### MotionGate
```monkey-c
class MotionGate {
    var isEnabled (user-configurable)
    var walkingThreshold
    var transportSpeedThreshold
    var recentAcceleration []
}
```

### GpsProximity
```monkey-c
class GpsProximity {
    var isEnabled (user-configurable)
    var pointA {lat, lng, timestamp}  // Phone's locked location
    var threshold {10m, 20m, 50m}     // User-configurable
    var lastValidGps {lat, lng, timestamp}
}
```

### AlarmController
```monkey-c
class AlarmController {
    var state (IDLE, CHECKING, ALARMING)
    var snoozeDurations [5, 20, custom]
    var activeSnooze null/duration
    var buttonConfig {snooze1, snooze2, snooze3, dismiss}
}
```

### Settings (Persistent)
```monkey-c
class Settings {
    KEY_TIMEOUT = "dlh_timeout"
    KEY_MOTION_GATE = "dlh_motion_gate"
    KEY_GPS_ENABLED = "dlh_gps_enabled"
    KEY_GPS_THRESHOLD = "dlh_gps_threshold"
    KEY_SNOOZE_1/2/3 = "dlh_snooze_*"
    KEY_BTN_LEFT_MID/BOT/RIGHT_BOT = "dlh_btn_*"
    // + GPS staleness config (e.g., max 5 min old)
}
```

## Main Event Loop

```
while (app running) {
    1. Check Bluetooth connection state
    
    if (BT_CONNECTED) {
        // GPS only active if GPS Proximity setting enabled
        if (GPS_PROXIMITY_ENABLED) {
            - Lock current GPS as valid location
            - Update lastValidGps timestamp
        }
        // else: GPS off, save battery
        
    } else if (BT_DISCONNECTED && state != SNOOZED) {
        
        if (state == NORMAL_MONITORING) {
            → Transition to CONNECTION_TIMEOUT
            → Start timeout countdown
            // GPS already off due to disconnect; only activate if needed in motion checks
            → Disable all sensors except accelerometer
        }
        
        if (state == CONNECTION_TIMEOUT) {
            if (timeout_expired) {
                → Transition to MOTION_CHECK
                → Enable accelerometer monitoring (minimal battery impact)
                // Do NOT activate GPS yet - wait for motion detection
            }
        }
        
        if (state == MOTION_CHECK) {
            checkMotionGate():
                if (walking_detected OR speed_increase_detected) {
                    if (GPS_PROXIMITY_ENABLED) {
                        // Only activate GPS if setting is enabled
                        → Transition to GPS_PROXIMITY
                        → Enable GPS and lock Point A (current GPS if valid & recent)
                        → Start distance monitoring
                    } else {
                        // GPS disabled - alarm based on motion alone
                        → Transition to ALARM_ACTIVE
                    }
                }
                // else: stay in MOTION_CHECK, keep checking
        }
        
        if (state == GPS_PROXIMITY) {
            if (distance_to_pointA >= threshold) {
                → Transition to ALARM_ACTIVE
                → Trigger alarm screen
                → Start vibration pattern
            }
            // else: stay in GPS_PROXIMITY, keep monitoring
        }
        
    } else if (state == SNOOZED) {
        if (BT_RECONNECTED) {
            → Cancel snooze countdown
            → Resume GPS monitoring if GPS_PROXIMITY_ENABLED
            → Reset to NORMAL_MONITORING
            → No notification
        }
        
        if (snooze_timer_expired) {
            → Recheck all tiers from MOTION_CHECK
            → Do NOT auto-alarm, recalculate
        }
    }
    
    if (state == ALARM_ACTIVE) {
        if (BT_RECONNECTED) {
            → Dismiss alarm
            → Resume GPS monitoring if GPS_PROXIMITY_ENABLED
            → Transition to NORMAL_MONITORING
        }
        
        if (user_pressed_dismiss) {
            → Dismiss alarm
            → Resume GPS monitoring if GPS_PROXIMITY_ENABLED
            → Transition to NORMAL_MONITORING
        }
        
        if (user_pressed_snooze) {
            → Dismiss alarm screen
            → Start snooze timer
            → Transition to SNOOZED
            // GPS remains off during snooze
        }
    }
    
    // Update UI
    updateDisplays()
    
    // Battery optimization
    sleepIfIdle()
}
```

## GPS Staleness Management

```
const GPS_MAX_AGE_MS = 5 * 60 * 1000  // 5 minutes (configurable)

function isGpsValid(gpsLocation) {
    if (gpsLocation == null) return false
    
    timeSinceUpdate = now() - gpsLocation.timestamp
    
    return (timeSinceUpdate < GPS_MAX_AGE_MS)
}

function canLockPointA() {
    return isGpsValid(lastValidGps)
}
```

## Transport Mode Detection

```
function detectTransportMode() {
    // Measure recent velocity change
    // If Δspeed > TRANSPORT_THRESHOLD in short time:
    //   - User got on bike/car
    //   - Bypass motion gate
    //   - Trigger immediate alarm
    
    const TRANSPORT_THRESHOLD = 5.0  // m/s (18 km/h, reasonable bike speed)
    const MEASUREMENT_WINDOW = 5000  // 5 seconds
    
    recentSpeeds = last_5_seconds_of_velocities
    speedChange = max(recentSpeeds) - min(recentSpeeds)
    
    return speedChange > TRANSPORT_THRESHOLD
}
```

## Implementation Priority

1. **Phase 1 (MVP)**: Connection Timeout + Motion Gate + GPS Proximity (basic)
2. **Phase 2**: Transport Mode detection
3. **Phase 3**: Sophisticated motion analysis (walking cadence)
4. **Phase 4**: GPS staleness optimization

## Battery Optimization Strategy

### Power Budget

| Sensor/Feature | Power Impact | Status |
|---|---|---|
| BT Monitoring | Low | Always on (required for connection detection) |
| Accelerometer | Very Low | On when BT disconnected (needed for motion gate) |
| GPS (continuous) | **CRITICAL** | **OFF by default** - only when GPS Proximity enabled + BT connected |
| Display | Medium | Only during alarm |

### Key Optimization Decisions

1. **GPS Only When Enabled & Connected**
   - GPS drains battery rapidly
   - Only activate if user enables "GPS Proximity" setting
   - Disable immediately on BT disconnect
   - Users can disable GPS Proximity to extend battery life (falls back to Motion Gate only)

2. **Accelerometer Always Available**
   - Very low power draw
   - Essential for motion detection during disconnect
   - Lightweight pattern matching (walking cadence)

3. **CPU Sleep Between Checks**
   - Main loop periodically sleeps when idle
   - Wakes on significant events (BT status, motion detection, timers)
   - Prevents constant polling

### Recommended Check Intervals

- BT status check: Every 100-500ms
- Accelerometer sampling: 10-50Hz (continuous during motion check, not between)
- Motion analysis: Every 1-2 seconds during MOTION_CHECK state
- GPS update: Every 5-10 seconds (only when connected + GPS enabled)



