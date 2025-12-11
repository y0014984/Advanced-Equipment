# AE3 API Reference

This document provides comprehensive API documentation for all public functions in the Advanced Equipment (AE3) framework. Functions are organized by addon module.

## Table of Contents

1. [Filesystem API](#filesystem-api) - Virtual filesystem operations
2. [ArmaOS Computer API](#armaos-computer-api) - Computer control and initialization
3. [ArmaOS Shell API](#armaos-shell-api) - Shell command processing
4. [ArmaOS Terminal API](#armaos-terminal-api) - Terminal display and input
5. [Power Management API](#power-management-api) - Battery, generator, and power control
6. [FlashDrive API](#flashdrive-api) - USB flash drive operations
7. [Interaction API](#interaction-api) - ACE3 interactions and equipment
8. [Remote Sync API](#remote-sync-api) - Multiplayer variable synchronization

---

## Filesystem API

The filesystem addon provides a Unix-like hierarchical filesystem with permissions and ownership.

### AE3_filesystem_fnc_createFile

Creates a new file in the filesystem with specified content. Throws exception if file already exists.

**Syntax:**
```sqf
[_pntr, _filesystem, _target, _content, _user, _owner, _permissions] call AE3_filesystem_fnc_createFile
```

**Parameters:**
- `_pntr` (ARRAY) - Current directory pointer
- `_filesystem` (ARRAY) - Filesystem object
- `_target` (STRING) - Path to new file
- `_content` (ANY) - File content (string, code, or any serializable type)
- `_user` (STRING) - User creating the file
- `_owner` (STRING, optional) - Owner of the file (default: `_user`)
- `_permissions` (ARRAY, optional) - Permissions `[[owner x,r,w],[everyone x,r,w]]` (default: `[[false,true,true],[false,false,false]]`)

**Return Value:** None

**Examples:**
```sqf
[[], _filesystem, "/tmp/test.txt", "Hello World", "root"] call AE3_filesystem_fnc_createFile;

[[], _filesystem, "/home/user/script.sqf", compile "hint 'test'", "user", "user", [[true,true,true],[false,false,false]]] call AE3_filesystem_fnc_createFile;
```

**Notes:**
- Automatically ensures parent directories have appropriate execute/read permissions
- Files can contain strings, compiled code, or any serializable data type

---

### AE3_filesystem_fnc_createDir

Creates a new directory in the filesystem. Throws exception if directory already exists.

**Syntax:**
```sqf
[_pntr, _filesystem, _target, _user, _owner, _permissions] call AE3_filesystem_fnc_createDir
```

**Parameters:**
- `_pntr` (ARRAY) - Current directory pointer
- `_filesystem` (ARRAY) - Filesystem object
- `_target` (STRING) - Path to new directory
- `_user` (STRING) - User creating the directory
- `_owner` (STRING, optional) - Owner of the directory (default: `_user`)
- `_permissions` (ARRAY, optional) - Permissions `[[owner x,r,w],[everyone x,r,w]]` (default: `[[true,true,true],[false,false,false]]`)

**Return Value:** None

**Examples:**
```sqf
[[], _filesystem, "/tmp/logs", "root"] call AE3_filesystem_fnc_createDir;

[[], _filesystem, "/home/user/documents", "user", "user", [[true,true,true],[true,true,false]]] call AE3_filesystem_fnc_createDir;
```

---

### AE3_filesystem_fnc_delObj

Deletes a filesystem object (file or directory). Throws exception if object doesn't exist.

**Syntax:**
```sqf
[_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_delObj
```

**Parameters:**
- `_pntr` (ARRAY) - Current directory pointer
- `_filesystem` (ARRAY) - Filesystem object
- `_target` (STRING) - Path to object to delete
- `_user` (STRING) - User performing the deletion

**Return Value:** None

**Examples:**
```sqf
[[], _filesystem, "/tmp/test.txt", "root"] call AE3_filesystem_fnc_delObj;

[_pointer, _filesystem, "../oldfile", "user"] call AE3_filesystem_fnc_delObj;
```

**Notes:** Requires write permission on the object

---

### AE3_filesystem_fnc_mvObj

Moves or copies a filesystem object to another location. Also used by the `cp` command.

**Syntax:**
```sqf
[_pntr, _filesystem, _source, _target, _user, _copy] call AE3_filesystem_fnc_mvObj
```

**Parameters:**
- `_pntr` (ARRAY) - Current directory pointer
- `_filesystem` (ARRAY) - Filesystem object
- `_source` (STRING) - Path to source object
- `_target` (STRING) - Path to target location
- `_user` (STRING) - User performing the operation
- `_copy` (BOOL, optional) - If true, copy instead of move (default: false)

**Return Value:** None

**Examples:**
```sqf
[[], _filesystem, "/tmp/old.txt", "/tmp/new.txt", "root"] call AE3_filesystem_fnc_mvObj;

[[], _filesystem, "/home/file.txt", "/backup/", "user", true] call AE3_filesystem_fnc_mvObj;
```

**Notes:**
- Copying requires read permission on source
- Moving requires write permission on source
- Always requires write permission on target directory

---

### AE3_filesystem_fnc_chown

Changes the owner of a filesystem object. Can operate recursively on directories.

**Syntax:**
```sqf
[_pntr, _filesystem, _target, _user, _owner, _recursive] call AE3_filesystem_fnc_chown
```

**Parameters:**
- `_pntr` (ARRAY) - Current directory pointer
- `_filesystem` (ARRAY) - Filesystem object
- `_target` (STRING) - Path to target file or directory
- `_user` (STRING) - User performing the operation
- `_owner` (STRING) - New owner name
- `_recursive` (BOOL, optional) - Apply recursively to directory contents (default: false)

**Return Value:** None

**Examples:**
```sqf
[[], _filesystem, "/home/user/file.txt", "root", "user"] call AE3_filesystem_fnc_chown;

[[], _filesystem, "/var/www", "root", "www-data", true] call AE3_filesystem_fnc_chown;
```

**Notes:** Only the current owner or root can change ownership

---

### AE3_filesystem_fnc_mount

Mounts a filesystem (like a flash drive) to a specified directory mount point.

**Syntax:**
```sqf
[_pntr, _filesystem, _mountFilesystem, _target, _user] call AE3_filesystem_fnc_mount
```

**Parameters:**
- `_pntr` (ARRAY) - Current directory pointer
- `_filesystem` (ARRAY) - Host filesystem object
- `_mountFilesystem` (ARRAY) - Filesystem to mount
- `_target` (STRING) - Path to mount point directory
- `_user` (STRING) - User performing the mount operation

**Return Value:** None

**Examples:**
```sqf
[[], _computerFS, _flashdriveFS, "/mnt/usb", "root"] call AE3_filesystem_fnc_mount;

[_pointer, _filesystem, _externalFS, "/media/drive", "user"] call AE3_filesystem_fnc_mount;
```

**Notes:** Requires write permission on the mount point

---

### AE3_filesystem_fnc_unmount

Unmounts a filesystem from a mount point by replacing it with an empty directory.

**Syntax:**
```sqf
[_pntr, _filesystem, _mountFilesystem, _target, _user] call AE3_filesystem_fnc_unmount
```

**Parameters:**
- `_pntr` (ARRAY) - Current directory pointer
- `_filesystem` (ARRAY) - Host filesystem object
- `_mountFilesystem` (ARRAY) - Mounted filesystem (not used in current implementation)
- `_target` (STRING) - Path to mount point directory
- `_user` (STRING) - User performing the unmount operation

**Return Value:** None

**Examples:**
```sqf
[[], _filesystem, _flashdriveFS, "/mnt/usb", "root"] call AE3_filesystem_fnc_unmount;
```

**Notes:** Requires write permission on the mount point

---

### AE3_filesystem_fnc_writeToFile

Writes content to a file, either replacing existing content or appending to it.

**Syntax:**
```sqf
[_pntr, _filesystem, _target, _user, _content, _appendMode] call AE3_filesystem_fnc_writeToFile
```

**Parameters:**
- `_pntr` (ARRAY) - Current directory pointer
- `_filesystem` (ARRAY) - Filesystem object
- `_target` (STRING) - Path to file
- `_user` (STRING) - User performing the write operation
- `_content` (STRING) - Content to write
- `_appendMode` (BOOL, optional) - If true, append instead of replace (default: false)

**Return Value:** None

**Examples:**
```sqf
[[], _filesystem, "/tmp/log.txt", "root", "New log entry\n"] call AE3_filesystem_fnc_writeToFile;

[_pointer, _filesystem, "/var/data.txt", "user", "More data\n", true] call AE3_filesystem_fnc_writeToFile;
```

**Notes:** Requires write permission on the file

---

### AE3_filesystem_fnc_getFile

Retrieves the content of a file from the filesystem.

**Syntax:**
```sqf
private _content = [_pntr, _filesystem, _target, _user, _permission] call AE3_filesystem_fnc_getFile
```

**Parameters:**
- `_pntr` (ARRAY) - Current directory pointer
- `_filesystem` (ARRAY) - Filesystem object
- `_target` (STRING) - Path to file
- `_user` (STRING) - User accessing the file
- `_permission` (NUMBER) - Permission to check (0: Execute, 1: Read, 2: Write)

**Return Value:** File content (ANY) - Can be string, code, or any stored type

**Examples:**
```sqf
private _content = [[], _filesystem, "/tmp/data.txt", "root", 1] call AE3_filesystem_fnc_getFile;

private _script = [_pointer, _filesystem, "../script.sqf", "user", 0] call AE3_filesystem_fnc_getFile;
```

**Notes:** Throws exception if file doesn't exist or permission denied

---

### AE3_filesystem_fnc_resolvePntr

Resolves a directory pointer (array of directory names) to the corresponding filesystem object.

**Syntax:**
```sqf
private _fsObject = [_pntr, _filesystem] call AE3_filesystem_fnc_resolvePntr
```

**Parameters:**
- `_pntr` (ARRAY) - Directory pointer (array of directory names forming absolute path)
- `_filesystem` (ARRAY) - Filesystem object

**Return Value:** Resolved filesystem object `[content, owner, permissions]` (ARRAY)

**Examples:**
```sqf
private _rootObj = [[], _filesystem] call AE3_filesystem_fnc_resolvePntr;

private _docsObj = [["home", "user", "documents"], _filesystem] call AE3_filesystem_fnc_resolvePntr;
```

**Notes:** Throws exception if any directory in the path doesn't exist

---

### AE3_filesystem_fnc_hasPermission

Checks if a user has the specified permission on a filesystem object. Throws exception if permission denied.

**Syntax:**
```sqf
[_fileObject, _user, _permission] call AE3_filesystem_fnc_hasPermission
```

**Parameters:**
- `_fileObject` (ARRAY) - Filesystem object `[content, owner, permissions]`
- `_user` (STRING) - User to check permissions for
- `_permission` (NUMBER) - Permission to check (0: Execute, 1: Read, 2: Write)

**Return Value:** None (throws exception if permission denied)

**Examples:**
```sqf
[_fileObj, "root", 1] call AE3_filesystem_fnc_hasPermission;

[_dirObj, "user", 2] call AE3_filesystem_fnc_hasPermission;
```

**Notes:**
- Root user and empty owner always pass
- Checks owner permissions first, then everyone permissions

---

### AE3_filesystem_fnc_lsdir

Lists the contents of a directory with optional detailed information.

**Syntax:**
```sqf
private _listing = [_pntr, _filesystem, _target, _user, _long] call AE3_filesystem_fnc_lsdir
```

**Parameters:**
- `_pntr` (ARRAY) - Current directory pointer
- `_filesystem` (ARRAY) - Filesystem object
- `_target` (STRING) - Path to directory to list
- `_user` (STRING, optional) - User performing the operation (default: "")
- `_long` (BOOL, optional) - Show detailed listing with permissions and owner (default: false)

**Return Value:** Array of directory entries (each entry is array of [permission string, name with color]) (ARRAY)

**Examples:**
```sqf
private _files = [[], _filesystem, "/tmp", "root"] call AE3_filesystem_fnc_lsdir;

private _detailedList = [[], _filesystem, "/home/user", "user", true] call AE3_filesystem_fnc_lsdir;
```

**Notes:**
- Directories displayed in blue, executables in green
- Returns formatted output ready for terminal display

---

### AE3_filesystem_fnc_fsObjExists

Checks whether a filesystem object (file or directory) exists at the specified path.

**Syntax:**
```sqf
private _exists = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_fsObjExists
```

**Parameters:**
- `_pntr` (ARRAY) - Current directory pointer
- `_filesystem` (ARRAY) - Filesystem object
- `_target` (STRING) - Path to filesystem object
- `_user` (STRING) - User performing the check

**Return Value:** True if object exists, false otherwise (BOOL)

**Examples:**
```sqf
if ([[], _filesystem, "/tmp/test.txt", "root"] call AE3_filesystem_fnc_fsObjExists) then {
    hint "File exists";
};

private _configExists = [_pointer, _filesystem, "../config.cfg", "user"] call AE3_filesystem_fnc_fsObjExists;
```

---

### AE3_filesystem_fnc_findFilesystemObject

Recursively searches for filesystem objects by name.

**Syntax:**
```sqf
private _results = [_pointer, _filesystem, _user, _filesystemObjectName] call AE3_filesystem_fnc_findFilesystemObject
```

**Parameters:**
- `_pointer` (ARRAY) - Current directory pointer
- `_filesystem` (ARRAY) - Filesystem object
- `_user` (STRING) - User performing the search
- `_filesystemObjectName` (STRING) - Name to search for (exact match)

**Return Value:** Array containing:
- `_results` select 0 (ARRAY) - Array of paths to matching objects
- `_results` select 1 (NUMBER) - Count of directories with insufficient permissions

**Examples:**
```sqf
private _results = [[], _filesystem, "root", "password.txt"] call AE3_filesystem_fnc_findFilesystemObject;
_results params ["_paths", "_deniedCount"];

private _configFiles = [[home"], _filesystem, "user", "config.cfg"] call AE3_filesystem_fnc_findFilesystemObject;
```

**Notes:** Respects read permissions and counts directories with insufficient permissions

---

### AE3_filesystem_fnc_initFilesystem

Initializes the filesystem on a device and loads filesystem objects from config.

**Syntax:**
```sqf
[_entity, _config] call AE3_filesystem_fnc_initFilesystem
```

**Parameters:**
- `_entity` (OBJECT) - Device object to initialize (laptop or flash drive)
- `_config` (CONFIG, optional) - Config class containing `AE3_FilesystemObject` entries

**Return Value:** None

**Examples:**
```sqf
[_laptop] call AE3_filesystem_fnc_initFilesystem;

[_laptop, configFile >> "CfgFilesystemObjects" >> "MyCustomObjects"] call AE3_filesystem_fnc_initFilesystem;
```

**Notes:**
- Must run on server
- Creates root filesystem structure
- Processes config entries to add files and directories

---

## ArmaOS Computer API

Computer control and initialization functions for the ArmaOS terminal system.

### AE3_armaos_fnc_computer_turnOn

Turns on a computer with boot animation and startup sound.

**Syntax:**
```sqf
private _success = [_computer] call AE3_armaos_fnc_computer_turnOn
```

**Parameters:**
- `_computer` (OBJECT) - The computer object to turn on

**Return Value:** Success (BOOL)

**Examples:**
```sqf
[_laptop] call AE3_armaos_fnc_computer_turnOn;
```

**Notes:**
- Shows booting animation on computer texture
- Boot time is 15 seconds from powered off, 3 seconds from standby
- Debug mode reduces boot time to 3 seconds

---

### AE3_armaos_fnc_computer_turnOff

Turns off a computer with shutdown animation and clears terminal state.

**Syntax:**
```sqf
private _success = [_computer, _silent] call AE3_armaos_fnc_computer_turnOff
```

**Parameters:**
- `_computer` (OBJECT) - The computer object to turn off
- `_silent` (BOOL, optional) - Whether to suppress sounds (default: false)

**Return Value:** Success (BOOL)

**Examples:**
```sqf
[_laptop] call AE3_armaos_fnc_computer_turnOff;

[_laptop, true] call AE3_armaos_fnc_computer_turnOff; // Silent shutdown
```

**Notes:**
- Shows shutdown animation on computer texture
- Clears terminal state and syncs data

---

### AE3_armaos_fnc_computer_standby

Puts a computer into standby mode.

**Syntax:**
```sqf
private _success = [_computer] call AE3_armaos_fnc_computer_standby
```

**Parameters:**
- `_computer` (OBJECT) - The computer object to put into standby

**Return Value:** Success (BOOL)

**Examples:**
```sqf
[_laptop] call AE3_armaos_fnc_computer_standby;
```

**Notes:**
- Syncs terminal state before standby
- Shows standby screen texture
- Faster wake-up than full boot

---

### AE3_armaos_fnc_computer_addUser

Adds a user account to a computer.

**Syntax:**
```sqf
[_computer, _username, _password] call AE3_armaos_fnc_computer_addUser
```

**Parameters:**
- `_computer` (OBJECT) - The computer object
- `_username` (STRING) - Username for the new account
- `_password` (STRING) - Password for the new account

**Return Value:** None

**Examples:**
```sqf
[_laptop, "admin", "admin123"] call AE3_armaos_fnc_computer_addUser;

[_laptop, "guest", ""] call AE3_armaos_fnc_computer_addUser; // No password
```

**Notes:**
- Must be executed on the server
- Creates user directory at `/home/<username>`
- Root user doesn't get a home directory

---

### AE3_armaos_fnc_computer_addGames

Adds games to a computer. Currently only Snake is supported.

**Syntax:**
```sqf
[_computer, _isSnake] call AE3_armaos_fnc_computer_addGames
```

**Parameters:**
- `_computer` (OBJECT) - The computer object
- `_isSnake` (BOOL) - Whether to add the Snake game

**Return Value:** None

**Examples:**
```sqf
[_laptop, true] call AE3_armaos_fnc_computer_addGames;
```

**Notes:** Must be executed on the server

---

### AE3_armaos_fnc_computer_addSecurityCommands

Adds security commands (crypto, crack) to a computer.

**Syntax:**
```sqf
[_computer, _isCrypto, _isCrack] call AE3_armaos_fnc_computer_addSecurityCommands
```

**Parameters:**
- `_computer` (OBJECT) - The computer object
- `_isCrypto` (BOOL) - Whether to add the crypto command
- `_isCrack` (BOOL) - Whether to add the crack command

**Return Value:** None

**Examples:**
```sqf
[_laptop, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;

[_laptop, true, false] call AE3_armaos_fnc_computer_addSecurityCommands; // Crypto only
```

**Notes:** Must be executed on the server

---

### AE3_armaos_fnc_computer_initWithCommands

Initializes a computer with a specific set of commands.

**Syntax:**
```sqf
[_computer, _baseCommands, _includeSecurity, _includeGames, _customCommands] call AE3_armaos_fnc_computer_initWithCommands
```

**Parameters:**
- `_computer` (OBJECT) - The computer object to initialize
- `_baseCommands` (ARRAY, optional) - Array of command names from `CfgOsFunctions` (default: `["all"]`)
- `_includeSecurity` (BOOL, optional) - Include security commands (default: false)
- `_includeGames` (BOOL, optional) - Include games (default: false)
- `_customCommands` (ARRAY, optional) - Array of custom command definitions (default: [])

**Return Value:** None

**Examples:**
```sqf
[_computer, ["ls", "cd", "cat"], true, false, []] call AE3_armaos_fnc_computer_initWithCommands;

[_computer, ["all"], true, true, []] call AE3_armaos_fnc_computer_initWithCommands;
```

**Notes:** Makes it easy to create computers with different command sets

---

### AE3_armaos_fnc_computer_addCustomCommand

Adds a custom command to a computer dynamically at runtime.

**Syntax:**
```sqf
private _success = [_computer, _commandName, _commandPath, _commandCode, _description, _manual, _owner, _permissions] call AE3_armaos_fnc_computer_addCustomCommand
```

**Parameters:**
- `_computer` (OBJECT) - The computer object
- `_commandName` (STRING) - The name users will type (e.g., "nano")
- `_commandPath` (STRING) - Where the command is stored in filesystem (e.g., "/bin/nano")
- `_commandCode` (CODE or STRING) - The SQF code to execute
- `_description` (STRING, optional) - Short description for help (default: "")
- `_manual` (STRING, optional) - Full manual/help text (default: "")
- `_owner` (STRING, optional) - Owner of the command file (default: "root")
- `_permissions` (ARRAY, optional) - File permissions (default: `[[true,true,false],[true,false,false]]`)

**Return Value:** Success (BOOL)

**Examples:**
```sqf
[_computer, "nano", "/bin/nano", {[_this select 0, "Nano v1.0"] call AE3_armaos_fnc_shell_stdout;}, "Simple text editor"] call AE3_armaos_fnc_computer_addCustomCommand;

private _code = compile "hint 'Custom command';";
[_laptop, "test", "/usr/bin/test", _code, "Test command", "Usage: test"] call AE3_armaos_fnc_computer_addCustomCommand;
```

**Notes:** Command code receives `[_computer, _options, _commandName]` as parameters

---

## ArmaOS Shell API

Shell command processing and terminal I/O functions.

### AE3_armaos_fnc_shell_process

Processes a command string entered by the user.

**Syntax:**
```sqf
[_computer, _commandString] call AE3_armaos_fnc_shell_process
```

**Parameters:**
- `_computer` (OBJECT) - The computer object
- `_commandString` (STRING, optional) - The command string to process (default: "")

**Return Value:** None

**Examples:**
```sqf
[_computer, "ls -l /home"] call AE3_armaos_fnc_shell_process;

[_computer, "devices"] call AE3_armaos_fnc_shell_process;
```

**Notes:**
- Parses the command and resolves any command links
- Adds to history and executes the appropriate command function

---

### AE3_armaos_fnc_shell_getOpts

Parses command-line options and arguments according to command settings.

**Syntax:**
```sqf
private _parsedOpts = [_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts
```

**Parameters:**
- `_computer` (OBJECT) - The computer object
- `_options` (ARRAY) - Raw options array from command line
- `_commandSettings` (ARRAY) - Command settings array `[commandName, commandOpts, commandSyntax]`

**Return Value:** Parsed options array (use with `[] params`) (ARRAY)

**Examples:**
```sqf
private _ae3OptsSuccess = false;
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (_ae3OptsSuccess) then {
    // Process command with parsed options
};
```

**Notes:**
- Supports both short (`-o`) and long (`--option`) form options
- Type validation and default values
- Returns `_ae3OptsSuccess` variable to indicate parsing success

---

### AE3_armaos_fnc_shell_stdout

Writes output to the terminal display (standard output).

**Syntax:**
```sqf
[_computer, _input] call AE3_armaos_fnc_shell_stdout
```

**Parameters:**
- `_computer` (OBJECT) - The computer object
- `_input` (STRING or ARRAY) - The text to output

**Return Value:** None

**Examples:**
```sqf
[_computer, "Hello World"] call AE3_armaos_fnc_shell_stdout;

[_computer, ["Line 1", "Line 2", "Line 3"]] call AE3_armaos_fnc_shell_stdout;
```

**Notes:** This is the standard output function for all commands

---

### AE3_armaos_fnc_shell_stdin

Gets user input from the terminal (standard input).

**Syntax:**
```sqf
private _input = [_computer] call AE3_armaos_fnc_shell_stdin
```

**Parameters:**
- `_computer` (OBJECT) - The computer object

**Return Value:** User input text (STRING)

**Examples:**
```sqf
[_computer, "Enter password: "] call AE3_armaos_fnc_shell_stdout;
private _password = [_computer] call AE3_armaos_fnc_shell_stdin;
```

**Notes:**
- Waits for user to enter text and press enter
- Blocks until input is received

---

### AE3_armaos_fnc_shell_executeFile

Executes a file from the filesystem.

**Syntax:**
```sqf
[_computer, _path, _options] call AE3_armaos_fnc_shell_executeFile
```

**Parameters:**
- `_computer` (OBJECT) - The computer object
- `_path` (STRING) - Path to the file to execute
- `_options` (ARRAY) - Command options and arguments

**Return Value:** None

**Examples:**
```sqf
[_computer, "/bin/ls", ["-l"]] call AE3_armaos_fnc_shell_executeFile;

[_computer, "/usr/local/bin/mycommand", []] call AE3_armaos_fnc_shell_executeFile;
```

**Notes:**
- If file contains executable code, spawns it as a process
- Waits for process completion

---

## ArmaOS Terminal API

Terminal display, input handling, and UI functions.

### AE3_armaos_fnc_terminal_addLines

Adds one or more lines of output to the terminal buffer.

**Syntax:**
```sqf
[_computer, _outputLines] call AE3_armaos_fnc_terminal_addLines
```

**Parameters:**
- `_computer` (OBJECT) - The computer object
- `_outputLines` (STRING or ARRAY) - Lines to add to terminal output

**Return Value:** None

**Examples:**
```sqf
[_computer, "Single line output"] call AE3_armaos_fnc_terminal_addLines;

[_computer, ["Line 1", "Line 2", "Line 3"]] call AE3_armaos_fnc_terminal_addLines;
```

**Notes:** Long lines are automatically wrapped to terminal width

---

### AE3_armaos_fnc_terminal_updateOutput

Updates the terminal display control with the current visible buffer contents.

**Syntax:**
```sqf
[_computer, _outputControl] call AE3_armaos_fnc_terminal_updateOutput
```

**Parameters:**
- `_computer` (OBJECT) - The computer object
- `_outputControl` (CONTROL) - The UI control to update

**Return Value:** None

**Examples:**
```sqf
[_computer, _terminalDisplay] call AE3_armaos_fnc_terminal_updateOutput;
```

**Notes:**
- Handles rendering, scrolling, and UI-on-Texture synchronization
- Throttled updates (default 0.3s) to reduce network traffic
- Sends raw STRING data (not TEXT) to avoid serialization warnings

---

### AE3_armaos_fnc_terminal_setPrompt

Updates the terminal prompt line with the current prompt text.

**Syntax:**
```sqf
[_computer] call AE3_armaos_fnc_terminal_setPrompt
```

**Parameters:**
- `_computer` (OBJECT) - The computer object

**Return Value:** None

**Examples:**
```sqf
[_computer] call AE3_armaos_fnc_terminal_setPrompt;
```

**Notes:** Typically shows username, hostname, and current directory

---

### AE3_armaos_fnc_terminal_addToHistory

Adds a command to the current user's command history.

**Syntax:**
```sqf
[_computer, _commandString] call AE3_armaos_fnc_terminal_addToHistory
```

**Parameters:**
- `_computer` (OBJECT) - The computer object
- `_commandString` (STRING) - The command to add to history

**Return Value:** None

**Examples:**
```sqf
[_computer, "ls -l"] call AE3_armaos_fnc_terminal_addToHistory;
```

**Notes:** Command history is per-user and can be recalled with arrow keys

---

### AE3_armaos_fnc_terminal_setKeyboardLayout

Sets the keyboard layout for the terminal.

**Syntax:**
```sqf
[_computer, _languageButton, _consoleOutput, _terminalKeyboardLayout] call AE3_armaos_fnc_terminal_setKeyboardLayout
```

**Parameters:**
- `_computer` (OBJECT) - The computer object
- `_languageButton` (CONTROL) - The language button UI control
- `_consoleOutput` (CONTROL) - The console output UI control
- `_terminalKeyboardLayout` (STRING) - The keyboard layout code (US, DE, FR, IT, RU, AR, HE, HU, TR)

**Return Value:** None

**Examples:**
```sqf
[_computer, _langBtn, _output, "DE"] call AE3_armaos_fnc_terminal_setKeyboardLayout;

[_computer, _langBtn, _output, "RU"] call AE3_armaos_fnc_terminal_setKeyboardLayout;
```

**Notes:**
- Supports 9 languages: US, DE, FR, IT, RU, AR, HE, HU, TR
- Syncs to CBA settings
- Updates keyboard key mappings

---

## Power Management API

Battery, generator, and power control functions.

### AE3_power_fnc_getBatteryLevel

Returns the battery level of a battery device.

**Syntax:**
```sqf
private _batteryInfo = [_battery, _hint] call AE3_power_fnc_getBatteryLevel
```

**Parameters:**
- `_battery` (OBJECT) - Battery object to check
- `_hint` (BOOL, optional) - Display hint with battery level (default: false)

**Return Value:** Array containing:
- Index 0 (NUMBER) - Battery level in Wh
- Index 1 (NUMBER) - Battery level percent
- Index 2 (NUMBER) - Battery capacity in Wh

**Examples:**
```sqf
private _batteryInfo = [_battery, true] call AE3_power_fnc_getBatteryLevel;
_batteryInfo params ["_levelWh", "_levelPercent", "_capacityWh"];

private _info = [_laptop getVariable "AE3_power_internal", false] call AE3_power_fnc_getBatteryLevel;
```

**Notes:**
- Handles both scheduled and unscheduled execution contexts
- For laptops, pass the internal battery object instead of the parent device

---

### AE3_power_fnc_setBatteryLevel

Sets the battery level of a battery to a specified percentage.

**Syntax:**
```sqf
private _success = [_battery, _batteryLevelPercent] call AE3_power_fnc_setBatteryLevel
```

**Parameters:**
- `_battery` (OBJECT) - Battery object to modify
- `_batteryLevelPercent` (NUMBER) - Battery level in percent (0-100)

**Return Value:** Success status (BOOL)

**Examples:**
```sqf
[_battery, 100] call AE3_power_fnc_setBatteryLevel;

[_battery, 50] remoteExecCall ["AE3_power_fnc_setBatteryLevel", 2];
```

**Notes:**
- Must be executed on the server
- Value is automatically clamped between 0 and 100 percent

---

### AE3_power_fnc_turnOnDevice

Turns on a power device (laptop, generator, solar panel, battery, etc.).

**Syntax:**
```sqf
private _success = [_device] call AE3_power_fnc_turnOnDevice
```

**Parameters:**
- `_device` (OBJECT) - Device to turn on

**Return Value:** Success status (BOOL)

**Examples:**
```sqf
private _success = [_laptop] call AE3_power_fnc_turnOnDevice;

if ([_generator] call AE3_power_fnc_turnOnDevice) then {
    hint "Generator started";
};
```

**Notes:**
- Checks turn-on conditions including power state, mutex lock, and device-specific conditions
- Works for any device configured with the power system

---

### AE3_power_fnc_turnOffDevice

Turns off a power device.

**Syntax:**
```sqf
private _success = [_device] call AE3_power_fnc_turnOffDevice
```

**Parameters:**
- `_device` (OBJECT) - Device to turn off

**Return Value:** Success status (BOOL)

**Examples:**
```sqf
[_laptop] call AE3_power_fnc_turnOffDevice;
```

---

### AE3_power_fnc_standbyDevice

Puts a device into standby mode.

**Syntax:**
```sqf
private _success = [_device] call AE3_power_fnc_standbyDevice
```

**Parameters:**
- `_device` (OBJECT) - Device to put into standby

**Return Value:** Success status (BOOL)

**Examples:**
```sqf
[_laptop] call AE3_power_fnc_standbyDevice;
```

---

### AE3_power_fnc_getPowerState

Gets the current power state of a device.

**Syntax:**
```sqf
private _powerState = [_device] call AE3_power_fnc_getPowerState
```

**Parameters:**
- `_device` (OBJECT) - Device to check

**Return Value:** Power state (NUMBER) - -1: Off, 0: Standby, 1: On

**Examples:**
```sqf
private _state = [_laptop] call AE3_power_fnc_getPowerState;

if (_state == 1) then { hint "Device is on"; };
```

---

### AE3_power_fnc_createPowerConnection

Creates a power connection between two devices.

**Syntax:**
```sqf
[_source, _target] call AE3_power_fnc_createPowerConnection
```

**Parameters:**
- `_source` (OBJECT) - Power source device (generator, solar panel, battery)
- `_target` (OBJECT) - Power consumer device

**Return Value:** None

**Examples:**
```sqf
[_generator, _laptop] call AE3_power_fnc_createPowerConnection;

[_solarPanel, _battery] call AE3_power_fnc_createPowerConnection;
```

---

### AE3_power_fnc_removePowerConnection

Removes a power connection between two devices.

**Syntax:**
```sqf
[_source, _target] call AE3_power_fnc_removePowerConnection
```

**Parameters:**
- `_source` (OBJECT) - Power source device
- `_target` (OBJECT) - Power consumer device

**Return Value:** None

**Examples:**
```sqf
[_generator, _laptop] call AE3_power_fnc_removePowerConnection;
```

---

## FlashDrive API

USB flash drive operations for data transfer between computers.

### AE3_flashdrive_fnc_mount

Mounts a flash drive attached to a USB interface.

**Syntax:**
```sqf
[_computer, _interface, _username] call AE3_flashdrive_fnc_mount
```

**Parameters:**
- `_computer` (OBJECT) - Computer object with USB interfaces
- `_interface` (STRING) - Name of the USB interface to mount (e.g., "usb0")
- `_username` (STRING) - ArmaOS username to grant access permissions

**Return Value:** None

**Examples:**
```sqf
[_laptop, "usb0", "user"] call AE3_flashdrive_fnc_mount;

[_laptop, "usb1", "root"] call AE3_flashdrive_fnc_mount;
```

**Notes:**
- Creates mount point at `/mnt/<interface>`
- Makes drive's filesystem accessible to the user
- Throws exception if interface doesn't exist or is empty

---

### AE3_flashdrive_fnc_unmount

Unmounts a flash drive from a USB interface.

**Syntax:**
```sqf
[_computer, _interface] call AE3_flashdrive_fnc_unmount
```

**Parameters:**
- `_computer` (OBJECT) - Computer object
- `_interface` (STRING) - Name of the USB interface to unmount

**Return Value:** None

**Examples:**
```sqf
[_laptop, "usb0"] call AE3_flashdrive_fnc_unmount;
```

**Notes:**
- Saves filesystem state back to the drive
- Removes mount point from `/mnt/<interface>`

---

### AE3_flashdrive_fnc_connectFlashDrive

Connects a flash drive object to a computer's USB interface.

**Syntax:**
```sqf
[_computer, _flashDrive] call AE3_flashdrive_fnc_connectFlashDrive
```

**Parameters:**
- `_computer` (OBJECT) - Computer object
- `_flashDrive` (OBJECT) - Flash drive object to connect

**Return Value:** None

**Examples:**
```sqf
[_laptop, _usbDrive] call AE3_flashdrive_fnc_connectFlashDrive;
```

---

### AE3_flashdrive_fnc_disconnectFlashDrive

Disconnects a flash drive from a computer's USB interface.

**Syntax:**
```sqf
[_computer, _flashDrive] call AE3_flashdrive_fnc_disconnectFlashDrive
```

**Parameters:**
- `_computer` (OBJECT) - Computer object
- `_flashDrive` (OBJECT) - Flash drive object to disconnect

**Return Value:** None

**Examples:**
```sqf
[_laptop, _usbDrive] call AE3_flashdrive_fnc_disconnectFlashDrive;
```

---

### AE3_flashdrive_fnc_item2obj

Converts an inventory item to a world object.

**Syntax:**
```sqf
private _object = [_player, _item, _pos] call AE3_flashdrive_fnc_item2obj
```

**Parameters:**
- `_player` (OBJECT) - Player who has the item in inventory
- `_item` (STRING) - Class name of the item to convert
- `_pos` (ARRAY, optional) - Position to create the object at (default: `[0,0,0]`)

**Return Value:** Created object or objNull if item not found (OBJECT)

**Examples:**
```sqf
private _drive = [player, "Item_FlashDisk_AE3_ID_1", player modelToWorld [0,1,0]] call AE3_flashdrive_fnc_item2obj;
```

**Notes:**
- Preserves all variables from the item's namespace
- Removes the item from player inventory

---

### AE3_flashdrive_fnc_obj2item

Converts a world object to an inventory item.

**Syntax:**
```sqf
[_player, _object] call AE3_flashdrive_fnc_obj2item
```

**Parameters:**
- `_player` (OBJECT) - Player to give the item to
- `_object` (OBJECT) - World object to convert

**Return Value:** None

**Examples:**
```sqf
[player, _flashDrive] call AE3_flashdrive_fnc_obj2item;
```

**Notes:** Preserves all object variables in the item's namespace

---

## Interaction API

ACE3 interaction menus and equipment initialization.

### AE3_interaction_fnc_compileEquipment

Compiles the equipment interactions from config for an object's class.

**Syntax:**
```sqf
[_equipment] call AE3_interaction_fnc_compileEquipment
```

**Parameters:**
- `_equipment` (OBJECT) - The equipment object to compile interactions for

**Return Value:** None

**Examples:**
```sqf
[_laptop] call AE3_interaction_fnc_compileEquipment;

[_desk] call AE3_interaction_fnc_compileEquipment;
```

**Notes:**
- Analogous to ACE3 MenuCompile
- Parses `AE3_Equipment` config
- Initializes the interaction system

---

### AE3_interaction_fnc_initLaptop

Initializes ACE3 interactions for a laptop.

**Syntax:**
```sqf
[_laptop] call AE3_interaction_fnc_initLaptop
```

**Parameters:**
- `_laptop` (OBJECT) - The laptop object

**Return Value:** None

**Examples:**
```sqf
[_laptop] call AE3_interaction_fnc_initLaptop;
```

---

### AE3_interaction_fnc_laptop_open

Opens a laptop by animating the lid to the open position.

**Syntax:**
```sqf
[_laptop] call AE3_interaction_fnc_laptop_open
```

**Parameters:**
- `_laptop` (OBJECT) - The laptop to open

**Return Value:** true (BOOL)

**Examples:**
```sqf
[_laptop] call AE3_interaction_fnc_laptop_open;
```

**Notes:** Sets animation phase to 0

---

### AE3_interaction_fnc_laptop_close

Closes a laptop by animating the lid to the closed position.

**Syntax:**
```sqf
[_laptop] call AE3_interaction_fnc_laptop_close
```

**Parameters:**
- `_laptop` (OBJECT) - The laptop to close

**Return Value:** true (BOOL)

**Examples:**
```sqf
[_laptop] call AE3_interaction_fnc_laptop_close;
```

**Notes:** Sets animation phase to 1

---

### AE3_interaction_fnc_initDesk

Initializes ACE3 interactions for a desk.

**Syntax:**
```sqf
[_desk] call AE3_interaction_fnc_initDesk
```

**Parameters:**
- `_desk` (OBJECT) - The desk object

**Return Value:** None

**Examples:**
```sqf
[_desk] call AE3_interaction_fnc_initDesk;
```

---

### AE3_interaction_fnc_initLamp

Initializes ACE3 interactions for a lamp.

**Syntax:**
```sqf
[_lamp] call AE3_interaction_fnc_initLamp
```

**Parameters:**
- `_lamp` (OBJECT) - The lamp object

**Return Value:** None

**Examples:**
```sqf
[_lamp] call AE3_interaction_fnc_initLamp;
```

---

## Remote Sync API

Multiplayer variable synchronization functions.

### AE3_main_fnc_sendVarToRemote

Sets a local variable to a remote client for multiplayer synchronization.

**Syntax:**
```sqf
[_caller, _namespace, _variable] call AE3_main_fnc_sendVarToRemote
```

**Parameters:**
- `_caller` (NUMBER) - Client ID to send the variable to
- `_namespace` (NAMESPACE) - Namespace containing the variable
- `_variable` (STRING) - Name of the variable to send

**Return Value:** None

**Examples:**
```sqf
[clientOwner, missionNamespace, "myVariable"] call AE3_main_fnc_sendVarToRemote;
```

**Notes:** Internal function, typically not called directly by users

---

### AE3_main_fnc_getRemoteVar

Retrieves a variable from a remote client and sets it locally.

**Syntax:**
```sqf
[_namespace, _variable, _from] call AE3_main_fnc_getRemoteVar
```

**Parameters:**
- `_namespace` (NAMESPACE) - Namespace where the variable should be stored locally
- `_variable` (STRING) - Name of the variable to retrieve
- `_from` (NUMBER, optional) - Client ID to retrieve from (default: 2, the server)

**Return Value:** None

**Examples:**
```sqf
[missionNamespace, "remoteData"] call AE3_main_fnc_getRemoteVar;

[missionNamespace, "remoteData", 3] call AE3_main_fnc_getRemoteVar; // From specific client
```

**Notes:**
- Waits until the variable transfer is complete
- Only functions in multiplayer

---

## Additional Notes

### Permissions System

Permissions are represented as: `[[owner x,r,w],[everyone x,r,w]]`
- `x` = Execute permission
- `r` = Read permission
- `w` = Write permission

Example: `[[true,true,true],[true,true,false]]` = Owner has full access, everyone can execute and read but not write

### Filesystem Pointers

Pointers are arrays of directory names forming an absolute path:
- `[]` = Root directory (`/`)
- `["home", "user"]` = `/home/user`
- `["tmp", "logs", "system"]` = `/tmp/logs/system`

### Power States

Device power states are represented as numbers:
- `-1` = Powered off
- `0` = Standby
- `1` = Powered on

### Multiplayer Considerations

- Many functions require server execution (check `isServer` in function code)
- Remote variable sync functions handle cross-network state
- Terminal updates are throttled to reduce network traffic
- **NEVER transmit TEXT (structured text) via remoteExec** - always send STRING and render locally

### Error Handling

Most functions throw exceptions on error. Use try-catch blocks:

```sqf
try {
    [[], _filesystem, "/tmp/file.txt", "root", 1] call AE3_filesystem_fnc_getFile;
} catch {
    hint format ["Error: %1", _exception];
};
```

---

For more information, see:
- [Architecture Guide](Architecture.md) - System architecture and design patterns
- [Terminal Guide](Terminal-Guide.md) - Terminal interface and OS commands
- [ACE Mutex Guide](ACE-Mutex.md) - Computer mutex system
