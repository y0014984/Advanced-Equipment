# Mission Maker Guide

This comprehensive guide is for mission makers who want to use the AE3 (Advanced Equipment) scripting API to create custom cyber warfare missions. Learn how to initialize laptops, manage power grids, create custom commands, and build complete mission scenarios.

---

## Table of Contents

- [Getting Started](#getting-started)
- [Core Concepts](#core-concepts)
- [Laptop Setup](#laptop-setup)
- [Filesystem Operations](#filesystem-operations)
- [Power Grid Management](#power-grid-management)
- [Network Configuration](#network-configuration)
- [Custom Commands](#custom-commands)
- [Terminal Customization](#terminal-customization)
- [Complete Mission Examples](#complete-mission-examples)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## Getting Started

### Prerequisites

- Basic SQF scripting knowledge
- AE3 mod installed and loaded
- Eden Editor or Zeus access
- Understanding of Arma 3 mission structure

### Basic Workflow

1. **Place objects** in Eden Editor (laptops, generators, routers)
2. **Write initialization scripts** to configure objects
3. **Test in preview** or with Zeus
4. **Iterate and refine** based on testing
5. **Package mission** for distribution

### Where to Put Your Code

**Option 1: Object Init Fields**
- Right-click object → Attributes → Init
- Good for simple, object-specific setup
- Example: `[this, "admin", "password"] call AE3_armaos_fnc_computer_addUser;`

**Option 2: init.sqf (Mission Root)**
- Executes when mission starts
- Good for global initialization
- Example: Setting up all laptops at once

**Option 3: Custom Script Files**
- Create `.sqf` files in mission folder
- Execute with `execVM` or `call compile preprocessFileLineNumbers`
- Good for complex, reusable setups

---

## Core Concepts

### Object References

AE3 functions operate on object references. Store references for easy access:

```sqf
// In object init field
this setVariable ["myLaptop", this, true];

// Later, in another script
private _laptop = missionNamespace getVariable ["myLaptop", objNull];
if (!isNull _laptop) then {
    // Use _laptop
};
```

### Execution Locality

Most AE3 functions must run on the **server**:

```sqf
// Wrap server-only code
if (isServer) then {
    [_laptop, "admin", "password"] call AE3_armaos_fnc_computer_addUser;
};
```

### Timing and Initialization

Filesystems initialize asynchronously. Use `waitUntil` or spawn delays:

```sqf
[_laptop] spawn {
    params ["_laptop"];

    // Wait for filesystem to exist
    waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };

    // Now safe to add files/users
    [_laptop, "admin", "password"] call AE3_armaos_fnc_computer_addUser;
};
```

### Permission Arrays

Permissions follow Unix-style format:

```sqf
// Structure: [[owner_x, owner_r, owner_w], [everyone_x, everyone_r, everyone_w]]
// x = execute, r = read, w = write

// Examples:
_permPublicRead = [[false, true, true], [false, true, false]];  // Owner R/W, Everyone R
_permPrivate = [[false, true, true], [false, false, false]];     // Owner R/W only
_permExecutable = [[true, true, false], [true, false, false]];   // Owner/Everyone can execute
```

---

## Laptop Setup

### Adding User Accounts

Create user accounts for login:

```sqf
/**
 * AE3_armaos_fnc_computer_addUser
 *
 * Arguments:
 * 0: _computer <OBJECT> - The laptop object
 * 1: _username <STRING> - Username (no spaces)
 * 2: _password <STRING> - Password
 *
 * Example:
 */
[_laptop, "admin", "admin123"] call AE3_armaos_fnc_computer_addUser;
[_laptop, "player", "password"] call AE3_armaos_fnc_computer_addUser;
[_laptop, "guest", "guest"] call AE3_armaos_fnc_computer_addUser;
```

**Auto-Creates:**
- User entry in userlist
- Home directory at `/home/<username>` (except for root)
- Proper permissions for home directory

---

### Adding Security Commands

Install crypto and crack tools:

```sqf
/**
 * AE3_armaos_fnc_computer_addSecurityCommands
 *
 * Arguments:
 * 0: _computer <OBJECT> - The laptop
 * 1: _includeCrypto <BOOL> - Add crypto command (encrypt/decrypt)
 * 2: _includeCrack <BOOL> - Add crack command (password cracking)
 *
 * Examples:
 */
[_laptop, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;   // Both
[_laptop, true, false] call AE3_armaos_fnc_computer_addSecurityCommands;  // Crypto only
[_laptop, false, true] call AE3_armaos_fnc_computer_addSecurityCommands;  // Crack only
```

---

### Adding Games

Install the Snake game:

```sqf
/**
 * AE3_armaos_fnc_computer_addGames
 *
 * Arguments:
 * 0: _computer <OBJECT> - The laptop
 * 1: _includeSnake <BOOL> - Add Snake game
 *
 * Example:
 */
[_laptop, true] call AE3_armaos_fnc_computer_addGames;
```

---

### Complete Laptop Initialization

Combine all setup in one script:

```sqf
// completeLaptopInit.sqf
params ["_laptop", "_userRole"];

if (!isServer) exitWith {};

[_laptop] spawn {
    params ["_laptop"];

    // Wait for filesystem
    waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };

    // Add users
    [_laptop, "admin", "SecurePass123"] call AE3_armaos_fnc_computer_addUser;
    [_laptop, "player", "password"] call AE3_armaos_fnc_computer_addUser;

    // Add security tools
    [_laptop, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;

    // Add game
    [_laptop, true] call AE3_armaos_fnc_computer_addGames;

    // Add welcome file
    [
        _laptop,
        "/home/player/README.txt",
        "Welcome to ArmaOS! Type 'help' for available commands.",
        false,
        "player",
        [[false, true, true], [false, true, false]]
    ] call AE3_filesystem_fnc_device_addFile;
};
```

**Usage in Eden Init Field:**
```sqf
[this, "player"] execVM "completeLaptopInit.sqf";
```

---

## Filesystem Operations

### Adding Files

Create files with content:

```sqf
/**
 * AE3_filesystem_fnc_device_addFile
 *
 * Arguments:
 * 0: _computer <OBJECT> - Device object
 * 1: _path <STRING> - Full file path
 * 2: _content <STRING> - File content
 * 3: _isCode <BOOL> - Compile as SQF code
 * 4: _owner <STRING> - Owner username
 * 5: _permissions <ARRAY> - Permission array
 * 6: _isEncrypted <BOOL> (Optional) - Encrypt content
 * 7: _encryptionAlgorithm <STRING> (Optional) - "caesar" or "columnar"
 * 8: _encryptionKey <STRING> (Optional) - Encryption key
 *
 * Examples:
 */

// Simple text file
[
    _laptop,
    "/tmp/notes.txt",
    "Meeting at 1800 hours.",
    false,
    "admin",
    [[false, true, true], [false, true, false]]
] call AE3_filesystem_fnc_device_addFile;

// Executable script
[
    _laptop,
    "/bin/custom_script.sqf",
    "hint 'Script executed!';",
    true,  // compile as code
    "root",
    [[true, true, false], [true, false, false]]  // executable
] call AE3_filesystem_fnc_device_addFile;

// Encrypted file
[
    _laptop,
    "/home/admin/classified.txt",
    "Secret intel data here...",
    false,
    "admin",
    [[false, true, true], [false, false, false]],
    true,  // encrypted
    "columnar",
    "SECRETKEY"
] call AE3_filesystem_fnc_device_addFile;
```

---

### Adding Directories

Create directories:

```sqf
/**
 * AE3_filesystem_fnc_device_addDir
 *
 * Arguments:
 * 0: _computer <OBJECT> - Device object
 * 1: _path <STRING> - Full directory path
 * 2: _owner <STRING> - Owner username
 * 3: _permissions <ARRAY> - Permission array
 *
 * Example:
 */
[
    _laptop,
    "/home/admin/documents",
    "admin",
    [[true, true, true], [true, true, false]]  // owner full access, everyone read/execute
] call AE3_filesystem_fnc_device_addDir;
```

---

### Creating Complex Filesystem Structures

Build directory trees:

```sqf
// Create mission-specific filesystem
[_laptop] spawn {
    params ["_laptop"];
    waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };

    // Create directories
    private _dirs = [
        ["/tmp/mission", "root", [[true, true, true], [true, true, false]]],
        ["/tmp/mission/intel", "admin", [[true, true, true], [false, false, false]]],
        ["/tmp/mission/logs", "root", [[true, true, true], [true, true, false]]]
    ];

    {
        _x params ["_path", "_owner", "_perms"];
        [_laptop, _path, _owner, _perms] call AE3_filesystem_fnc_device_addDir;
    } forEach _dirs;

    // Create files
    private _files = [
        ["/tmp/mission/README.txt", "Mission briefing here...", false, "root", [[false, true, true], [false, true, false]]],
        ["/tmp/mission/intel/target.txt", "Target location: Grid 123456", false, "admin", [[false, true, true], [false, false, false]]],
        ["/tmp/mission/logs/access.log", "Login: admin @ 0800\nLogin: player @ 0815", false, "root", [[false, true, false], [false, true, false]]]
    ];

    {
        _x params ["_path", "_content", "_isCode", "_owner", "_perms"];
        [_laptop, _path, _content, _isCode, _owner, _perms] call AE3_filesystem_fnc_device_addFile;
    } forEach _files;
};
```

---

## Power Grid Management

### Creating Power Connections

Connect devices to power sources:

```sqf
/**
 * AE3_power_fnc_createPowerConnection
 *
 * Arguments:
 * 0: _from <OBJECT> - Consumer device
 * 1: _to <OBJECT> - Power provider
 *
 * Examples:
 */
[_laptop, _generator] call AE3_power_fnc_createPowerConnection;
[_battery, _solarPanel] call AE3_power_fnc_createPowerConnection;
[_laptop, _battery] call AE3_power_fnc_createPowerConnection;
```

**Note:** Connections are asynchronous. Use in init fields or early in mission.

---

### Setting Battery Levels

Initialize battery charge:

```sqf
/**
 * AE3_power_fnc_setBatteryLevel
 *
 * Arguments:
 * 0: _battery <OBJECT> - Battery object
 * 1: _level <NUMBER> - Charge level (0.0 to 1.0)
 *
 * Examples:
 */
[_laptop, 0.5] call AE3_power_fnc_setBatteryLevel;   // 50% charge
[_battery, 1.0] call AE3_power_fnc_setBatteryLevel;  // 100% charge
[_laptop, 0.1] call AE3_power_fnc_setBatteryLevel;   // 10% charge (low power scenario)
```

---

### Setting Fuel Levels

Initialize generator fuel:

```sqf
/**
 * AE3_power_fnc_setFuelLevel
 *
 * Arguments:
 * 0: _generator <OBJECT> - Generator object
 * 1: _level <NUMBER> - Fuel level (0.0 to 1.0)
 *
 * Examples:
 */
[_generator, 0.75] call AE3_power_fnc_setFuelLevel;  // 75% fuel
[_generator, 0.2] call AE3_power_fnc_setFuelLevel;   // 20% fuel (low fuel scenario)
```

---

### Power State Control

Turn devices on/off:

```sqf
/**
 * Power state functions
 *
 * AE3_armaos_fnc_computer_turnOn
 * AE3_armaos_fnc_computer_turnOff
 * AE3_armaos_fnc_computer_standby
 *
 * Arguments:
 * 0: _computer <OBJECT> - The device
 *
 * Examples:
 */
[_laptop] call AE3_armaos_fnc_computer_turnOn;
[_laptop] call AE3_armaos_fnc_computer_turnOff;
[_laptop] call AE3_armaos_fnc_computer_standby;

// Conditional power control
if (isNight) then {
    [_laptop] call AE3_armaos_fnc_computer_standby;  // Save power at night
};
```

---

### Complete Power Grid Setup

```sqf
// Power grid initialization script
if (isServer) then {
    // Define objects (place these in Eden first)
    private _generator = generator1;
    private _battery = battery1;
    private _laptop1 = laptop1;
    private _laptop2 = laptop2;

    // Set initial levels
    [_generator, 0.5] call AE3_power_fnc_setFuelLevel;    // 50% fuel
    [_battery, 0.8] call AE3_power_fnc_setBatteryLevel;   // 80% charge

    // Create power connections
    [_battery, _generator] call AE3_power_fnc_createPowerConnection;
    [_laptop1, _battery] call AE3_power_fnc_createPowerConnection;
    [_laptop2, _battery] call AE3_power_fnc_createPowerConnection;

    // Turn on devices
    sleep 2;  // Wait for connections to establish
    [_laptop1] call AE3_armaos_fnc_computer_turnOn;
    [_laptop2] call AE3_armaos_fnc_computer_turnOn;
};
```

---

## Network Configuration

### Creating Network Connections

Connect devices to routers:

```sqf
/**
 * AE3_network_fnc_createNetworkConnection
 *
 * Arguments:
 * 0: _from <OBJECT> - Device to connect
 * 1: _to <OBJECT> - Router
 *
 * Examples:
 */
[_laptop, _router] call AE3_network_fnc_createNetworkConnection;
[_router1, _router2] call AE3_network_fnc_createNetworkConnection;  // Router to router
```

---

### Complete Network Setup

```sqf
// Network topology initialization
if (isServer) then {
    // Objects (place in Eden)
    private _router1 = router1;
    private _router2 = router2;
    private _playerLaptop = playerLaptop;
    private _enemyLaptop = enemyLaptop;

    // Create network topology
    // Player network
    [_playerLaptop, _router1] call AE3_network_fnc_createNetworkConnection;

    // Enemy network (separate)
    [_enemyLaptop, _router2] call AE3_network_fnc_createNetworkConnection;

    // Note: Router1 and Router2 are NOT connected, so networks are isolated
};
```

---

## Custom Commands

### Basic Custom Command

Create mission-specific terminal commands:

```sqf
/**
 * AE3_armaos_fnc_computer_addCustomCommand
 *
 * Arguments:
 * 0: _computer <OBJECT> - The laptop
 * 1: _commandName <STRING> - Command name (what players type)
 * 2: _commandPath <STRING> - Filesystem path (e.g., "/bin/mycommand")
 * 3: _commandCode <CODE or STRING> - SQF code to execute
 * 4: _description <STRING> (Optional) - Short description
 * 5: _manual <STRING> (Optional) - Full help text
 * 6: _owner <STRING> (Optional, default: "root") - Owner
 * 7: _permissions <ARRAY> (Optional) - Permissions
 *
 * Examples:
 */

// Simple command
[
    _laptop,
    "greet",
    "/bin/greet",
    {
        params ["_computer", "_options", "_commandName"];
        ["Hello, player!"] call AE3_armaos_fnc_shell_stdout;
    },
    "Greets the user",
    "GREET - Displays a greeting message\n\nUsage: greet"
] call AE3_armaos_fnc_computer_addCustomCommand;
```

---

### Advanced Custom Command with Arguments

```sqf
// Command that takes arguments
[
    _laptop,
    "hack",
    "/bin/hack",
    {
        params ["_computer", "_options", "_commandName"];

        // Parse arguments from _options
        private _target = _options param [0, ""];

        if (_target isEqualTo "") exitWith {
            ["Usage: hack <target_ip>"] call AE3_armaos_fnc_shell_stdout;
        };

        // Simulate hacking
        ["Attempting to hack " + _target + "..."] call AE3_armaos_fnc_shell_stdout;
        sleep 2;
        ["Connection established!"] call AE3_armaos_fnc_shell_stdout;
        sleep 1;
        ["Access granted."] call AE3_armaos_fnc_shell_stdout;

        // Trigger mission event
        missionNamespace setVariable ["hackSuccessful", true, true];
    },
    "Hack a target system",
    "HACK - Attempt to hack a remote system\n\nUsage: hack <target_ip>\n\nExample: hack 192.168.1.100"
] call AE3_armaos_fnc_computer_addCustomCommand;
```

---

### Mission-Specific Command with Objectives

```sqf
// Command to complete mission objective
[
    _laptop,
    "disable_alarm",
    "/bin/disable_alarm",
    {
        params ["_computer", "_options", "_commandName"];

        // Check if player is authorized
        private _currentUser = _computer getVariable ["AE3_terminal_currentUser", ""];
        if (_currentUser != "admin") exitWith {
            ["ERROR: Permission denied. Admin access required."] call AE3_armaos_fnc_shell_stdout;
        };

        // Disable alarm (mission logic)
        ["Disabling security alarm..."] call AE3_armaos_fnc_shell_stdout;
        sleep 3;
        ["Alarm disabled successfully."] call AE3_armaos_fnc_shell_stdout;

        // Trigger mission objective
        ["MissionObjective", "Alarm disabled"] call BIS_fnc_taskSetState;
        missionNamespace setVariable ["alarmDisabled", true, true];
    },
    "Disable the security alarm",
    "DISABLE_ALARM - Disables the facility security alarm\n\nRequires: Admin access\n\nUsage: disable_alarm"
] call AE3_armaos_fnc_computer_addCustomCommand;
```

---

### Command with Interactive Output

```sqf
// Command with formatted output
[
    _laptop,
    "status",
    "/bin/status",
    {
        params ["_computer", "_options", "_commandName"];

        // Display system status
        ["=== SYSTEM STATUS ==="] call AE3_armaos_fnc_shell_stdout;
        [""] call AE3_armaos_fnc_shell_stdout;

        private _powerState = [_computer] call AE3_power_fnc_getPowerState;
        ["Power: " + _powerState] call AE3_armaos_fnc_shell_stdout;

        private _batteryResult = [_computer] call AE3_power_fnc_getBatteryLevel;
        _batteryResult params ["_batteryLevel", "_batteryLevelPercent", "_batteryCapacity"];
        private _batteryText = format ["Battery: %1%2", round _batteryLevelPercent, "%"];
        [_batteryText] call AE3_armaos_fnc_shell_stdout;

        private _ip = _computer getVariable ["AE3_network_address", []];
        private _ipString = [_ip] call AE3_network_fnc_ip2str;
        ["IP Address: " + _ipString] call AE3_armaos_fnc_shell_stdout;

        [""] call AE3_armaos_fnc_shell_stdout;
        ["======================"] call AE3_armaos_fnc_shell_stdout;
    },
    "Display system status",
    "STATUS - Display detailed system information\n\nUsage: status"
] call AE3_armaos_fnc_computer_addCustomCommand;
```

---

## Terminal Customization

### Custom Boot Messages

Terminal boot messages are configured via CBA settings (see Configuration.md), but you can also set them per-computer:

```sqf
// Note: Terminal customization is primarily via CBA settings
// See Configuration.md for details on:
// - AE3_TerminalDialogTitle
// - AE3_TerminalBiosVersion
// - AE3_TerminalCopyright
// - AE3_TerminalBootMessage
// - AE3_TerminalTipMessage
// - AE3_TerminalTagline
```

---

## Complete Mission Examples

### Example 1: Intelligence Gathering Mission

**Objective:** Players must infiltrate an enemy laptop, crack an encrypted file, and extract intel.

```sqf
// missionInit.sqf

if (!isServer) exitWith {};

// Wait for objects to initialize
sleep 1;

// === PLAYER LAPTOP SETUP ===
private _playerLaptop = playerLaptop;  // Named in Eden Editor

[_playerLaptop] spawn {
    params ["_laptop"];
    waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };

    // Add player account
    [_laptop, "player", "password"] call AE3_armaos_fnc_computer_addUser;

    // Add security tools
    [_laptop, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;

    // Add mission briefing
    [
        _laptop,
        "/home/player/briefing.txt",
        "MISSION: Infiltrate enemy laptop and retrieve classified intel.\n\nTarget: enemyLaptop\nLocation: Enemy base\nPassword hint: Default admin password\n\nThe intel is encrypted. Use your tools to decrypt it.",
        false,
        "player",
        [[false, true, true], [false, true, false]]
    ] call AE3_filesystem_fnc_device_addFile;

    // Add password hint file
    [
        _laptop,
        "/home/player/hints.txt",
        "Common admin passwords:\n- admin123\n- password\n- admin\n- 12345678",
        false,
        "player",
        [[false, true, true], [false, true, false]]
    ] call AE3_filesystem_fnc_device_addFile;
};

// === ENEMY LAPTOP SETUP ===
private _enemyLaptop = enemyLaptop;  // Named in Eden Editor

[_enemyLaptop] spawn {
    params ["_laptop"];
    waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };

    // Add admin account with easy password
    [_laptop, "admin", "admin123"] call AE3_armaos_fnc_computer_addUser;

    // Add encrypted intel file
    [
        _laptop,
        "/home/admin/classified.txt",
        "CLASSIFIED INTEL:\n\nEnemy base coordinates: 123456\nSupply route: Route Alpha\nNext convoy: 0600 hours",
        false,
        "admin",
        [[false, true, true], [false, false, false]],  // Private to admin
        true,  // Encrypted
        "caesar",
        "13"  // ROT13
    ] call AE3_filesystem_fnc_device_addFile;

    // Add decoy files
    [
        _laptop,
        "/home/admin/notes.txt",
        "Remember to change default password...",
        false,
        "admin",
        [[false, true, true], [false, false, false]]
    ] call AE3_filesystem_fnc_device_addFile;
};

// === POWER SETUP ===
private _playerGenerator = playerGenerator;
private _enemyGenerator = enemyGenerator;

[_playerLaptop, _playerGenerator] call AE3_power_fnc_createPowerConnection;
[_enemyLaptop, _enemyGenerator] call AE3_power_fnc_createPowerConnection;

// === NETWORK SETUP ===
private _mainRouter = mainRouter;
[_playerLaptop, _mainRouter] call AE3_network_fnc_createNetworkConnection;
[_enemyLaptop, _mainRouter] call AE3_network_fnc_createNetworkConnection;

// === MISSION OBJECTIVE ===
private _task = player createSimpleTask ["retrieveIntel"];
_task setSimpleTaskDescription ["Retrieve the classified intel from the enemy laptop.", "Retrieve Intel", "Intel"];
_task setTaskState "Assigned";

// Monitor for completion (simplified)
[] spawn {
    waitUntil {
        sleep 5;
        // Check if player has decrypted file content in their clipboard or terminal
        // (This is a simplified check - implement proper detection based on your needs)
        missionNamespace getVariable ["intelRetrieved", false]
    };

    _task setTaskState "Succeeded";
    ["Intel retrieved successfully!"] remoteExec ["hint", player];
};
```

**Player Steps:**
1. Read `/home/player/briefing.txt` for mission details
2. Read `/home/player/hints.txt` for password hints
3. Travel to enemy laptop location
4. Login as `admin` with password `admin123`
5. Use `cat /home/admin/classified.txt` (will show encrypted text)
6. Use `crack caesar /home/admin/classified.txt` to decrypt
7. Read decrypted intel

---

### Example 2: Sabotage Mission with Power Grid

**Objective:** Players must hack into a control terminal and disable the enemy power grid.

```sqf
// sabotageInit.sqf

if (!isServer) exitWith {};

sleep 1;

// === CONTROL TERMINAL (Enemy Base) ===
private _controlTerminal = controlTerminal;

[_controlTerminal] spawn {
    params ["_laptop"];
    waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };

    // Add accounts
    [_laptop, "operator", "secure_pass"] call AE3_armaos_fnc_computer_addUser;
    [_laptop, "admin", "admin"] call AE3_armaos_fnc_computer_addUser;  // Weak password

    // Add custom sabotage command
    [
        _laptop,
        "shutdown_grid",
        "/bin/shutdown_grid",
        {
            params ["_computer", "_options", "_commandName"];

            // Check authorization
            private _currentUser = _computer getVariable ["AE3_terminal_currentUser", ""];
            if (_currentUser != "operator" && _currentUser != "admin") exitWith {
                ["ERROR: Insufficient privileges."] call AE3_armaos_fnc_shell_stdout;
            };

            // Confirm shutdown
            ["WARNING: This will disable the entire power grid!"] call AE3_armaos_fnc_shell_stdout;
            ["Initiating shutdown sequence..."] call AE3_armaos_fnc_shell_stdout;

            // Disable all generators
            {
                if (typeOf _x find "Generator" >= 0) then {
                    [_x] call AE3_power_fnc_turnOff;
                };
            } forEach (allMissionObjects "All");

            [""] call AE3_armaos_fnc_shell_stdout;
            ["POWER GRID OFFLINE"] call AE3_armaos_fnc_shell_stdout;

            // Trigger mission success
            missionNamespace setVariable ["gridShutdown", true, true];
        },
        "Shutdown the power grid",
        "SHUTDOWN_GRID - Emergency power grid shutdown\n\nRequires: Operator or Admin access\n\nWARNING: This will disable all power to the facility.\n\nUsage: shutdown_grid"
    ] call AE3_armaos_fnc_computer_addCustomCommand;

    // Add system files
    [
        _laptop,
        "/home/operator/manual.txt",
        "POWER GRID OPERATIONS MANUAL\n\nTo shutdown grid:\n1. Login as operator or admin\n2. Run: shutdown_grid\n\nEmergency password reset: Contact IT department",
        false,
        "operator",
        [[false, true, true], [false, true, false]]
    ] call AE3_filesystem_fnc_device_addFile;
};

// === PLAYER LAPTOP ===
private _playerLaptop = playerLaptop;

[_playerLaptop] spawn {
    params ["_laptop"];
    waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };

    [_laptop, "player", "password"] call AE3_armaos_fnc_computer_addUser;
    [_laptop, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;

    [
        _laptop,
        "/home/player/mission.txt",
        "SABOTAGE MISSION\n\nObjective: Disable enemy power grid\n\nIntel suggests the control terminal is in the main building.\nPassword is likely weak - try common passwords.\n\nOnce inside, find a way to shutdown the grid.",
        false,
        "player",
        [[false, true, true], [false, true, false]]
    ] call AE3_filesystem_fnc_device_addFile;
};

// === POWER GRID ===
private _mainGenerator = mainGenerator;
private _backupGenerator = backupGenerator;

// Connect all enemy systems to generators
{
    if (typeOf _x find "Laptop" >= 0 && _x != _playerLaptop) then {
        [_x, _mainGenerator] call AE3_power_fnc_createPowerConnection;
    };
} forEach (allMissionObjects "All");

// === NETWORK ===
private _router = mainRouter;
[_playerLaptop, _router] call AE3_network_fnc_createNetworkConnection;
[_controlTerminal, _router] call AE3_network_fnc_createNetworkConnection;

// === MISSION OBJECTIVE ===
private _task = player createSimpleTask ["disableGrid"];
_task setSimpleTaskDescription ["Disable the enemy power grid.", "Disable Power Grid", "Grid"];
_task setTaskState "Assigned";

// Monitor for completion
[] spawn {
    waitUntil {
        sleep 2;
        missionNamespace getVariable ["gridShutdown", false]
    };

    _task setTaskState "Succeeded";
    ["Power grid disabled! Mission successful!"] remoteExec ["hint", player];

    // Visual effect: Turn off all lights
    {
        if (typeOf _x find "Lamp" >= 0) then {
            _x setDamage 1;  // Simplified - destroy lamps to simulate blackout
        };
    } forEach (allMissionObjects "All");
};
```

**Player Steps:**
1. Read mission briefing on player laptop
2. Infiltrate enemy base
3. Access control terminal
4. Try common passwords (admin/admin works)
5. Read manual: `cat /home/operator/manual.txt`
6. Execute: `shutdown_grid`
7. Mission complete - all power disabled

---

### Example 3: Training Scenario with Custom Commands

**Objective:** Teach players how to use AE3 terminal with interactive tutorial.

```sqf
// trainingInit.sqf

if (!isServer) exitWith {};

sleep 1;

private _trainingLaptop = trainingLaptop;

[_trainingLaptop] spawn {
    params ["_laptop"];
    waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };

    // Add trainee account
    [_laptop, "trainee", "trainee"] call AE3_armaos_fnc_computer_addUser;

    // Add all tools
    [_laptop, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;
    [_laptop, true] call AE3_armaos_fnc_computer_addGames;

    // === TUTORIAL FILES ===
    private _tutorials = [
        ["/home/trainee/lesson1_basics.txt", "LESSON 1: BASIC COMMANDS\n\nTry these commands:\n- ls (list files)\n- pwd (print working directory)\n- cd /tmp (change directory)\n- cat lesson2_filesystem.txt (read next lesson)"],
        ["/home/trainee/lesson2_filesystem.txt", "LESSON 2: FILESYSTEM\n\nCreate a file:\n- touch myfile.txt\n\nCreate a directory:\n- mkdir myfolder\n\nMove files:\n- mv myfile.txt myfolder/\n\nRead lesson3_security.txt when ready."],
        ["/home/trainee/lesson3_security.txt", "LESSON 3: SECURITY\n\nEncrypt a file:\n- crypto encrypt caesar 13 /home/trainee/secret.txt /home/trainee/secret_encrypted.txt\n\nDecrypt a file:\n- crypto decrypt caesar 13 /home/trainee/secret_encrypted.txt /home/trainee/secret_decrypted.txt\n\nCrack encryption:\n- crack caesar /home/trainee/mystery.txt\n\nContinue to lesson4_games.txt"],
        ["/home/trainee/lesson4_games.txt", "LESSON 4: GAMES & EXTRAS\n\nPlay Snake:\n- snake\n\nCongratulations! You've completed the tutorial.\nUse 'complete_training' command to finish."],
        ["/home/trainee/secret.txt", "This is a secret message for encryption practice."],
        ["/home/trainee/mystery.txt", "Guvf vf ebg13 rapelcgrq. Penpx vg!"]  // ROT13 encoded
    ];

    {
        _x params ["_path", "_content"];
        [
            _laptop,
            _path,
            _content,
            false,
            "trainee",
            [[false, true, true], [false, true, false]]
        ] call AE3_filesystem_fnc_device_addFile;
    } forEach _tutorials;

    // Encrypt mystery file
    // (Note: The content above is already ROT13 - in real scenario, use crypto command or pre-encrypt)

    // === CUSTOM COMPLETION COMMAND ===
    [
        _laptop,
        "complete_training",
        "/bin/complete_training",
        {
            params ["_computer", "_options", "_commandName"];

            [""] call AE3_armaos_fnc_shell_stdout;
            ["==================================="] call AE3_armaos_fnc_shell_stdout;
            ["  TRAINING COMPLETE!"] call AE3_armaos_fnc_shell_stdout;
            ["==================================="] call AE3_armaos_fnc_shell_stdout;
            [""] call AE3_armaos_fnc_shell_stdout;
            ["You have mastered the ArmaOS terminal."] call AE3_armaos_fnc_shell_stdout;
            ["You are now ready for real missions."] call AE3_armaos_fnc_shell_stdout;
            [""] call AE3_armaos_fnc_shell_stdout;

            // Award training completion
            missionNamespace setVariable ["trainingComplete", true, true];
            player setVariable ["ae3_trainingComplete", true, true];
        },
        "Complete the training program",
        "COMPLETE_TRAINING - Finish the training and receive certification\n\nUsage: complete_training"
    ] call AE3_armaos_fnc_computer_addCustomCommand;

    // === HINT COMMAND ===
    [
        _laptop,
        "hint_next",
        "/bin/hint_next",
        {
            params ["_computer", "_options", "_commandName"];

            private _currentLesson = _computer getVariable ["currentLesson", 1];

            private _hints = [
                "Try: ls (to list files)",
                "Try: cat lesson1_basics.txt",
                "Try: cat lesson2_filesystem.txt",
                "Try: cat lesson3_security.txt",
                "Try: cat lesson4_games.txt",
                "Try: complete_training"
            ];

            private _hint = _hints select (_currentLesson - 1);
            ["HINT: " + _hint] call AE3_armaos_fnc_shell_stdout;
        },
        "Get a hint for the current lesson",
        "HINT_NEXT - Display a hint for what to do next\n\nUsage: hint_next"
    ] call AE3_armaos_fnc_computer_addCustomCommand;
};

// === MISSION OBJECTIVE ===
private _task = player createSimpleTask ["completeTraining"];
_task setSimpleTaskDescription ["Complete the ArmaOS training program.", "Complete Training", "Training"];
_task setTaskState "Assigned";

[] spawn {
    waitUntil {
        sleep 2;
        missionNamespace getVariable ["trainingComplete", false]
    };

    _task setTaskState "Succeeded";
    ["Training completed! You are now certified in ArmaOS operations."] remoteExec ["hint", player];
};
```

**Features:**
- Step-by-step tutorial files
- Hands-on exercises
- Custom hint system
- Completion command
- All tools available for practice

---

## Best Practices

### Code Organization

**1. Separate Concerns**
```sqf
// Good: Separate scripts for different systems
execVM "initLaptops.sqf";
execVM "initPowerGrid.sqf";
execVM "initNetwork.sqf";
execVM "initMissionLogic.sqf";

// Bad: Everything in one giant script
```

**2. Use Named Objects**
```sqf
// In Eden: Name objects (playerLaptop, enemyLaptop, mainGenerator)
// In script: Reference by name
private _laptop = playerLaptop;
```

**3. Comment Your Code**
```sqf
// === PLAYER LAPTOP SETUP ===
// This laptop is used by players for mission objectives
[_playerLaptop, "player", "password"] call AE3_armaos_fnc_computer_addUser;
```

---

### Error Handling

**1. Check Object Validity**
```sqf
if (isNull _laptop) exitWith {
    diag_log "ERROR: Laptop object is null!";
};
```

**2. Use Try-Catch for Filesystem Operations**
```sqf
try {
    [_laptop, "/tmp/file.txt", "content", false, "root", [[false,true,false],[false,true,false]]] call AE3_filesystem_fnc_device_addFile;
} catch {
    diag_log format ["Failed to create file: %1", _exception];
};
```

**3. Wait for Initialization**
```sqf
[_laptop] spawn {
    params ["_laptop"];
    waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };
    // Now safe to proceed
};
```

---

### Performance

**1. Minimize Network Traffic**
- Don't create unnecessary custom commands
- Batch file creation operations
- Use local scripts when possible

**2. Optimize Power Grids**
- Use efficient connection topology
- Don't create redundant connections
- Turn off unused devices

**3. Limit Complexity**
- Keep filesystem structures reasonable (<100 files per computer)
- Avoid deeply nested directories (>5 levels)
- Use simple network topologies when possible

---

### Testing

**1. Test Incrementally**
- Test each system separately (laptops, power, network)
- Add complexity gradually
- Preview mission frequently

**2. Test Edge Cases**
- What if player doesn't follow the intended path?
- What if power runs out?
- What if player tries to hack wrong laptop?

**3. Use Debug Logging**
```sqf
diag_log format ["[MISSION] Initialized laptop: %1", _laptop];
diag_log format ["[MISSION] Power connection: %1 -> %2", _laptop, _generator];
```

---

## Troubleshooting

### "Filesystem not initialized"

**Problem:** Functions fail because filesystem doesn't exist yet.

**Solution:**
```sqf
[_laptop] spawn {
    params ["_laptop"];
    waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };
    // Now filesystem is ready
};
```

---

### Custom Commands Not Appearing

**Problem:** Custom command doesn't show up in terminal.

**Solutions:**
- Verify command was added after filesystem initialization
- Check command name and path are correct
- Ensure permissions allow execution
- Test with `help` command to see if it's registered

---

### Power Connections Not Working

**Problem:** Laptop has no power despite connection.

**Solutions:**
- Check connection direction (consumer → provider)
- Verify generator has fuel or battery has charge
- Ensure connection was created after objects initialized
- Use Zeus Asset Attributes to debug

---

### Files Not Accessible

**Problem:** Players can't read files that should exist.

**Solutions:**
- Check file permissions (everyone needs read permission)
- Verify file owner matches logged-in user (or everyone has access)
- Ensure file path is correct (absolute path, no typos)
- Use `ls -la` to verify file exists and check permissions

---

### Network Issues

**Problem:** Devices can't communicate on network.

**Solutions:**
- Verify all devices connected to same router (or routers are connected)
- Check for cyclic router connections (not allowed)
- Use `ping` command to test connectivity
- Check Zeus Asset Attributes for IP addresses

---

## Related Documentation

- [API Reference](API-Reference.md) - Complete function reference
- [Zeus Guide](Zeus-Guide.md) - Live mission editing
- [Eden Editor Guide](Eden-Editor-Guide.md) - Eden Editor setup
- [armaOS Commands](armaOS-Commands.md) - Terminal commands reference
- [Configuration](Configuration.md) - CBA settings

---

**Need More Help?**

Visit the [Home](Home.md) page for community support and additional resources.
