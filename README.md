# Advanced Equipment Revamped (AE3)

<p align="center">
    <img src="https://github.com/A3-Root/Advanced-Equipment/blob/master/AE3_Revamped_Logo.png" width="512">
</p>

![version](https://img.shields.io/badge/version-1.0.0.0-blue)
[![build](https://github.com/A3-Root/Advanced-Equipment/actions/workflows/auto-release.yml/badge.svg?branch=master)](https://github.com/A3-Root/Advanced-Equipment/actions/workflows/auto-release.yml)
[![license](https://img.shields.io/badge/License-APL--SA-blue.svg)](https://github.com/A3-Root/Advanced-Equipment/blob/master/LICENSE)

**A modular framework and equipment pack for Arma 3.**

Advanced Equipment Revamped (AE3) delivers a functional terminal laptop running ArmaOS and a range of connected equipment such as generators, batteries, flash drives, solar panels, and interactable objects. It is designed as a complete mod, ready to use in missions and scenarios while also providing APIs for developers.

## What is AE3?

AE3 is both a **gameplay mod** and a **framework**. Players can interact with fully functional laptops, manage power systems, operate equipment, and access data through an in-game terminal interface. Developers can extend AE3 through its API.

### Core Components

AE3 provides six major systems:

#### 1. ArmaOS Terminal System
- **Unix-like shell interface** with familiar commands (ls, cd, cat, mkdir, rm, mv, cp, etc.)
- **Extensible command system** - easily add custom OS commands
- **28+ built-in commands** for filesystem, power, and system management
- **Retro terminal designs** - ArmaOS, C64, Apple II, Amber themes
- **9 keyboard layouts** - AR, DE, FR, HE, HU, IT, RU, TR, US
- **UI-on-Texture rendering** - network-optimized terminal display
- **Command history and autocomplete**
- **Shell script execution** with `.sh` files

#### 2. Virtual Filesystem
- **Hierarchical directory structure** stored in object variables
- **Unix-style permissions** - read, write, execute per owner/everyone
- **Mount/unmount support** for USB drives and remote filesystems
- **Complete file operations** - create, delete, move, copy, read, write
- **Ownership and permission management** with `chown` command
- **Path resolution system** with absolute and relative paths
- **Encrypted file support** - Caesar and Columnar cipher algorithms

#### 3. Power Management System
- **Battery simulation** - capacity in Wh, charge/discharge cycles
- **Power generators** - fuel-powered with consumption tracking
- **Solar panels** - dynamic output based on sun position and panel orientation
- **Power connections** - link devices to power sources
- **Consumption tracking** - per-device power requirements
- **Standby modes** - reduced power consumption when idle
- **CBA-configurable costs** - customize power consumption per operation

#### 4. ACE3 Integration
- **Interaction menus** - laptop access, power connections, equipment management
- **Animated interactions** - laptop lid opening/closing, desk drawers
- **Cargo system integration** - portable equipment with custom names
- **Progress bars** - for generator startup/shutdown
- **Mutex system** (`AE3_computer_mutex`) - prevents concurrent terminal access

#### 5. Zeus & Eden Editor Support
- **Zeus filesystem browser** - graphical file/directory management
- **Zeus modules** - Add User, Add File, Add Directory, Add Games, Add Security Commands
- **3DEN modules** - mission editor integration for device setup
- **Asset attributes interface** - power state, battery/fuel levels, IP address
- **Real-time status updates** - live monitoring of device states

#### 6. Multiplayer Infrastructure
- **Remote variable sync** - `sendVarToRemote`/`getRemoteVar` for cross-client state management
- **UI-on-Texture optimization** - transmits raw STRING data, renders locally
- **Network-safe serialization** - never transmits TEXT type over network
- **Player range detection** - efficient UI updates for nearby players only
- **Locality-aware operations** - server/client execution control

### Included Equipment
- **Terminal Laptop (ArmaOS)** — core interactive computer.
- **Flash Drive** — removable storage.
- **Solar Power Generator** — clean energy source.
- **Fuel/Electric Generators** — primary power supply.
- **Battery Units** — charge and discharge dynamically.
- **Interactable Lights & Lamps** — power-sensitive illumination.

## For Mod Developers

AE3 provides a rich API for building mods utilizing the armaOS Terminal:

### Filesystem API (16 functions)
Create, manage, and manipulate virtual filesystems on in-game objects:

```sqf
// Initialize filesystem on a laptop
[_laptop] call AE3_filesystem_fnc_initFilesystem;

// Create a file with permissions
[
    [],                                    // Pointer
    _laptop getVariable "AE3_filesystem",  // Filesystem
    "/home/user/data.txt",                 // Path
    "Secret data",                         // Content
    "user",                                // User
    "user",                                // Owner
    [[true, true, true], [true, false, false]] // Permissions
] call AE3_filesystem_fnc_createFile;

// Move files
[[], _filesystem, "/home/user/data.txt", "/tmp/data.txt", "user", false] call AE3_filesystem_fnc_mvObj;

// Mount USB drive
[[], _filesystem, _usbFilesystem, "/mnt/usb0", "user"] call AE3_filesystem_fnc_mount;
```

**Key Functions:**
- `createFile`, `createDir` - Create filesystem objects
- `delObj`, `mvObj` - Delete and move objects
- `mount`, `unmount` - External filesystem mounting
- `hasPermission` - Permission validation
- `resolvePntr` - Path resolution
- `writeToFile`, `getFile` - File I/O

### ArmaOS API (30+ functions)

Add custom OS commands and control terminal behavior:

```sqf
// Add a custom OS command
[
    _computer,
    "mycommand",           // Command name
    {
        params ["_computer", "_args", "_username"];
        // Command implementation
        [[["Command output"]]];
    },
    "My custom command description"
] call AE3_armaos_fnc_computer_addCustomCommand;

// Initialize computer with commands and users
[_laptop, ["root"], ["SecurePass123"], ["/root"]] call AE3_armaos_fnc_computer_initWithCommands;

// Add games (Snake)
[_computer, true] call AE3_armaos_fnc_computer_addGames;

// Add security tools (crypto/crack)
[_computer, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;

// Terminal output
[_computer, _username, [[["Success!", "#00ff00"]]]] call AE3_armaos_fnc_shell_stdout;
```

**Built-in Commands:**
- **File ops**: `ls`, `cat`, `cd`, `mkdir`, `rm`, `touch`, `cp`, `mv`, `find`
- **Permissions**: `chown`
- **System**: `clear`, `whoami`, `help`, `man`, `history`, `exit`, `date`, `echo`
- **Filesystem**: `mount`, `unmount`
- **Power**: `shutdown`, `standby`
- **Security**: `crypto`, `crack`

### Power Management API (20 functions)

Implement power systems for devices:

```sqf
// Initialize generator
[_generator, 100, 0.5, 50] call AE3_power_fnc_initGenerator; // 100L fuel, 0.5L/h, 50Wh

// Initialize solar panel with orientation function
[_solarPanel, 30, {_this}] call AE3_power_fnc_initSolarPanel; // 30Wh capacity

// Initialize battery (standalone or internal)
[_battery, 500, false] call AE3_power_fnc_initBattery; // 500Wh capacity

// Get battery level
private _result = [_battery] call AE3_power_fnc_getBatteryLevel;
_result params ["_levelWh", "_levelPercent", "_capacityWh"];

// Create power connection
[_laptop, _generator] call AE3_power_fnc_createPowerConnection;

// Turn on device
private _success = [_device] call AE3_power_fnc_turnOnDevice;
```

### Terminal API (10 functions)

Control terminal display and user input:

```sqf
// Add output lines to terminal
[_computer, _username, [[["Line 1"], ["Line 2", "#00ff00"]]]] call AE3_armaos_fnc_terminal_addLines;

// Update terminal display (UI-on-Texture safe)
[_computer, _username] call AE3_armaos_fnc_terminal_updateOutput;

// Set keyboard layout
[_computer, _username, "DE"] call AE3_armaos_fnc_terminal_setKeyboardLayout; // German

// Set custom prompt
[_computer, _username, "user@laptop:/home/user$ "] call AE3_armaos_fnc_terminal_setPrompt;
```

### FlashDrive API (6 functions)

USB drive item/object conversion and mounting:

```sqf
// Connect flash drive to laptop
[_laptop, player, "Item_FlashDisk_AE3_ID_1", _usbInterface] call AE3_flashdrive_fnc_connectFlashDrive;

// Mount flash drive filesystem
[_laptop, "usb0", "user"] call AE3_flashdrive_fnc_mount;

// Convert item to object
private _flashDriveObj = [player, "Item_FlashDisk_AE3_ID_1"] call AE3_flashdrive_fnc_item2obj;

// Convert object to item
[_flashDriveObj, player] call AE3_flashdrive_fnc_obj2item;
```

## For Mission Makers

Use AE3 to create custom terminal-based scenarios:

### Basic Laptop Setup

```sqf
// initServer.sqf
private _laptop = _laptop1; // Editor-placed laptop

// Add user account
[_laptop, "hacker", "password123"] remoteExec ["AE3_armaos_fnc_computer_addUser", 2];

// Add game programs
[_laptop, true] remoteExec ["AE3_armaos_fnc_computer_addGames", 2];

// Players can now log in and use the terminal!
```

### Custom Command Example

```sqf
// Add a mission-specific command
[
    _laptop,
    "sitrep",
    {
        params ["_computer", "_args", "_username"];

        private _enemyCount = {side _x == east} count allUnits;
        private _output = format ["Enemy forces: %1 units", _enemyCount];

        [[[_output, "#ffff00"]]];
    },
    "Display mission situation report"
] remoteExec ["AE3_armaos_fnc_computer_addCustomCommand", 2];
```

### Power Grid Setup

```sqf
// Create power grid with generator and solar panel
private _generator = _gen1;
private _solarPanel = _solar1;
private _laptop = _laptop1;

// Initialize power sources
[_generator, 100, 0.5, 50] remoteExec ["AE3_power_fnc_initGenerator", 2];
[_solarPanel, 30, {_this}] remoteExec ["AE3_power_fnc_initSolarPanel", 2];

// Connect laptop to generator
[_laptop, _generator] remoteExec ["AE3_power_fnc_createPowerConnection", 2];
```

## Requirements

### Dependencies (Required)

- **[CBA_A3](https://github.com/CBATeam/CBA_A3)** - Community Base Addons (settings, events, functions)
- **[ACE3](https://github.com/acemod/ACE3)** - Advanced Combat Environment 3 (interaction menus)
- **Arma 3 v2.12+** - Required for UI-on-Texture feature

## Installation

### Manual Installation

1. Download the latest release from [GitHub Releases](https://github.com/y0014984/Advanced-Equipment/releases)
2. Extract the `@AE3` folder to your Arma 3 directory
3. Add `-mod=@CBA_A3;@ace;@AE3` to your launch parameters

### Building from Source

Requires [HEMTT](https://github.com/BrettMayson/HEMTT):

```bash
# Clone repository
git clone https://github.com/y0014984/Advanced-Equipment.git
cd Advanced-Equipment

# Build for development (creates symlink)
hemtt dev

# Build for release
hemtt build

# Validate code
hemtt check
```

## Quick Start

### For Players

1. Interact with an AE3 laptop (ACE interaction menu)
2. Select **Equipment** � **Terminal** � **Use Terminal**
3. Log in with credentials (default: root/root if configured)
4. Use Unix commands: `ls`, `cd /home`, `help`, etc.
5. Type `help` to see all available commands

### For Zeus Curators

1. Open Zeus interface (Y key)
2. Find **Advanced Equipment** category
3. Place laptop, select it, open Asset Attributes
4. Use **Add User** module to create accounts
5. Use **Add File**/**Add Directory** modules to populate filesystem
6. Use filesystem browser to manage files graphically

### For Developers

1. Read the [API Reference](wiki/API-Reference.md) for complete function documentation
2. Study the [Architecture](wiki/Architecture.md) guide to understand data structures
3. Check [Mission Maker Guide](wiki/Mission-Maker-Guide.md) for practical examples

## Documentation

Comprehensive documentation is available in the [Wiki](/wiki):

- **[Home](wiki/Home.md)** - Framework overview and quick reference
- **[API Reference](wiki/API-Reference.md)** - Complete function reference with examples
- **[Architecture](wiki/Architecture.md)** - Technical implementation and data structures
- **[Terminal Guide](wiki/Terminal-Guide.md)** - ArmaOS commands and terminal usage
- **[Zeus Guide](wiki/Zeus-Guide.md)** - Zeus modules and interface
- **[Eden Editor Guide](wiki/Eden-Editor-Guide.md)** - 3DEN modules and synchronization
- **[Mission Maker Guide](wiki/Mission-Maker-Guide.md)** - API usage and mission examples
- **[Configuration](wiki/Configuration.md)** - CBA settings reference
- **[ACE Mutex](wiki/ACE-Mutex.md)** - Understanding the mutex system

## Configuration

AE3 uses CBA settings for customization. Access via:
- **Main Menu** → **Configure** → **Addon** → **AE3 armaOS**

Key settings:
- **Debug Mode** - Enable system chat debug messages
- **Power Costs** - Customize battery consumption per operation
- **Terminal Update Rate** - UI-on-Texture refresh frequency (default: 0.3s)
- **Network Debug** - Optional verbose logging of AE3 remoteExec traffic (diag_log; off by default)

See [Configuration Guide](wiki/Configuration.md) for complete settings reference.

## Architecture Highlights

### UI-on-Texture Network Optimization

AE3 uses a network-safe rendering approach:
- **Terminal buffer** (raw STRING/ARRAY) is synchronized across network
- **Rendered TEXT** is generated locally on each client
- **Throttled updates** - configurable refresh rate reduces network traffic
- **Viewport-only payloads** - only the visible window is transmitted, capped by `AE3_UiMaxTransmitLines` (defaults are recommended; raising this is not advised)
- **Usage-aware** - no UI-on-Texture traffic is sent when laptops are idle, UI-on-Texture is disabled, or no viewers are nearby

### Mutex System

Prevents concurrent terminal access:
```sqf
// Check if laptop is in use
private _mutex = _laptop getVariable ["AE3_computer_mutex", objNull];
if (isNull _mutex) then {
    // Laptop is available
    _laptop setVariable ["AE3_computer_mutex", player, true];
    // Use terminal...
    _laptop setVariable ["AE3_computer_mutex", objNull, true];
};
```

### Filesystem Storage

Virtual filesystems use nested hashmaps stored in object variables:
```sqf
_laptop getVariable "AE3_filesystem" // Returns hashmap
// Structure: {"." => {...}, "home" => {"user" => {...}}}
```

## Contributing

Contributions welcome! Please:

1. **Report Bugs** - Use [GitHub Issues](https://github.com/y0014984/Advanced-Equipment/issues)
2. **Suggest Features** - Open enhancement requests
3. **Submit Pull Requests**:
   - Fork the repository
   - Create feature branch
   - Follow existing code patterns
   - Run `hemtt check` - ensure all validation passes
   - Update documentation
   - Submit PR with description

### Development Guidelines

- Use **PREP macro** for function compilation (no `execVM`)
- Follow **SQFdoc header format** (see existing functions)
- Avoid undefined variables (caught by HEMTT)
- Use `private` for all variables
- Document public API functions thoroughly
- Test in multiplayer scenarios

### Code Style

```sqf
/*
 * Author: <NAME>
 * Description: Brief description of what the function does
 *
 * Arguments:
 * 0: _param1 <TYPE> - Description
 * 1: _param2 <TYPE> (Optional) - Description, default: value
 *
 * Return Value:
 * Description <TYPE>
 *
 * Example:
 * [_param1, _param2] call AE3_addon_fnc_functionName;
 *
 * Public: Yes/No
 */

params ["_param1", ["_param2", defaultValue]];

private _result = 0;

// Implementation...

_result
```

## License

Licensed under **Arma Public License - Share Alike (APL-SA)**.

Key terms:
- **Attribution** - Credit original authors
- **Non-Commercial** - No commercial use
- **Arma Only** - Only for Arma games
- **Share Alike** - Derivative works must use same license

See [LICENSE](LICENSE) for full terms.

## Credits

- **Root** - Current framework development and maintenance
- **y0014984** - Original AE3 development
- **Wasserstoff** and **JulesVerner** - Original AE3 Core contributions and development

## Mods Built on AE3

- **[Root's Cyber Warfare](https://github.com/A3-Root/Root_Cyberwarfare)** - Device hacking, GPS tracking, custom devices

*Building a mod on AE3? Let us know and we'll add it here!*

## Links

- [GitHub Repository](https://github.com/y0014984/Advanced-Equipment)
- [Issue Tracker](https://github.com/y0014984/Advanced-Equipment/issues)
- [Wiki Documentation](/wiki)
- [HEMTT Build Tool](https://github.com/BrettMayson/HEMTT)

---

*Advanced Equipment Revamped (AE3) — functional ArmaOS terminals and connected equipment for Arma 3.*
