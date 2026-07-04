# Copilot Instructions for Don't Lose Phone

## Project Overview

This is a Garmin Connect IQ smartwatch app written in **Monkey C** (NOT JavaScript/TypeScript). The app monitors Bluetooth connection to detect when the user has left their phone behind, using a three-tier protection system to minimize false alarms.

## Key Technologies

- **Language**: Monkey C (Garmin's proprietary language, similar to Java/C syntax)
- **SDK**: Garmin Connect IQ SDK 9.2.0
- **Target Platform**: Garmin smartwatches (Fenix 7, Venu 3, Epix Gen 2, etc.)
- **Build System**: monkeyc compiler with monkey.jungle configuration

## Code Conventions

### Monkey C Specific Rules

1. **Enum References**: Always use fully qualified names
   ```monkeyc
   // CORRECT
   var state = AlarmController.AlarmState.IDLE;
   
   // WRONG
   var state = AlarmState.IDLE;  // Undefined symbol error
   ```

2. **Method Type Casting**: Required for callbacks
   ```monkeyc
   Timer.start(method(:onUpdate) as Method() as Void, 1000, true);
   ```

3. **Imports**: Use Toybox namespace
   ```monkeyc
   import Toybox.WatchUi;
   import Toybox.Graphics;
   import Toybox.System;
   ```

4. **No Modern JS/TS Features**: No arrow functions, async/await, promises, spread operators, etc.

### Architecture Patterns

- **Three-Tier Protection Logic**: Connection Timeout → Motion Gate → GPS Proximity
- **Settings-First**: All configurable values loaded from Settings.mc
- **Battery Optimization**: GPS only active when enabled in settings
- **Module Separation**: Each protection tier is a separate class

## File Structure

```
source/
  ├── DontLosePhoneApp.mc       # Main app entry point & update loop
  ├── DontLosePhoneView.mc      # UI rendering (watchface + alarm screen)
  ├── DontLosePhoneDelegate.mc  # Button event handling
  ├── BluetoothMonitor.mc       # Tier 1: Connection timeout
  ├── MotionGate.mc             # Tier 2: Movement detection
  ├── GpsProximity.mc           # Tier 3: GPS distance calculation
  ├── AlarmController.mc        # Alarm state & vibration/sound
  └── Settings.mc               # Configuration management

resources/
  ├── strings.xml               # App name & text resources
  ├── bitmaps.xml               # Launcher icon reference
  └── images/icon.png           # Launcher icon (48x48 PNG)

docs/
  ├── DLH User Guide.md         # Feature specification
  ├── SETUP.md                  # Development environment setup
  └── STATE_MACHINE.md          # Architecture & state transitions

manifest.xml                    # App metadata & permissions
monkey.jungle                   # Build configuration
```

## Build System

### Compilation Command
```bash
monkeyc.bat --Eno-invalid-symbol -o bin/DontLosePhone.prg -f monkey.jungle -y resources/strings/developer_key
```

### Required Files
- **manifest.xml**: Must use `http://www.garmin.com/xml/connectiq` namespace (not developer.garmin.com)
- **monkey.jungle**: Specifies source paths and resource paths
- **developer_key**: RSA private key in DER format (generated via SDK Manager)

### Common Build Errors

1. **Enum Reference Errors**: Use `ClassName.EnumName.VALUE`
2. **Method Type Errors**: Cast callbacks with `as Method(...) as Void`
3. **Missing Permissions**: Add to manifest.xml with `<iq:uses-permission id="..."/>`
4. **Invalid Device IDs**: Use `epix2` not `epix_gen2`

## Development Workflow

1. **Make changes** to .mc files in `source/`
2. **Build** using VS Code task "Build DLH App" or monkeyc command
3. **Test** in simulator using "Run Simulator" task
4. **Check errors** in VS Code Problems panel (language server may show stale errors)
5. **Commit** with descriptive messages following Conventional Commits

## Testing Considerations

- **Bluetooth Disconnect**: Hard to simulate; test with real device
- **GPS Positioning**: Requires actual movement or simulator GPS injection
- **Motion Detection**: Heart rate sensor needs real data
- **Battery Impact**: GPS is the main drain; only active when enabled

## Important Notes

- **Language Server Issues**: VS Code Monkey C extension may show false positives; trust compiler output
- **Build Success**: If `monkeyc.bat` says "BUILD SUCCESSFUL", the code is correct
- **Enum Errors**: Most common issue; always use fully qualified enum names
- **No Strings in Manifest**: App name must reference `@Strings.AppName`, not literal text

## When Editing Code

1. **Always check** if enums are fully qualified with class name
2. **Verify imports** include all necessary Toybox modules
3. **Test build** after every significant change
4. **Follow existing patterns** in codebase (especially enum usage)
5. **Update Settings.mc** when adding new configurable parameters

## Documentation Conventions

- **All documentation files** must be created in the `docs/` folder
- **Markdown format** (.md) for all documentation
- **Naming convention**: Use descriptive names with spaces replaced by underscores or hyphens
- **Types of documentation**:
  - Feature specifications and user guides
  - Architecture and design documents
  - API documentation
  - Testing procedures
- **Root-level docs**: Only README.md, DEVELOPMENT.md, LICENSE, and .github/ folder should contain docs at root level
- **Update links**: When creating new docs, add references to README.md

## Phase Status

- ✅ **Phase 1**: Core functionality (BT monitor, motion gate, GPS proximity, alarm controller)
- ⏳ **Phase 2**: Settings UI, enhanced status display
- ⏳ **Phase 3**: Advanced behaviors (transport detection, persistent state)
- ⏳ **Phase 4**: Optimization & testing

## Quick Reference

**Permissions Required**: Communications, Positioning, Sensor, SensorHistory
**Min SDK Version**: 3.0.0
**Target Devices**: See manifest.xml `<iq:products>` section
**Alert Types**: VIBRATION_ONLY (0), SOUND_ONLY (1), VIBRATION_AND_SOUND (2)
