# OS Command Customization Guide

This guide explains how to programmatically add OS commands to specific computers in your mission.

## Overview

Advanced Equipment now provides easy-to-use functions for customizing which commands are available on each computer. This allows you to create different types of computers with different capabilities.

## Quick Examples

### Example 1: Computer with All Standard Commands

```sqf
// Create a computer with all standard commands (default behavior)
[_computer] call AE3_armaos_fnc_computer_initWithCommands;
```

### Example 2: Computer with Limited Commands

```sqf
// Create a basic computer with only essential file commands
[_computer, ["ls", "cd", "pwd", "cat", "mkdir", "rm"]] call AE3_armaos_fnc_computer_initWithCommands;
```

### Example 3: Computer with Security Tools

```sqf
// Create a security workstation with all commands plus crypto tools
[_computer, ["all"], true] call AE3_armaos_fnc_computer_initWithCommands;
```

### Example 4: Computer with Custom Command

```sqf
// Add a custom "nano" text editor command
[
    _computer,
    "nano",
    "/bin/nano",
    {
        params ["_computer", "_options", "_commandName"];
        [_computer, "Nano text editor v1.0"] call AE3_armaos_fnc_shell_stdout;
        [_computer, "Usage: nano [filename]"] call AE3_armaos_fnc_shell_stdout;
    },
    "Simple text editor",
    "nano [filename]\n\nA simple text editor for the terminal."
] call AE3_armaos_fnc_computer_addCustomCommand;
```

### Example 5: Specialized Computer Setup

```sqf
// Create a specialized computer with specific command set and custom commands
[
    _computer,
    ["ls", "cd", "cat", "pwd"],  // Only basic navigation
    false,                        // No security commands
    false,                        // No games
    [                            // Custom commands
        [
            "nano",
            "/bin/nano",
            {
                params ["_computer", "_options"];
                [_computer, "Nano editor placeholder"] call AE3_armaos_fnc_shell_stdout;
            },
            "Text editor",
            "nano [file]"
        ],
        [
            "status",
            "/bin/status",
            {
                params ["_computer"];
                private _battery = _computer getVariable ["AE3_batteryLevel", 100];
                [_computer, format["Battery: %1%%", _battery]] call AE3_armaos_fnc_shell_stdout;
            },
            "Show system status",
            "status - Display system information"
        ]
    ]
] call AE3_armaos_fnc_computer_initWithCommands;
```

## Function Reference

### `AE3_armaos_fnc_computer_initWithCommands`

Initializes a computer with a specific set of commands.

**Parameters:**
- `_computer` (OBJECT): The computer object
- `_baseCommands` (ARRAY, optional): Array of command names from CfgOsFunctions
  - Use `["all"]` for all commands (default)
  - Use `[]` for no base commands
  - Use specific command names: `["ls", "cd", "cat", "mkdir"]`
- `_includeSecurity` (BOOL, optional): Include security commands (default: false)
- `_includeGames` (BOOL, optional): Include games like snake (default: false)
- `_customCommands` (ARRAY, optional): Array of custom command definitions (default: [])

**Returns:** Nothing

**Available Base Commands:**
- File operations: `ls`, `cd`, `pwd`, `cat`, `mkdir`, `touch`, `rm`, `cp`, `mv`, `find`
- User/permissions: `whoami`, `chown`
- System: `clear`, `echo`, `date`, `history`, `help`, `man`, `exit`, `shutdown`, `standby`
- Network: `ping`, `ipconfig`, `chat`
- Storage: `mount`, `unmount`, `lsusb`

**Security Commands:**
- `crypto` - Encrypt/decrypt messages
- `crack` - Crack encrypted messages

**Games:**
- `snake` - Snake game

### `AE3_armaos_fnc_computer_addCustomCommand`

Adds a single custom command to a computer without requiring config file entries.

**Parameters:**
- `_computer` (OBJECT): The computer object
- `_commandName` (STRING): The command name users will type
- `_commandPath` (STRING): Where the command is stored in the filesystem
- `_commandCode` (CODE or STRING): The SQF code to execute
  - Receives parameters: `[_computer, _options, _commandName]`
  - `_options` is an array of command-line arguments
- `_description` (STRING, optional): Short description for help
- `_manual` (STRING, optional): Full manual/help text
- `_owner` (STRING, optional): Owner of the command file (default: "root")
- `_permissions` (ARRAY, optional): File permissions (default: `[[true,true,false],[true,false,false]]`)

**Returns:** BOOL (success)

## Mission Integration Examples

### Setting Up Different Computer Types

```sqf
// In your mission init or during setup

// Admin workstation - full access
private _adminPC = _laptopAdmin;
[_adminPC, ["all"], true, true] call AE3_armaos_fnc_computer_initWithCommands;

// User workstation - limited commands
private _userPC = _laptopUser;
[_userPC, ["ls", "cd", "cat", "pwd", "help", "man"]] call AE3_armaos_fnc_computer_initWithCommands;

// Security analyst workstation
private _securityPC = _laptopSecurity;
[_securityPC, ["all"], true, false] call AE3_armaos_fnc_computer_initWithCommands;

// Entertainment terminal
private _gamePC = _laptopGames;
[_gamePC, ["ls", "cd", "help", "clear"], false, true] call AE3_armaos_fnc_computer_initWithCommands;
```

### Adding Mission-Specific Commands

```sqf
// Add a mission-specific command to launch an objective
[
    _objectiveComputer,
    "launch",
    "/bin/launch",
    {
        params ["_computer", "_options"];

        if (count _options == 0) exitWith {
            [_computer, "Usage: launch <missile-id>"] call AE3_armaos_fnc_shell_stdout;
        };

        private _missileId = _options select 0;
        [_computer, format["Launching missile %1...", _missileId]] call AE3_armaos_fnc_shell_stdout;

        // Trigger your mission objective here
        ["MissionObjectiveComplete", [_missileId]] call CBA_fnc_globalEvent;
    },
    "Launch missile system",
    "launch <missile-id>\n\nInitiates the launch sequence for the specified missile."
] call AE3_armaos_fnc_computer_addCustomCommand;
```

### Dynamic Command Access

```sqf
// Add command only if player has specific item
if ("ItemGPS" in items player) then {
    [
        _computer,
        "gps",
        "/bin/gps",
        {
            params ["_computer"];
            [_computer, format["GPS Location: %1", getPosATL player]] call AE3_armaos_fnc_shell_stdout;
        },
        "Show GPS coordinates",
        "gps - Display current GPS coordinates"
    ] call AE3_armaos_fnc_computer_addCustomCommand;
};
```

## Best Practices

1. **Call during computer initialization**: Add commands before the computer is first turned on
2. **Use meaningful command names**: Follow Unix-style naming conventions
3. **Provide help text**: Always include description and manual text for custom commands
4. **Handle arguments properly**: Check argument count and provide usage messages
5. **Use appropriate permissions**: Make commands executable for intended users

## Troubleshooting

**Q: My custom command doesn't appear**
- Ensure you call the function BEFORE the computer is first turned on
- Check the RPT log for error messages
- Verify the filesystem is initialized on the computer

**Q: Command exists but doesn't execute**
- Check that the command code is valid SQF
- Verify the command has execute permissions
- Check RPT log for runtime errors

**Q: How do I remove a command?**
```sqf
// Commands are stored in the computer's AE3_Links variable
private _links = _computer getVariable ["AE3_Links", createHashMap];
_links deleteAt "commandname";
_computer setVariable ["AE3_Links", _links, true];
```

## See Also

- `fnc_link_add.sqf` - Low-level command linking
- `fnc_link_init.sqf` - Initialize commands from config
- `fnc_computer_addSecurityCommands.sqf` - Add security command set
- `fnc_computer_addGames.sqf` - Add games
- `CfgOsFunctions.hpp` - Standard command definitions
