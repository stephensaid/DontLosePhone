# Don't Lose Phone (DLH) - Garmin Watch App

A Garmin Connect IQ smartwatch application that acts as an active phone tether, detecting when you've left your phone behind through intelligent multi-tier protection logic.

## Features

### 🔐 Smart Protection Logic (3-Tier System)

1. **Tier 1: Connection Timeout**
   - Wait configurable seconds (up to 5 min) after Bluetooth drops
   - Prevents false alarms from temporary disconnects

2. **Tier 2: Motion Gate (Desk Mode)**
   - Stays silent if you're completely stationary
   - Only activates alarm if watch detects motion (standing & walking)

3. **Tier 3: GPS Proximity Guard**
   - Tracks last-known phone location
   - Only alarms when you walk past threshold (10m/20m/50m)

### 📱 Alarm Screen

- **Theme-Adaptive**: Automatically switches between light/dark based on watch setting
- **Real-Time Counter**: Shows elapsed time since connection lost
- **Dynamic Button Labels**: Displays snooze options and dismiss button
- **High Contrast**: Readable indoors and in sunlight

### 🎛️ Physical Button Controls

| Button                  | Function                                  |
| ----------------------- | ----------------------------------------- |
| **Top Right (Start)**   | Dismiss alarm (hardlocked)                |
| **Bottom Right (Back)** | Dismiss / Snooze 3 / Unset (configurable) |
| **Middle Left (Up)**    | Snooze 1 (default 5m)                     |
| **Bottom Left (Down)**  | Snooze 2 (default 20m)                    |

### ⚙️ Customizable Settings

- Timeout delay (seconds)
- Motion Gate toggle
- Snooze durations (1, 2, 3)
- Button functionality mapping
- GPS proximity threshold
- Distance filter on/off

## Target Devices

- Fenix Series (5, 5s, 6, 6s, 6x, 7, 7s, 7x, chronos)
- Epix Gen 2
- Venu Series (1, 2, 3, plus, s)

## Development

See [DEVELOPMENT.md](DEVELOPMENT.md) for setup instructions and development workflow.

**Quick Start:**
1. Install Garmin Connect IQ SDK 9.2.0
2. Clone repository
3. Build with `Ctrl+Shift+B` in VS Code
4. Run simulator to test

## Documentation

- **[DLH User Guide](docs/DLH%20User%20Guide.md)** - Complete feature specification
- **[STATE_MACHINE.md](docs/STATE_MACHINE.md)** - Architecture and state transitions
- **[SETUP.md](docs/SETUP.md)** - Environment setup instructions
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - Development workflow and guidelines
- **[.copilot-instructions.md](.copilot-instructions.md)** - AI assistant guidance

## Repository

- **GitHub**: [stephensaid/DontLosePhone](https://github.com/stephensaid/DontLosePhone)
- **License**: MIT (or specify your license)

## Project Status

- ✅ **Phase 1 Complete**: Core functionality (BT monitor, motion gate, GPS proximity, alarm)
- ⏳ **Phase 2**: Settings UI and enhanced status display
- ⏳ **Phase 3**: Advanced behaviors
- ⏳ **Phase 4**: Optimization and testing

## Project Structure

```
DontLosePhone/
├── source/                       # Monkey C source files
│   ├── DontLosePhoneApp.mc      # Main application
│   ├── DontLosePhoneView.mc     # Main UI view
│   ├── BluetoothMonitor.mc      # Bluetooth connectivity
│   ├── MotionGate.mc            # Motion detection
│   ├── GpsProximity.mc          # GPS distance logic
│   ├── AlarmController.mc       # Alarm & snooze management
│   └── Settings.mc              # User settings/preferences
│
├── resources/
│   ├── strings/strings.xml      # Localized UI strings
│   ├── drawables/               # Images & graphics
│   └── layouts/                 # UI layout definitions
│
├── docs/
│   └── DLH User Guide.md        # Feature specification
│
├── manifest.xml                 # App configuration & permissions
├── monkey.jungle                # Build configuration
├── SETUP.md                     # Development environment setup
└── README.md                    # This file
```

## Getting Started

### Prerequisites
- Java 11+
- Garmin Connect IQ SDK
- VS Code with Garmin Monkey C extension

### Setup

1. **Follow [SETUP.md](SETUP.md)** for complete environment configuration
2. **Install dependencies**:
   - Download Garmin SDK from [developer.garmin.com](https://developer.garmin.com/)
   - Add SDK to PATH

3. **Build the app**:
   ```bash
   monkeyc -e -o bin/DontLosePhone.prg -f monkey.jungle
   ```

4. **Run in simulator**:
   ```bash
   connectiq
   # Drag bin/DontLosePhone.prg into simulator window
   ```

## Development

### Build Tasks (VS Code)

- `Ctrl+Shift+B` → Build DLH App
- `Build for Device` → Compile for specific model
- `Clean Build` → Full rebuild
- `Run Simulator` → Launch Connect IQ simulator

### Key Modules

- **BluetoothMonitor**: Tracks connection state, triggers timeout countdown
- **MotionGate**: Reads accelerometer data, gates alarm on motion
- **GpsProximity**: Compares current position with last-known phone location
- **AlarmController**: Manages alarm state, snooze timers, vibration patterns
- **Settings**: Reads/writes user preferences from watch storage

## Architecture

```
BluetoothMonitor ──→ OnDisconnect
                         ├──→ Wait [Timeout]
                         └──→ Check MotionGate
                              ├──→ If Stationary: Silent, retry
                              └──→ If Motion: Check GpsProximity
                                   ├──→ If < Threshold: Silent, retry
                                   └──→ If >= Threshold: Trigger AlarmController
                                        └──→ Display AlarmScreen
```

## Testing

- Test on multiple device families (fenix7, venu3, epix)
- Simulate Bluetooth disconnect scenarios
- Verify motion gate with motion data injection
- Test GPS proximity with location mocking
- Validate button handling for all controls

## Resources

- [Garmin Connect IQ API](https://developer.garmin.com/connect-iq/api-docs/)
- [Monkey C Language Guide](https://developer.garmin.com/connect-iq/monkey-c/)
- [Connect IQ Sample Apps](https://github.com/garmin/connectiq-apps)

## License

[To be determined]

## Status

**Current Phase**: Environment Setup & Project Planning
- ✅ Project structure initialized
- ✅ Build configuration created
- ⬜ Core module implementation
- ⬜ Alarm screen UI
- ⬜ Testing & simulation
- ⬜ Device deployment
