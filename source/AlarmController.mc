import Toybox.Timer;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Attention;
import Toybox.Time;
import Toybox.Lang;

/**
 * AlarmController - Manages alarm state, snooze timers, and user feedback
 * 
 * Responsibilities:
 * - Control alarm on/off state
 * - Manage snooze timer durations
 * - Trigger vibrations and alerts
 * - Display alarm screen
 * - Handle snooze/dismiss actions
 */
class AlarmController {

    enum AlarmState {
        IDLE,
        CHECKING,
        ALARMING
    }

    private var state = 0;  // AlarmState.IDLE
    // Button mapping: [Snooze1 (BottomLeft), Snooze2 (MiddleLeft), Snooze3 (BottomRight)]
    private var snoozeDurations as Lang.Array<Lang.Number> = [5, 20, 0] as Lang.Array<Lang.Number>; // Default: 5min, 20min, custom
    private var alertType = 2;  // Default: VIBRATION_AND_SOUND (0=vibration, 1=sound, 2=both)
    private var snoozeUntil = null;
    private var alarmCallback = null;

    function initialize(alarmCallback) {
        // Initialize with default snooze durations
        self.alarmCallback = alarmCallback;
        self.state = 0;  // AlarmState.IDLE
        
        // Load alert type from settings
        self.alertType = Settings.getSetting(Settings.KEY_ALERT_TYPE, Settings.DEFAULT_ALERT_TYPE);

        // Load snooze durations
        self.snoozeDurations[0] = Settings.getSetting(Settings.KEY_SNOOZE_1, Settings.DEFAULT_SNOOZE_1) as Lang.Number;
        self.snoozeDurations[1] = Settings.getSetting(Settings.KEY_SNOOZE_2, Settings.DEFAULT_SNOOZE_2) as Lang.Number;
        self.snoozeDurations[2] = Settings.getSetting(Settings.KEY_SNOOZE_3, Settings.DEFAULT_SNOOZE_3) as Lang.Number;
    }
    
    function update() {
        // Check if snooze period has expired
        if (self.state == 1 && self.snoozeUntil != null) {  // AlarmState.CHECKING
            var now = Time.now().value();
            if (now >= self.snoozeUntil) {
                System.println("Snooze expired - re-triggering alarm");
                triggerAlarm();
            }
        }
    }

    /**
     * Trigger the alarm - phone is confirmed lost
     */
    function triggerAlarm() {
        if (self.state == 2) {  // AlarmState.ALARMING
            return;  // Already active
        }
        
        self.state = 2;  // AlarmState.ALARMING
        System.println("ALARM TRIGGERED");
        
        // Play alert based on user preference
        if (Attention has :vibrate && 
            (self.alertType == 0 || 
             self.alertType == 2)) {  // VIBRATION_ONLY or VIBRATION_AND_SOUND
            var vibeData = [
                new Attention.VibeProfile(50, 1000),  // 1 second vibrate
                new Attention.VibeProfile(0, 500),    // 0.5 second pause
                new Attention.VibeProfile(50, 1000),  // 1 second vibrate
            ];
            Attention.vibrate(vibeData);
        }
        
        if (Attention has :playTone && 
            (self.alertType == 1 || 
             self.alertType == 2)) {  // SOUND_ONLY or VIBRATION_AND_SOUND
            Attention.playTone(Attention.TONE_ALARM);
        }
        
        // Notify UI to show alarm screen
        if (self.alarmCallback != null) {
            self.alarmCallback.invoke();
        }
    }

    /**
     * Snooze alarm for specified minutes
     */
    function snooze(minutes) {
        if (self.state == 2) {  // AlarmState.ALARMING
            var now = Time.now();
            var duration = new Time.Duration(minutes * 60);
            self.snoozeUntil = now.add(duration).value();
            self.state = 1;  // AlarmState.CHECKING
            
            System.println("Alarm snoozed for " + minutes + " minutes");
        }
    }

    /**
     * Dismiss alarm completely
     */
    function dismiss() {
        self.state = 0;  // AlarmState.IDLE
        self.snoozeUntil = null;
        System.println("Alarm dismissed");
    }

    function isAlarming() {
        return self.state == 2;  // AlarmState.ALARMING
    }

    function setSnoozeDurations(duration1, duration2, duration3) {
        self.snoozeDurations = [duration1, duration2, duration3] as Lang.Array<Lang.Number>;
    }

    /**
     * Set the alert type (universal setting for all alerts)
     * 0 = VIBRATION_ONLY, 1 = SOUND_ONLY, 2 = VIBRATION_AND_SOUND
     */
    function setAlertType(type) {
        self.alertType = type;
        Settings.setSetting(Settings.KEY_ALERT_TYPE, type);
    }

    function getAlertType() {
        return self.alertType;
    }
    
    function getState() {
        return self.state;
    }

}
