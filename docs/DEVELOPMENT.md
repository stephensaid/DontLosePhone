# Development Guide

## Prerequisites

1. **Garmin Connect IQ SDK 9.2.0**
   - Download via SDK Manager from [Garmin Developer Portal](https://developer.garmin.com/connect-iq/sdk/)
   - Installation location: `C:\Users\<Username>\AppData\Roaming\Garmin\ConnectIQ\Sdks\`

2. **VS Code Extensions**
   - Monkey C (Garmin)
   - Git

3. **Java Runtime** (required by SDK Manager)

## Initial Setup

### 1. Clone Repository

```bash
git clone https://github.com/stephensaid/DontLosePhone.git
cd DontLosePhone
```

### 2. Install Garmin SDK

1. Download and run SDK Manager from Garmin
2. Install Connect IQ SDK 9.2.0
3. Download target device support (Fenix 7, Venu 3, Epix 2, etc.)

### 3. Generate Developer Key

If you don't have a developer key yet:

1. Open SDK Manager
2. Go to **Tools** → **Generate Developer Key**
3. Save as `resources/strings/developer_key` (DER format)

**Note**: The repository includes a developer key, but you may need to generate your own for signing.

### 4. Configure Build Tasks

VS Code tasks are pre-configured in `.vscode/tasks.json`:

- **Build DLH App** (Ctrl+Shift+B): Compile the app
- **Run Simulator**: Launch Garmin simulator
- **Clean Build**: Remove bin/ and rebuild

Update SDK path in tasks if your installation differs:
```json
"C:\\Users\\Stephen\\AppData\\Roaming\\Garmin\\ConnectIQ\\Sdks\\connectiq-sdk-win-9.2.0-2026-06-09-92a1605b2\\bin\\monkeyc.bat"
```

## Building the App

### Command Line Build

```bash
# Windows
C:\Path\To\SDK\bin\monkeyc.bat --Eno-invalid-symbol -o bin/DontLosePhone.prg -f monkey.jungle -y resources/strings/developer_key

# The --Eno-invalid-symbol flag suppresses certain validation warnings
```

### VS Code Build

Press `Ctrl+Shift+B` or run task "Build DLH App"

**Expected Output:**
```
BUILD SUCCESSFUL
```

**Output Files:**
- `bin/DontLosePhone.prg` - Compiled executable (94 KB)
- `bin/DontLosePhone.prg.debug.xml` - Debug symbols

## Running in Simulator

### Using VS Code Task

Run task: "Run Simulator"

### Command Line

```bash
C:\Path\To\SDK\bin\connectiq.bat
```

Then in simulator:
1. File → Open App
2. Navigate to `bin/DontLosePhone.prg`
3. Select device (Fenix 7, Venu 3, etc.)

### Testing Features

- **Normal Watchface**: Should display time and connection status
- **Bluetooth Disconnect**: Difficult to simulate; requires physical device
- **Alarm Screen**: Triggered by three-tier logic (timeout + motion + GPS)

## Project Structure

```
DontLosePhone/
├── .github/
│   └── copilot-instructions.md  # AI assistant guidance
├── .vscode/
│   └── tasks.json            # Build tasks
├── docs/
│   ├── DLH User Guide.md     # Feature specification
│   ├── SETUP.md              # Environment setup
│   └── STATE_MACHINE.md      # Architecture design
├── source/                   # Monkey C source files
│   ├── DontLosePhoneApp.mc   # Main entry point
│   ├── DontLosePhoneView.mc  # UI rendering
│   ├── DontLosePhoneDelegate.mc  # Button handling
│   ├── BluetoothMonitor.mc   # BT connection monitoring
│   ├── MotionGate.mc         # Movement detection
│   ├── GpsProximity.mc       # GPS distance calculation
│   ├── AlarmController.mc    # Alarm management
│   └── Settings.mc           # Configuration
├── resources/
│   ├── strings.xml           # Text resources
│   ├── bitmaps.xml           # Image references
│   ├── strings/
│   │   └── developer_key     # Signing key (DER format)
│   └── images/
│       └── icon.png          # Launcher icon
├── manifest.xml              # App metadata
├── monkey.jungle             # Build configuration
└── README.md                 # Project overview
```

## Common Issues

### Language Server Errors

**Symptom**: VS Code shows "Undefined symbol" errors even after successful build

**Cause**: Language server cache or known extension issues

**Solution**: Trust the compiler output. If `BUILD SUCCESSFUL`, the code is correct.

### Enum Reference Errors

**Symptom**: `Undefined symbol ':EnumName' detected`

**Fix**: Use fully qualified enum names:
```monkeyc
// WRONG
var state = AlarmState.IDLE;

// CORRECT
var state = AlarmController.AlarmState.IDLE;
```

### Missing Permissions

**Symptom**: `Permission 'XYZ' required for '$.Toybox.XYZ'`

**Fix**: Add to `manifest.xml`:
```xml
<iq:permissions>
  <iq:uses-permission id="SensorHistory"/>
  <!-- Add others as needed -->
</iq:permissions>
```

### Invalid Device ID

**Symptom**: `Invalid device id found in the application manifest`

**Fix**: Check [Garmin Device List](https://developer.garmin.com/connect-iq/compatible-devices/) for correct IDs. Use `epix2` not `epix_gen2`.

## Monkey C Gotchas

1. **No Modern JavaScript**: No arrow functions, async/await, spread operators
2. **Type Casting**: Required for method callbacks
3. **String Concatenation**: Use `+` operator, not template literals
4. **Enums**: Must use fully qualified names
5. **Import Everything**: No auto-imports; add all Toybox modules manually

## Development Workflow

1. **Edit** source files in `source/`
2. **Build** using Ctrl+Shift+B
3. **Fix** any compilation errors
4. **Test** in simulator or on device
5. **Commit** with descriptive message
6. **Push** to GitHub

### Git Workflow

```bash
git add -A
git commit -m "feat: Add new feature description"
git push origin main
```

## Testing on Physical Device

1. Build app: `Build DLH App` task
2. Copy `bin/DontLosePhone.prg` to device via USB or Garmin Express
3. Install via "Connect IQ" folder on watch
4. Test Bluetooth disconnect scenarios
5. Verify GPS tracking works during walks

## Performance Considerations

- **GPS**: Main battery drain; only active when GPS Proximity enabled
- **Sensor Polling**: Heart rate checks have minimal impact
- **Update Loop**: Runs every 1 second; keep logic lightweight
- **Memory**: Watch has limited RAM; avoid large data structures

## Documentation

- **User Features**: See `docs/DLH User Guide.md`
- **Architecture**: See `docs/STATE_MACHINE.md`
- **SDK Setup**: See `docs/SETUP.md`
- **API Reference**: [Garmin Connect IQ API Docs](https://developer.garmin.com/connect-iq/api-docs/)

## Support

- **Issues**: [GitHub Issues](https://github.com/stephensaid/DontLosePhone/issues)
- **Garmin Forums**: [Connect IQ Developer Forum](https://forums.garmin.com/developer/connect-iq/)
- **SDK Docs**: [Connect IQ Documentation](https://developer.garmin.com/connect-iq/connect-iq-basics/)

## Next Steps

See project status in [.github/copilot-instructions.md](../.github/copilot-instructions.md) for current phase and upcoming features.
