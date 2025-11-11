# AE3 Architecture Guide

This document describes the system architecture, data structures, and design patterns used in the Advanced Equipment (AE3) framework.

## Table of Contents

1. [Overview](#overview)
2. [Data Storage Patterns](#data-storage-patterns)
3. [Initialization Flow](#initialization-flow)
4. [Filesystem Structure](#filesystem-structure)
5. [Terminal System](#terminal-system)
6. [Power Management Architecture](#power-management-architecture)
7. [Network System](#network-system)
8. [Multiplayer Synchronization](#multiplayer-synchronization)
9. [Performance Considerations](#performance-considerations)
10. [Best Practices](#best-practices)

---

## Overview

AE3 is a modular framework organized into self-contained addons. Each addon provides specific functionality while relying on shared patterns and data structures.

### Addon Structure

```
addons/
├── main/           # Core framework, Zeus UI, debug, remote sync
├── armaos/         # Terminal/shell system, OS commands
├── filesystem/     # Virtual filesystem with permissions
├── network/        # Network simulation, routers, DHCP
├── power/          # Power grid, batteries, generators
├── flashdrive/     # USB flash drive items
└── interaction/    # ACE3 interaction menus
```

### Key Design Principles

1. **Object-Centric Storage** - State is stored in object variables, not globals
2. **Permission-Based Access** - Filesystem uses Unix-like permission model
3. **Network Serialization** - Only transmit serializable types (STRING, ARRAY, NUMBER, BOOL, OBJECT, CODE)
4. **Locality Awareness** - Functions handle server/client execution contexts
5. **Multiplayer-First** - Designed for networked play with 67+ player support

---

## Data Storage Patterns

### Object Variables

Most state is stored directly on objects using `setVariable`/`getVariable`:

```sqf
// Computer state
_computer getVariable "AE3_filesystem"           // Filesystem object
_computer getVariable "AE3_filepointer"          // Current directory
_computer getVariable "AE3_Userlist"             // User accounts hashmap
_computer getVariable "AE3_Links"                // Command links hashmap
_computer getVariable "AE3_terminal"             // Terminal state (local, not synced)
_computer getVariable "AE3_terminal_sync"        // Terminal sync data
_computer getVariable "AE3_computer_mutex"       // Mutex lock for concurrent access

// Power state
_device getVariable "AE3_power_powerState"       // -1: Off, 0: Standby, 1: On
_device getVariable "AE3_power_batteryLevel"     // Battery level in kWh
_device getVariable "AE3_power_batteryCapacity"  // Battery capacity in kWh
_device getVariable "AE3_power_mutex"            // Power operation mutex

// Network state
_router getVariable "AE3_network_dhcp"           // DHCP server data
_device getVariable "AE3_network_ip"             // Assigned IP address
_device getVariable "AE3_network_connections"    // Network connections
```

### Hashmaps

Hashmaps are used for structured data that needs fast lookups:

```sqf
// User list: username -> password
_userlist = createHashMap;
_userlist set ["admin", "password123"];
_userlist set ["guest", ""];

// Command links: command name -> [path, description, manual]
_links = createHashMap;
_links set ["ls", ["/bin/ls", "List directory contents", "Usage: ls [-l] [PATH]"]];

// Terminal state
_terminal = createHashMapFromArray [
    ["AE3_terminalBuffer", []],
    ["AE3_terminalRenderedBuffer", []],
    ["AE3_terminalScrollPosition", 0],
    ["AE3_terminalApplication", "LOGIN"],
    // ... more fields
];
```

**Important Notes:**
- Hashmaps are NOT automatically network-synced
- Must manually sync critical hashmap data
- Store hashmaps in object variables when they need to persist
- Use arrays for data that needs to be transmitted via `remoteExec`

### Arrays for Serialization

Arrays are used for data that needs to be transmitted across the network:

```sqf
// Filesystem object structure: [content, owner, permissions]
_fileObject = [
    "File content here",           // Content (string, code, or hashmap for directories)
    "root",                        // Owner
    [[true,true,true],[false,false,false]]  // Permissions [[owner x,r,w],[everyone x,r,w]]
];

// Directory pointer (absolute path as array)
_pointer = [];                     // Root directory /
_pointer = ["home", "user"];       // /home/user
_pointer = ["tmp", "logs"];        // /tmp/logs

// Terminal sync data (serializable types only)
_syncData = [
    _rawBuffer,        // ARRAY - Raw terminal buffer (strings)
    _application,      // STRING - Current application
    _prompt,           // STRING - Terminal prompt
    _scrollPos,        // NUMBER - Scroll position
    _username,         // STRING - Logged in user
    _commandHistory    // HASHMAP - Command history (will be serialized)
];
```

---

## Initialization Flow

### PreInit Phase

Functions are compiled during preInit using the CBA PREP macro system:

```sqf
// In XEH_preInit.sqf
#include "script_component.hpp"
#include "XEH_PREP.hpp"

// XEH_PREP.hpp contains:
PREP(functionName1);
PREP(functionName2);
PREP(functionName3);
```

The PREP macro (from `script_macros.hpp`) compiles functions and makes them available globally:

```sqf
// PREP macro expands to:
AE3_addon_fnc_functionName = compile preprocessFileLineNumbers "\z\ae3\addons\addon\functions\fnc_functionName.sqf";
```

### PostInit Phase

Devices are initialized after all functions are compiled:

```sqf
// 1. Initialize filesystem
[_laptop] call AE3_filesystem_fnc_initFilesystem;

// 2. Add users
[_laptop, "admin", "admin123"] call AE3_armaos_fnc_computer_addUser;

// 3. Initialize commands
[_laptop, ["all"], true, true, []] call AE3_armaos_fnc_computer_initWithCommands;

// 4. Initialize power system
[_laptop] call AE3_power_fnc_compileDevice;

// 5. Initialize interactions
[_laptop] call AE3_interaction_fnc_compileEquipment;
```

### Function Compilation Pattern

Each addon follows this structure:

1. **script_component.hpp** - Defines COMPONENT name and includes main headers
2. **script_macros.hpp** - Provides CBA-based utility macros (PREP, etc.)
3. **script_mod.hpp** - Defines global prefixes and version macros
4. **XEH_PREP.hpp** - Lists all functions to compile
5. **XEH_preInit.sqf** - Includes XEH_PREP.hpp and runs preInit code
6. **XEH_postInit.sqf** - Runs postInit code after all addons loaded

---

## Filesystem Structure

### Hashmap Schema

The filesystem uses nested hashmaps to represent directories:

```sqf
// Root filesystem object
_filesystem = [
    _rootContent,      // HASHMAP - Directory contents
    "root",            // STRING - Owner
    [[true,true,true],[true,true,false]]  // ARRAY - Permissions
];

// Directory contents (hashmap)
_rootContent = createHashMapFromArray [
    ["home", _homeDir],
    ["tmp", _tmpDir],
    ["bin", _binDir],
    ["etc", _etcDir]
];

// Example file object
_fileObject = [
    "Hello World",     // STRING - File content
    "root",            // STRING - Owner
    [[false,true,true],[false,false,false]]  // ARRAY - Permissions
];

// Example directory object
_dirObject = [
    createHashMap,     // HASHMAP - Empty directory
    "user",            // STRING - Owner
    [[true,true,true],[false,false,false]]  // ARRAY - Permissions
];

// Example executable file
_execFile = [
    compile "hint 'test'",  // CODE - Compiled SQF code
    "root",                 // STRING - Owner
    [[true,true,false],[true,false,false]]  // ARRAY - Permissions
];
```

### Path Resolution

Paths are resolved to pointers (arrays of directory names):

```sqf
// Absolute paths
"/home/user"           -> ["home", "user"]
"/tmp/logs/system"     -> ["tmp", "logs", "system"]
"/"                    -> []

// Relative paths (require current pointer)
// If current pointer is ["home", "user"]:
"documents"            -> ["home", "user", "documents"]
"../admin"             -> ["home", "admin"]
"../../tmp"            -> ["tmp"]
"."                    -> ["home", "user"]

// Special paths
"~"                    -> ["home", <username>] or ["root"] for root user
"~/documents"          -> ["home", <username>, "documents"]
```

### Permission Checking

Permissions are checked before file operations:

```sqf
// Permission array format: [[owner x,r,w],[everyone x,r,w]]
_permissions = [
    [true, true, true],      // Owner: execute, read, write
    [false, true, false]     // Everyone: read only
];

// Permission indices
0 = Execute permission
1 = Read permission
2 = Write permission

// Check permission
[_fileObject, _user, 1] call AE3_filesystem_fnc_hasPermission;  // Check read

// Permission rules
// 1. Root user always has access
// 2. Empty owner ("") allows everyone
// 3. Check "everyone" permissions first
// 4. If user is owner, check "owner" permissions
// 5. Throw exception if denied
```

### Mount Points

External filesystems (USB drives) are mounted by replacing directory objects:

```sqf
// Before mount: /mnt/usb is empty directory
_mntContent get "usb" = [createHashMap, "root", [[true,true,true],[false,false,false]]];

// After mount: /mnt/usb points to flash drive filesystem
_mntContent set ["usb", _flashdriveFilesystem];

// Unmount: Replace with empty directory again
_mntContent set ["usb", [createHashMap, _oldOwner, _oldPermissions]];
```

---

## Terminal System

### Terminal State

The terminal state is stored in a hashmap attached to the computer:

```sqf
_terminal = createHashMapFromArray [
    ["AE3_terminalBuffer", []],                  // Raw buffer (STRING/ARRAY types)
    ["AE3_terminalRenderedBuffer", []],          // Rendered buffer (TEXT type - local only)
    ["AE3_terminalBufferVisible", []],           // Visible portion after scrolling
    ["AE3_terminalScrollPosition", 0],           // Scroll offset
    ["AE3_terminalCursorLine", 0],               // Current cursor line
    ["AE3_terminalCursorPosition", 0],           // Current cursor position
    ["AE3_terminalCommandHistory", createHashMap], // Per-user command history
    ["AE3_terminalCommandHistoryIndex", -1],     // History navigation index
    ["AE3_terminalComputer", _computer],         // Reference to computer object
    ["AE3_terminalPrompt", "admin@armaOS:/>"],   // Current prompt string
    ["AE3_terminalApplication", "SHELL"],        // Current application (LOGIN, SHELL, INPUT)
    ["AE3_terminalLoginUser", "admin"],          // Current logged in user
    ["AE3_terminalSize", 0.75],                  // Font size multiplier
    ["AE3_terminalMaxRows", 26],                 // Max visible rows
    ["AE3_terminalMaxColumns", 80],              // Max columns before wrap
    ["AE3_terminalDesign", 0],                   // Terminal theme (0-3)
    ["AE3_terminalAllowedKeys", _keymap],        // Keyboard layout mapping
    ["AE3_terminalOutput", _control],            // UI control reference
    ["AE3_terminalProcess", nil]                 // Current running process handle
];
```

### UI-on-Texture Rendering

AE3 supports rendering the terminal directly on the laptop's texture in the 3D world:

**Key Principles:**

1. **Raw Buffer Transmission** - Only send STRING/ARRAY data, never TEXT (structured text)
2. **Local Rendering** - Each client renders the buffer locally to avoid serialization overhead
3. **Throttled Updates** - Updates limited to once per 0.3s (configurable) to reduce network traffic
4. **Player Range** - Only sync to players within range (default 3m)

```sqf
// BAD - Causes TEXT serialization warnings (millions of warnings!)
private _renderedText = text "Hello World";
[_computer, _renderedText] remoteExec ["someFunction", _targets];

// GOOD - Send raw string, render locally
private _rawString = "Hello World";
[_computer, _rawString] remoteExec ["someFunction", _targets];
// In someFunction:
private _renderedText = text _rawString;
```

**Update Flow:**

```sqf
// 1. Check throttle (fnc_terminal_updateOutput)
private _lastUpdate = _terminal getOrDefault ["AE3_lastRemoteUpdateTime", 0];
if (time - _lastUpdate > 0.3) then {
    // 2. Send raw buffer data
    private _rawBuffer = _terminal get "AE3_terminalBuffer";
    [_computer, _rawBuffer, _size, _scroll, _design, _cursor] remoteExec
        ["AE3_armaos_fnc_terminal_uiOnTex_updateOutput", _playersInRange];

    // 3. Clients render locally (fnc_terminal_uiOnTex_updateOutput)
    // Reconstructs TEXT from STRING data on each client
};
```

### Terminal Themes

Four retro terminal themes available (controlled by `AE3_TerminalDesign` CBA setting):

- **0: ArmaOS** - Modern green-on-black terminal
- **1: C64** - Commodore 64 blue-on-blue theme
- **2: Apple II** - Apple II green-on-black theme
- **3: Amber** - Amber monochrome monitor theme

### Keyboard Layouts

Nine keyboard layouts supported (controlled by `AE3_KeyboardLayout` CBA setting):

- US (English)
- DE (German)
- FR (French)
- IT (Italian)
- RU (Russian)
- AR (Arabic)
- HE (Hebrew)
- HU (Hungarian)
- TR (Turkish)

Each layout has a dedicated function (`fnc_terminal_getAllowedKeys<LAYOUT>`) that returns a hashmap mapping DIK codes to characters.

### Command Processing Flow

```
User Input
    |
    v
terminal_addChar (add character to input buffer)
    |
    v
User presses Enter
    |
    v
shell_process (parse command string)
    |
    v
shell_executeFile (load file from filesystem)
    |
    v
Execute CODE from file
    |
    v
shell_stdout (output results)
    |
    v
terminal_updateOutput (render to display)
```

---

## Power Management Architecture

### Device Power Variables

```sqf
// Power state
_device getVariable "AE3_power_powerState"       // -1: Off, 0: Standby, 1: On
_device getVariable "AE3_power_mutex"            // BOOL - Prevents concurrent operations

// Battery devices
_battery getVariable "AE3_power_batteryLevel"    // NUMBER - Current level in kWh
_battery getVariable "AE3_power_batteryCapacity" // NUMBER - Total capacity in kWh

// Generator devices
_generator getVariable "AE3_power_fuelLevel"     // NUMBER - Fuel level
_generator getVariable "AE3_power_fuelCapacity"  // NUMBER - Fuel capacity
_generator getVariable "AE3_power_output"        // NUMBER - Power output in kW

// Solar panel devices
_solar getVariable "AE3_power_output"            // NUMBER - Current power output
_solar getVariable "AE3_power_maxOutput"         // NUMBER - Maximum output in kW

// Power connections
_device getVariable "AE3_power_connections"      // ARRAY - Connected devices
_device getVariable "AE3_power_providers"        // ARRAY - Power provider devices
```

### Power Calculation

Power consumption/generation is calculated in real-time:

```sqf
// Battery discharge
_batteryLevel = _batteryLevel - (_consumption * _deltaTime);

// Solar panel output (time of day + orientation)
_solarOutput = _maxOutput * _timeMultiplier * _orientationMultiplier;

// Generator fuel consumption
_fuelLevel = _fuelLevel - (_consumption * _deltaTime);
```

### Power Mutex System

The power mutex prevents concurrent power operations:

```sqf
// Check mutex before operation
if (!(_device getVariable ["AE3_power_mutex", false])) then {
    // Set mutex
    _device setVariable ["AE3_power_mutex", true, true];

    // Perform operation
    [_device] call AE3_power_fnc_turnOnDevice;

    // Clear mutex
    _device setVariable ["AE3_power_mutex", false, true];
};
```

---

## Network System

### Network Topology

```
Router (DHCP Server)
    |
    +-- Device 1 (IP: 192.168.1.10)
    +-- Device 2 (IP: 192.168.1.11)
    +-- Router 2 (IP: 192.168.1.12)
            |
            +-- Device 3 (IP: 192.168.2.10)
            +-- Device 4 (IP: 192.168.2.11)
```

### Network Variables

```sqf
// Router
_router getVariable "AE3_network_dhcp"           // HASHMAP - DHCP server data
_router getVariable "AE3_network_connections"    // ARRAY - Connected devices

// Device
_device getVariable "AE3_network_ip"             // ARRAY - IP address [192,168,1,10]
_device getVariable "AE3_network_router"         // OBJECT - Connected router
_device getVariable "AE3_network_connections"    // ARRAY - Network connections
```

### DHCP Assignment

IP addresses are automatically assigned when devices connect to routers:

```sqf
// DHCP assigns next available IP
_nextIP = [192, 168, 1, 10];
_device setVariable ["AE3_network_ip", _nextIP];
_dhcpTable set [_deviceNetID, _nextIP];
```

### Cyclic Connection Detection

The network system prevents cyclic connections (loops):

```sqf
// Check for cycles before connecting
if ([_router1, _router2] call AE3_network_fnc_connect_isCyclic) then {
    hint "Cyclic connection detected - connection prevented";
};
```

---

## Multiplayer Synchronization

### Remote Variable Sync

AE3 provides functions for syncing variables across the network:

```sqf
// On server: Send variable to client
[_clientOwner, _namespace, "variableName"] call AE3_main_fnc_sendVarToRemote;

// On client: Get variable from server
[_namespace, "variableName"] call AE3_main_fnc_getRemoteVar;
// Waits until variable is received
```

**How it works:**

```sqf
// Server side (sendVarToRemote)
private _value = _namespace getVariable _variable;
_namespace setVariable [_variable, _value, _caller];  // Send to specific client
_namespace setVariable [_variable + "_trans", true, _caller];  // Signal transfer complete

// Client side (getRemoteVar)
_namespace setVariable [_transfer, false];  // Reset transfer flag
[clientOwner, _namespace, _variable] remoteExecCall ["AE3_main_fnc_sendVarToRemote", 2];
waitUntil { _namespace getVariable [_transfer, false]; };  // Wait for transfer
_namespace setVariable [_transfer, nil];  // Clean up
```

### Terminal Sync

Terminal state is synced for player continuity:

```sqf
// When player closes terminal (standby/exit)
private _syncData = [
    _rawBuffer,        // Terminal buffer (raw strings)
    _application,      // Current application state
    _prompt,           // Current prompt
    _scrollPos,        // Scroll position
    _username,         // Logged in user
    _commandHistory    // Command history
];
_computer setVariable ["AE3_terminal_sync", _syncData, 2];  // Sync to server

// When player reopens terminal
[_computer, "AE3_terminal_sync"] call AE3_main_fnc_getRemoteVar;
private _syncData = _computer getVariable ["AE3_terminal_sync", nil];
if (!isNil "_syncData") then {
    // Restore terminal state
    _terminal set ["AE3_terminalBuffer", _syncData select 0];
    _terminal set ["AE3_terminalApplication", _syncData select 1];
    // ... restore other fields
};
```

### Locality Handling

Functions handle locality based on execution context:

```sqf
// Server-only execution
if (!isServer) exitWith {};

// Client-only execution
if (isDedicated) exitWith {};

// Scheduled vs unscheduled context
if (canSuspend) then {
    // Scheduled context - can use sleep, waitUntil
    [_computer, "AE3_terminal"] call AE3_main_fnc_getRemoteVar;
    waitUntil { condition };
} else {
    // Unscheduled context - use spawn
    [_computer, _data] spawn {
        params ["_computer", "_data"];
        [_computer, "AE3_terminal"] call AE3_main_fnc_getRemoteVar;
        // ... rest of code
    };
};
```

---

## Performance Considerations

### Network Optimization

1. **Throttle Updates** - Limit terminal updates to once per 0.3s
2. **Range-Based Sync** - Only sync to players within range (3m default)
3. **Raw Data Transmission** - Send STRING/ARRAY, never TEXT
4. **Selective Syncing** - Only sync variables that changed

```sqf
// Bad - Updates too frequently
{
    [_computer, _output] call AE3_armaos_fnc_terminal_updateOutput;
} forEach _keystrokes;

// Good - Throttled updates
private _lastUpdate = _computer getVariable ["lastUpdate", 0];
if (time - _lastUpdate > 0.3) then {
    [_computer, _output] call AE3_armaos_fnc_terminal_updateOutput;
    _computer setVariable ["lastUpdate", time];
};
```

### Filesystem Optimization

1. **Path Validation** - Validate paths before execution
2. **Permission Caching** - Check permissions once per operation
3. **Pointer Usage** - Use pointers instead of repeated path resolution

```sqf
// Bad - Resolve path multiple times
private _file1 = [[], _fs, "/home/user/file1.txt", "user", 1] call AE3_filesystem_fnc_getFile;
private _file2 = [[], _fs, "/home/user/file2.txt", "user", 1] call AE3_filesystem_fnc_getFile;

// Good - Resolve once, use pointer
private _dir = [[], _fs, "/home/user", "user"] call AE3_filesystem_fnc_chdir;
private _pointer = _dir select 0;
private _file1 = [_pointer, _fs, "file1.txt", "user", 1] call AE3_filesystem_fnc_getFile;
private _file2 = [_pointer, _fs, "file2.txt", "user", 1] call AE3_filesystem_fnc_getFile;
```

### Memory Management

1. **Clean Up Hashmaps** - Delete unused hashmaps
2. **Limit Buffer Size** - Keep terminal buffer to reasonable size
3. **Process Cleanup** - Ensure spawned processes terminate

```sqf
// Clean up terminal on close
_computer setVariable ["AE3_terminal", nil];
_computer setVariable ["AE3_terminal_sync", _syncData, 2];

// Limit buffer size
if (count _buffer > 1000) then {
    _buffer = _buffer select [count _buffer - 1000, 1000];
};
```

---

## Best Practices

### Network Serialization

**Never transmit TEXT (structured text) via remoteExec:**

```sqf
// WRONG - Causes millions of serialization warnings
private _text = parseText "<t color='#00ff00'>Hello</t>";
[_computer, _text] remoteExec ["someFunction", _clients];

// CORRECT - Send raw string, render locally
private _rawText = "<t color='#00ff00'>Hello</t>";
[_computer, _rawText] remoteExec ["someFunction", _clients];
// In someFunction: private _text = parseText _rawText;
```

**Only use serializable types in remoteExec:**
- STRING
- NUMBER (SCALAR)
- BOOL
- ARRAY (of serializable types)
- OBJECT
- CODE

### Mutex Usage

**Always use mutex for concurrent operations:**

```sqf
// Check computer mutex before terminal access
if (!(_computer getVariable ["AE3_computer_mutex", false])) then {
    _computer setVariable ["AE3_computer_mutex", true, true];

    // Perform terminal operation
    [_computer] call AE3_armaos_fnc_computer_turnOn;

    _computer setVariable ["AE3_computer_mutex", false, true];
};
```

See [ACE-Mutex.md](ACE-Mutex.md) for detailed mutex documentation.

### Error Handling

**Use try-catch for operations that may fail:**

```sqf
try {
    [[], _filesystem, "/tmp/file.txt", "Hello", "root"] call AE3_filesystem_fnc_createFile;
} catch {
    hint format ["Error: %1", _exception];
};
```

### Function Documentation

**Always include SQFdoc headers:**

```sqf
/*
 * Author: Root
 * Description: Brief description of what this function does
 *
 * Arguments:
 * 0: _param1 <TYPE> - Description
 * 1: _param2 <TYPE> (Optional, default: value) - Description
 *
 * Return Value:
 * Return value description <TYPE>
 *
 * Example:
 * [arg1, arg2] call AE3_addon_fnc_functionName;
 *
 * Public: Yes/No
 */
```

### Code Organization

**Follow the addon structure:**

```
addons/myAddon/
├── functions/
│   ├── fnc_init.sqf
│   ├── fnc_process.sqf
│   └── fnc_cleanup.sqf
├── config.cpp
├── script_component.hpp
├── XEH_PREP.hpp
├── XEH_preInit.sqf
└── XEH_postInit.sqf
```

---

## Summary

AE3's architecture is built on these key principles:

1. **Object-Centric Storage** - State lives on objects, not in globals
2. **Hashmap-Based Data** - Fast lookups for users, commands, filesystem
3. **Array-Based Serialization** - Arrays for network transmission
4. **Permission System** - Unix-like file permissions
5. **Network Optimization** - Throttled updates, raw data transmission
6. **Mutex Concurrency** - Prevent race conditions
7. **Modular Design** - Self-contained addons with clear responsibilities

For implementation examples, see:
- [API Reference](API-Reference.md) - Function documentation
- [Terminal Guide](Terminal-Guide.md) - Terminal usage
- [ACE Mutex](ACE-Mutex.md) - Concurrency handling
