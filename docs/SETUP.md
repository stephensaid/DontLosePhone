# Don't Lose Phone (DLH) - Development Environment Setup

## Prerequisites

### 1. Java Development Kit (JDK)
The Garmin Connect IQ SDK requires Java 11 or later.
- **Download**: [Java SE Downloads](https://www.oracle.com/java/technologies/downloads/)
- **Verify**: Run `java -version` in your terminal

### 2. Garmin Connect IQ SDK

#### Download
1. Go to [Garmin Developer Portal](https://developer.garmin.com/)
2. Create an account or sign in
3. Navigate to **Connect IQ > SDK Downloads**
4. Download the latest SDK for Windows

#### Installation Steps
1. Extract the SDK to a known location (e.g., `C:\Garmin\connectiq-sdk`)
2. Add SDK to your PATH:
   - Open Windows System Properties
   - Go to **Environment Variables**
   - Add `C:\Garmin\connectiq-sdk\bin` to your PATH
3. Verify installation: Run `monkeyc -v` in terminal

#### SDK Structure
```
connectiq-sdk/
├── bin/              # Compiler & tools
├── devices/          # Device definitions
├── doc/              # Documentation
├── lib/              # Libraries
└── samples/          # Example projects
```

### 3. VS Code Setup

#### Install Extensions
1. Open VS Code
2. Install these extensions:
   - **Garmin Connect IQ** (by garmin) - provides syntax highlighting and build support
   - **Monkey C** - language support
   - **Code Runner** (optional) - for quick testing

#### Configure workspace settings
Create `.vscode/settings.json` in the project root:
```json
{
    "monkeyc.sdkPath": "C:\\Garmin\\connectiq-sdk",
    "monkeyc.simulatorPath": "C:\\Garmin\\connectiq-sdk\\bin\\connectiq",
    "editor.formatOnSave": true,
    "[monkey-c]": {
        "editor.defaultFormatter": "garmin.monkey-c",
        "editor.formatOnSave": true
    }
}
```

## Project Structure

```
DontLosePhone/
├── source/                    # Monkey C source files
│   ├── DontLosePhoneApp.mc    # Main application
│   ├── DontLosePhoneView.mc   # Main view/UI
│   ├── BluetoothMonitor.mc    # Bluetooth connectivity logic
│   ├── MotionGate.mc          # Motion detection logic
│   ├── GpsProximity.mc        # GPS distance checking
│   ├── AlarmController.mc     # Alarm management
│   └── Settings.mc            # User settings handling
│
├── resources/
│   ├── drawables/             # Images and graphics
│   ├── strings/               # Localized strings
│   │   └── strings.xml
│   └── layouts/               # XML layouts (if used)
│
├── manifest.xml               # App configuration & permissions
├── monkey.jungle              # Build configuration
├── SETUP.md                   # This file
└── docs/
    └── DLH User Guide.md      # Feature specification
```

## Building the Project

### Using VS Code

1. **Build Command**:
   - Press `Ctrl+Shift+B` or go to Terminal → Run Build Task
   - Select "Build Garmin App"

2. **Clean Build**:
   - `monkeyc -e -o bin/app.prg -f monkey.jungle`

### Using Command Line

```bash
# Navigate to project root
cd c:\Users\Stephen\Documents\Code\DontLosePhone

# Build for all devices
monkeyc -e -o bin/app.prg -f monkey.jungle

# Build for specific device
monkeyc -e -o bin/app.prg -d fenix7 -f monkey.jungle
```

## Running in Simulator

```bash
# Launch simulator
connectiq

# Load compiled app
# Or drag & drop app.prg into simulator window
```

## Next Steps

1. ✅ Set up Java and Garmin SDK
2. ✅ Install VS Code extensions
3. ⬜ Create core modules:
   - BluetoothMonitor (connection tracking)
   - MotionGate (accelerometer-based motion detection)
   - GpsProximity (GPS distance calculation)
   - AlarmController (alarm triggering & UI)
   - Settings (configuration management)
4. ⬜ Design alarm screen UI
5. ⬜ Implement button event handlers
6. ⬜ Test on simulator with various scenarios
7. ⬜ Build and deploy to device

## Resources

- [Garmin Connect IQ API Docs](https://developer.garmin.com/connect-iq/api-docs/)
- [Monkey C Language Guide](https://developer.garmin.com/connect-iq/monkey-c/)
- [Connect IQ Samples](https://github.com/garmin/connectiq-apps)

## Troubleshooting

**"monkeyc not found"**
- Verify Garmin SDK is in PATH
- Run `echo %PATH%` to check environment variables

**Build errors with permissions**
- Ensure manifest.xml lists required permissions:
  - `sensorHistory` (for motion/accelerometer)
  - `positioning` (for GPS)
  - `communications` (for Bluetooth)

**Simulator won't load app**
- Recompile with correct device ID
- Ensure device simulator is running first
