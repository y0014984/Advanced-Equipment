# ArmaOS API

ArmaOS is the terminal/TUI side of AE3. It manages user accounts, command links, installed commands, terminal output, terminal command execution, games, security commands, and laptop calendar events.

Use these APIs when you want to create a scriptable laptop experience: add users, choose which commands exist, create custom commands, print output from a command, or seed terminal-side state.

## Locality

Most computer setup functions should run on the server:

```sqf
if (isServer) then {
    [_laptop, "admin", "swordfish"] call AE3_armaos_fnc_computer_addUser;
    [_laptop, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;
};
```

Terminal output functions run where the terminal display exists. A custom command normally runs in the terminal context and can call `AE3_armaos_fnc_shell_stdout` directly.

## Device Initialization

### `AE3_armaos_fnc_device_ensureInit`

Ensures a computer's filesystem is initialized, running init on demand if it hasn't happened yet. Returns `false` for objects that aren't AE3 devices at all (e.g. a vanilla laptop prop placed in Zeus).

```sqf
private _ready = [_computer] call AE3_armaos_fnc_device_ensureInit;
```

Server-only. Useful before running any of the setup calls below against an object that may have been spawned dynamically (Zeus-placed, `createVehicle`, dynamic respawn) rather than initialized through the normal mission-start flow, where init timing is already guaranteed.

```sqf
if (isServer) then {
    if ([_spawnedLaptop] call AE3_armaos_fnc_device_ensureInit) then {
        [_spawnedLaptop, "admin", "swordfish"] call AE3_armaos_fnc_computer_addUser;
    };
};
```

## Users

### `AE3_armaos_fnc_computer_addUser`

Adds a user account to a laptop and creates `/home/<username>` for non-root users. The user directory is seeded with a Desktop folder and default app launchers for GUI use.

```sqf
[_computer, _username, _password] call AE3_armaos_fnc_computer_addUser;
```

Arguments:

| Index | Type | Meaning |
| --- | --- | --- |
| `0` | Object | Laptop/computer object. |
| `1` | String | Username. |
| `2` | String | Password. |

Return value: none.

Server-only: yes. Calls made on clients exit without changing state.

Example:

```sqf
if (isServer) then {
    [_laptop, "admin", "swordfish"] call AE3_armaos_fnc_computer_addUser;
    [_laptop, "guest", "guest"] call AE3_armaos_fnc_computer_addUser;
};
```

Notes:

- User credentials are stored in `AE3_Userlist`.
- Home directories are created under `/home`.
- If a home directory already exists, the account can still be added.
- Avoid duplicate usernames unless you intentionally want to replace the stored password.

## Superuser Access

Every laptop is created with a `root` account. Its password comes from the laptop's *Root password* Eden attribute, or from the `AE3_DefaultRootPassword` CBA setting (`toor`) when that attribute is blank.

Whether `root` may log in **directly** is decided per laptop: the *Direct root login* Eden attribute (`default` / `allow` / `deny`) wins over the mission-wide `AE3_AllowRootLogin` CBA setting. The same rule applies to the terminal login, the desktop login, and `ssh`.

Accounts listed in `/etc/sudoers` may run `sudo <command>` in the terminal and act with root permissions in the desktop apps (Files, Notepad, My Computer, remote SSH sessions), while keeping their own home directory.

By default the terminal elevates sudoers the same way the desktop does: `cat /home/someone-else/notes` works without a prefix, because one account should not have two different sets of rights depending on which interface it is used from. `whoami` still reports the real account, and `sudo` / `su` keep working as they always did.

Missions that prefer strict Unix semantics turn the `AE3_CliElevateSudoers` CBA setting off. Plain commands then run as the logged-in user again, `cat /home/someone-else/notes` reports missing permissions, and a sudoer must use `sudo <command>` for one command or `su` for a shell that stays root until `exit`. The desktop apps elevate a sudoer either way, because a graphical file manager has no command to prefix.

### `AE3_armaos_fnc_computer_setRootLogin`

```sqf
[_computer, _allowed, _password] call AE3_armaos_fnc_computer_setRootLogin;
```

| Index | Type | Meaning |
| --- | --- | --- |
| `0` | Object | Laptop/computer object. |
| `1` | Any | `true`/`"allow"` to allow direct root login, `false`/`"deny"` to deny it, `"default"` to follow the CBA setting again. Optional, default `"default"`. |
| `2` | String | New root password; `""` keeps the current one. Optional. |

Return value: Bool - whether the policy was applied. Server-only.

### `AE3_armaos_fnc_computer_setRootPassword`

```sqf
[_computer, _password] call AE3_armaos_fnc_computer_setRootPassword;
```

Sets only the root password. Server-only.

### `AE3_armaos_fnc_computer_addSudoer` / `AE3_armaos_fnc_computer_removeSudoer`

```sqf
[_computer, _username] call AE3_armaos_fnc_computer_addSudoer;
[_computer, _username] call AE3_armaos_fnc_computer_removeSudoer;
```

Adds/removes an account in `/etc/sudoers`. `addSudoer` initialises the device on demand, creates the file when missing, ignores duplicates, and broadcasts the filesystem, so it is safe to call from `init.sqf` before the laptop has finished its own init. Both are server-only and return a Bool.

Example:

```sqf
if (isServer) then {
    [_laptop, "cracked", "cracked"] call AE3_armaos_fnc_computer_addUser;
    [_laptop, "cracked"] call AE3_armaos_fnc_computer_addSudoer;
};
```

Do not write `/etc/sudoers` by hand from a mission script: the file is owned by `root` with no permissions for other users, and a raw write before the laptop's filesystem exists fails silently.

### `AE3_armaos_fnc_computer_getSudoers` / `AE3_armaos_fnc_computer_isSudoer`

```sqf
private _sudoers = [_computer] call AE3_armaos_fnc_computer_getSudoers;   // ARRAY of STRING
private _elevated = [_computer, _username] call AE3_armaos_fnc_computer_isSudoer;  // BOOL, true for root
```

Read-only, can run anywhere. `getSudoers` returns the union of the broadcast roster and the accounts written in `/etc/sudoers`, so it stays correct on a client whose copy of the filesystem has not caught up yet. `isSudoer` matches names case-insensitively and ignores surrounding whitespace.

### `AE3_armaos_fnc_computer_allowsRootLogin`

```sqf
private _allowed = [_computer] call AE3_armaos_fnc_computer_allowsRootLogin;
```

Resolves the laptop's own policy, falling back to the CBA setting.

## Installing Built-In Commands

### `AE3_armaos_fnc_computer_initWithCommands`

Initializes a laptop with a selected command set.

```sqf
[_computer, _baseCommands, _includeSecurity, _includeGames, _customCommands] call AE3_armaos_fnc_computer_initWithCommands;
```

Arguments:

| Index | Type | Default | Meaning |
| --- | --- | --- | --- |
| `0` | Object | Required | Laptop/computer object. |
| `1` | Array | `["all"]` | Command names from `CfgOsFunctions`. Use `["all"]` for all base commands or `[]` for none. |
| `2` | Bool | `false` | Add security commands from `CfgSecurityCommands`. |
| `3` | Bool | `false` | Add games from `CfgGames`. |
| `4` | Array | `[]` | Custom command definitions `[name, path, code, description, manual]`. |

Return value: none.

Example: minimal investigator laptop.

```sqf
if (isServer) then {
    [
        _laptop,
        ["help", "man", "ls", "cd", "cat", "grep", "find", "history", "whoami", "exit"],
        false,
        false,
        []
    ] call AE3_armaos_fnc_computer_initWithCommands;
};
```

Example: full utility laptop with security commands and Snake.

```sqf
if (isServer) then {
    [_laptop, ["all"], true, true, []] call AE3_armaos_fnc_computer_initWithCommands;
};
```

### `AE3_armaos_fnc_computer_addSecurityCommands`

Adds the optional security commands.

```sqf
[_computer, _isCrypto, _isCrack] call AE3_armaos_fnc_computer_addSecurityCommands;
```

| Argument | Type | Meaning |
| --- | --- | --- |
| `_computer` | Object | Target laptop. |
| `_isCrypto` | Bool | Add `crypto`. |
| `_isCrack` | Bool | Add `crack`. |

Example:

```sqf
[_laptop, true, false] call AE3_armaos_fnc_computer_addSecurityCommands;
```

Server-only: yes.

### `AE3_armaos_fnc_computer_addGames`

Adds optional games. Currently the supported game is `snake`.

```sqf
[_computer, _isSnake] call AE3_armaos_fnc_computer_addGames;
```

Example:

```sqf
[_laptop, true] call AE3_armaos_fnc_computer_addGames;
```

Server-only: yes.

## Custom Commands

### `AE3_armaos_fnc_computer_addCustomCommand`

Adds a command to a single laptop at runtime without creating config entries.

```sqf
private _success = [
    _computer,
    _commandName,
    _commandPath,
    _commandCode,
    _description,
    _manual,
    _owner,
    _permissions
] call AE3_armaos_fnc_computer_addCustomCommand;
```

Arguments:

| Index | Type | Default | Meaning |
| --- | --- | --- | --- |
| `0` | Object | Required | Laptop/computer object. |
| `1` | String | Required | Command name users type. |
| `2` | String | Required | Filesystem path where command file is stored, usually `/bin/<name>` or `/usr/bin/<name>`. |
| `3` | Code or String | Required | SQF code to execute. String values are compiled. |
| `4` | String | `""` | Short help text. |
| `5` | String | `""` | Manual text shown by `man`. |
| `6` | String | `"root"` | Owner of the command file. |
| `7` | Array | Owner read/execute | File permissions. |

Return value: `true` on success, `false` on validation or creation failure.

Command code receives:

```sqf
params ["_computer", "_options", "_commandName"];
```

Example: simple status command.

```sqf
[
    _laptop,
    "status",
    "/bin/status",
    {
        params ["_computer", "_options", "_commandName"];
        [_computer, "Relay online. No active alarms."] call AE3_armaos_fnc_shell_stdout;
    },
    "Show relay status",
    "status: prints the current relay status"
] call AE3_armaos_fnc_computer_addCustomCommand;
```

Example: custom command with arguments.

```sqf
[
    _laptop,
    "door",
    "/bin/door",
    {
        params ["_computer", "_options", "_commandName"];

        private _action = _options param [0, "status"];
        switch (_action) do {
            case "open": {
                missionNamespace setVariable ["myMission_doorOpen", true, true];
                [_computer, "Door relay opened."] call AE3_armaos_fnc_shell_stdout;
            };
            case "close": {
                missionNamespace setVariable ["myMission_doorOpen", false, true];
                [_computer, "Door relay closed."] call AE3_armaos_fnc_shell_stdout;
            };
            default {
                private _state = ["closed", "open"] select (missionNamespace getVariable ["myMission_doorOpen", false]);
                [_computer, format ["Door relay is %1.", _state]] call AE3_armaos_fnc_shell_stdout;
            };
        };
    },
    "Control door relay",
    "door [status|open|close]"
] call AE3_armaos_fnc_computer_addCustomCommand;
```

Guidance:

- Keep command output concise.
- Use `AE3_armaos_fnc_shell_stdout` for output instead of manipulating terminal buffers directly.
- If a command changes mission state, run the state-changing portion on the server with CBA events or `remoteExecCall`.
- Avoid commands that require a GUI display if they may be run over SSH.

## Terminal Output and Command Execution

### `AE3_armaos_fnc_shell_stdout`

Writes output to the open terminal.

```sqf
[_computer, _input] call AE3_armaos_fnc_shell_stdout;
```

`_input` may be a string or an array of terminal-renderable lines.

Example:

```sqf
[_computer, "Access granted."] call AE3_armaos_fnc_shell_stdout;
```

Formatted line example:

```sqf
[_computer, [["WARNING", "#FFD966"], [" Door relay unstable.", "#FFFFFF"]]] call AE3_armaos_fnc_shell_stdout;
```

The function safely no-ops when the terminal is not initialized. This matters for GUI-only laptops and backend code that may run without an open TUI.

### `AE3_armaos_fnc_shell_process`

Processes a command string as if entered into the terminal.

```sqf
[_computer, _commandString] call AE3_armaos_fnc_shell_process;
```

Example:

```sqf
[_laptop, "ls -l /home/admin"] call AE3_armaos_fnc_shell_process;
```

Use this sparingly. It assumes the terminal state exists and is mostly useful for automation, testing, or scripted interactive sequences.

### `AE3_armaos_fnc_shell_getOpts`

Parses command-line options according to a command settings array. This is useful for custom commands with flags.

```sqf
private _parsed = [_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts;
```

Typical command setting shape:

```sqf
private _commandSettings = [
    "scan",
    [
        ["_fast", "-f", "--fast", "bool", false, false, "Run a short scan"],
        ["_target", "-t", "--target", "string", "", true, "Target device name"]
    ],
    "scan --target NAME [-f]"
];
```

Command usage:

```sqf
private _ae3OptsSuccess = false;
private _fast = false;
private _target = "";

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);
if (!_ae3OptsSuccess) exitWith {};

[_computer, format ["Scanning %1. Fast mode: %2", _target, _fast]] call AE3_armaos_fnc_shell_stdout;
```

The parser handles short options, long options, required options, default values, help output, and type conversion.

## Calendar Events

There are two related calendar APIs:

| Function | Store | UI |
| --- | --- | --- |
| `AE3_armaos_fnc_computer_addCalendarEvent` | `AE3_calendar_events` object variable | Web desktop Calendar store. |
| `AE3_desktop_fnc_addCalendarEvent` | Filesystem text file | Desktop/TUI readable file content. |

Use the ArmaOS function when you want structured calendar entries synchronized as laptop state.

### `AE3_armaos_fnc_computer_addCalendarEvent`

```sqf
private _ok = [_computer, _date, _title, _location, _body] call AE3_armaos_fnc_computer_addCalendarEvent;
```

Arguments:

| Index | Type | Meaning |
| --- | --- | --- |
| `0` | Object | Laptop. |
| `1` | String | ISO date, `YYYY-MM-DD`. |
| `2` | String | Event title. |
| `3` | String | Location text. Optional. |
| `4` | String | Body/details. Optional. |

Return value: `true` on success, `false` if called off-server, target is null, or date/title is invalid.

Example:

```sqf
if (isServer) then {
    [_laptop, "2026-06-30", "Courier handoff", "Pier 4", "One encrypted flash drive changes hands."] call AE3_armaos_fnc_computer_addCalendarEvent;
};
```

### `AE3_armaos_fnc_computer_removeCalendarEvent`

Removes an event by index from `AE3_calendar_events`.

```sqf
private _ok = [_computer, _index] call AE3_armaos_fnc_computer_removeCalendarEvent;
```

Example:

```sqf
[_laptop, 0] call AE3_armaos_fnc_computer_removeCalendarEvent;
```

Server-only: yes.

## Laptop State Helpers

The ArmaOS component also contains laptop state capture/apply helpers used by pickup/deploy and save/restore module behavior. Treat these as framework-level functions rather than normal mission setup functions:

| Function | Purpose |
| --- | --- |
| `AE3_armaos_fnc_laptop_captureState` | Captures persistent laptop variables before converting a world laptop to an inventory item or saved state. |
| `AE3_armaos_fnc_laptop_applyState` | Applies captured state to a laptop object. |
| `AE3_armaos_fnc_laptop_pickup` / `AE3_armaos_fnc_laptop_deploy` | Inventory/world conversion workflow. |
| `AE3_armaos_fnc_laptop_pickup_stable` / `AE3_armaos_fnc_laptop_deploy_stable` | Stable variants used by current pickup/deploy behavior. |

Use the provided player actions and Eden/Zeus modules for normal mission workflows. Use these functions only when building another addon that needs to integrate with AE3 laptop persistence.

## Related Pages

- [Terminal Commands](Terminal-Commands.md)
- [Filesystem API](Filesystem-API.md)
- [Desktop API](Desktop-API.md)
- [Extending Terminal TUI](../Developer/Extending-Terminal-TUI.md)
