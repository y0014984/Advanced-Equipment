# Filesystem API

The Filesystem component provides a small Unix-like virtual filesystem used by both the terminal and desktop GUI. Mission scripts can use it directly, but higher-level APIs such as `AE3_desktop_fnc_addEmail`, `AE3_desktop_fnc_registerWebpage`, `AE3_desktop_fnc_registerMedia`, and `AE3_armaos_fnc_computer_addUser` are usually safer for mission content.

Use direct filesystem calls when you are building framework extensions, creating custom command files, manipulating permissions, or writing content that has no higher-level helper.

## Filesystem Object Format

A filesystem object is:

```sqf
[content, owner, permissions]
```

| Field | Type | Meaning |
| --- | --- | --- |
| `content` | HashMap, String, Code, or marker content | Directories use a HashMap. Files use the value that apps or commands will read. |
| `owner` | String | Owner username. `root` bypasses most ownership checks. |
| `permissions` | Array | `[[ownerR, ownerW, ownerX], [everyoneR, everyoneW, everyoneX]]`. |

The root filesystem stored on a laptop is also a filesystem object:

```sqf
private _filesystem = _laptop getVariable ["AE3_filesystem", []];
```

Most functions mutate `_filesystem` in place. If you manually retrieved it from a laptop, publish it after the changes:

```sqf
_laptop setVariable ["AE3_filesystem", _filesystem, true];
```

For laptop-locality-aware publishing, use the same target pattern used by the surrounding component when available. Most mission init scripts can use `true`.

## Common Arguments

Most low-level calls share these parameters:

| Argument | Type | Meaning |
| --- | --- | --- |
| `_pntr` | Array | Current directory pointer, for example `[]` for root or `["home", "admin"]`. Use `[]` when passing absolute paths. |
| `_filesystem` | Array | Filesystem object to mutate/read. |
| `_target` | String | Absolute or relative virtual path. |
| `_user` | String | User performing the operation. Affects permissions and `~` resolution. |
| `_owner` | String | Owner assigned to newly created content. |
| `_permissions` | Array | Permission tuple. |

Permission indexes:

| Index | Meaning |
| --- | --- |
| `0` | Read |
| `1` | Write |
| `2` | Execute |

## Creating Directories

### `AE3_filesystem_fnc_createDir`

Creates a directory. Throws if the directory already exists.

```sqf
[_pntr, _filesystem, _target, _user, _owner, _permissions] call AE3_filesystem_fnc_createDir;
```

Arguments:

| Index | Type | Required | Meaning |
| --- | --- | --- | --- |
| `0` | Array | Yes | Current pointer. |
| `1` | Array | Yes | Filesystem object. |
| `2` | String | Yes | Directory path. |
| `3` | String | Yes | User creating the directory. |
| `4` | String | Optional | New directory owner. Defaults to `_user`. |
| `5` | Array | Optional | Defaults to owner `rwx`, everyone none. |

Example:

```sqf
private _fs = _laptop getVariable "AE3_filesystem";

[[], _fs, "/home/admin/intel", "root", "admin", [[true, true, true], [true, false, true]]] call AE3_filesystem_fnc_createDir;

_laptop setVariable ["AE3_filesystem", _fs, true];
```

### `AE3_filesystem_fnc_ensureDir`

Creates a directory only if it is missing. Returns `true` when created and `false` when it already existed. Other exceptions are rethrown.

```sqf
private _created = [[], _fs, "/var/log", "root"] call AE3_filesystem_fnc_ensureDir;
```

Use this in repeatable mission initialization scripts because preview restarts and JIP repair scripts may run more than once.

## Creating Files

### `AE3_filesystem_fnc_createFile`

Creates a file with content. Throws if the file already exists.

```sqf
[_pntr, _filesystem, _target, _content, _user, _owner, _permissions] call AE3_filesystem_fnc_createFile;
```

Default file permissions are owner read/write, everyone none.

Example:

```sqf
private _perms = [[true, true, false], [true, false, false]];
[[], _fs, "/home/admin/orders.txt", "Move at dawn.", "root", "admin", _perms] call AE3_filesystem_fnc_createFile;
```

Files can contain strings, code, media markers, locked-file payloads, symlink markers, or other structured values expected by a custom app. For normal text intel, use strings.

### `AE3_filesystem_fnc_ensureFile`

Creates a file only if it is missing. Returns `true` when created and `false` when it already existed.

```sqf
[[], _fs, "/var/mail/inbox", "", "root"] call AE3_filesystem_fnc_ensureFile;
```

Use `ensureFile` before appending to a log-like file.

## Reading and Writing Files

### `AE3_filesystem_fnc_getFile`

Reads file content after checking the requested permission.

```sqf
private _content = [_pntr, _filesystem, _target, _user, _permission] call AE3_filesystem_fnc_getFile;
```

Example:

```sqf
private _orders = [[], _fs, "/home/admin/orders.txt", "admin", 0] call AE3_filesystem_fnc_getFile;
```

The return value is whatever was stored in the file. Do not assume it is a string unless you control the file.

### `AE3_filesystem_fnc_writeToFile`

Replaces or appends string content. Requires write permission on the file.

```sqf
[_pntr, _filesystem, _target, _user, _content, _appendMode] call AE3_filesystem_fnc_writeToFile;
```

Example:

```sqf
[[], _fs, "/var/log/custom.log", "root", "Laptop seeded." + endl, true] call AE3_filesystem_fnc_writeToFile;
```

`_appendMode` defaults to `false`. Pass `true` for logs, browser history, chat logs, or mail-like append behavior.

## Listing and Searching

### `AE3_filesystem_fnc_lsdir`

Lists a directory and returns terminal-formatted entries.

```sqf
private _entries = [[], _fs, "/home/admin", "admin", true] call AE3_filesystem_fnc_lsdir;
```

The final boolean enables long listing with owner/permission details.

### `AE3_filesystem_fnc_findFilesystemObject`

Recursively searches for an exact object name.

```sqf
private _result = [[], _fs, "admin", "orders.txt"] call AE3_filesystem_fnc_findFilesystemObject;
_result params ["_paths", "_missingPermissionCount"];
```

Use this for developer tooling or UI search. It respects read permissions and reports how many directories were skipped because the user could not read them.

## Moving, Copying, and Deleting

### `AE3_filesystem_fnc_mvObj`

Moves or copies a file or directory.

```sqf
[_pntr, _filesystem, _source, _target, _user, _copy] call AE3_filesystem_fnc_mvObj;
```

Example:

```sqf
[[], _fs, "/tmp/orders.txt", "/home/admin/orders.txt", "root"] call AE3_filesystem_fnc_mvObj;
[[], _fs, "/home/admin/orders.txt", "/backup/orders.txt", "root", true] call AE3_filesystem_fnc_mvObj;
```

`_copy` defaults to `false`. Copying requires read permission on the source. Moving requires write permission on the source and target directory.

### `AE3_filesystem_fnc_delObj`

Deletes a file or directory.

```sqf
[[], _fs, "/tmp/old.txt", "root"] call AE3_filesystem_fnc_delObj;
```

## Ownership and Permissions

### `AE3_filesystem_fnc_chown`

Changes owner. Root or the current owner can change ownership.

```sqf
[[], _fs, "/home/admin/intel", "root", "admin", true] call AE3_filesystem_fnc_chown;
```

The final boolean applies recursively when the target is a directory.

### `AE3_filesystem_fnc_chmod`

Changes permissions. Root can change any object; non-root users can change only objects they own.

```sqf
private _readOnlyForEveryone = [[true, true, false], [true, false, false]];
[[], _fs, "/home/admin/orders.txt", "admin", _readOnlyForEveryone] call AE3_filesystem_fnc_chmod;
```

Recursive directory update:

```sqf
[[], _fs, "/home/admin/intel", "root", [[true, true, true], [true, false, true]], true] call AE3_filesystem_fnc_chmod;
```

## Symlinks and Desktop Launchers

### `AE3_filesystem_fnc_symlink`

Creates a symlink marker file pointing at an absolute target path.

```sqf
[[], _fs, "/home/admin/Desktop/terminal.app", "/usr/share/applications/terminal.app", "admin"] call AE3_filesystem_fnc_symlink;
```

The desktop uses `.app` launcher files and symlinks to populate each user's Desktop. If you are curating a laptop GUI, you can copy or symlink launchers from `/usr/share/applications` into `/home/<user>/Desktop`.

## Mounts

### `AE3_filesystem_fnc_mount`

Mounts another filesystem into an existing mount point.

```sqf
[[], _hostFs, _flashdriveFs, "/mnt/usb0", "root"] call AE3_filesystem_fnc_mount;
```

### `AE3_filesystem_fnc_unmount`

Unmounts a filesystem from a mount point.

```sqf
[[], _hostFs, _flashdriveFs, "/mnt/usb0", "root"] call AE3_filesystem_fnc_unmount;
```

Mission scripts rarely need these directly. Prefer `AE3_flashdrive_fnc_mount` and `AE3_flashdrive_fnc_unmount` for USB devices because those functions also update laptop and flash drive object state.

## Device-Level Content Helpers

These are what `AE3: Add File`/`AE3: Add Directory` call under the hood. Unlike the low-level calls above, they take the device object directly (not a filesystem array + pointer) and publish the filesystem back for you — closer to what a mission script actually wants.

> **Writing text into a file from a script:** use `AE3_filesystem_fnc_device_writeFile` (below). `device_addFile` only *creates* files: on an existing path it does nothing unless `_overwrite` is set, and it silently does nothing when called on a client. The low-level `writeToFile` only edits a filesystem array you pass in — it never publishes it, and while a player is using the laptop their client holds the live copy, so a server-side write is lost when they exit. Mind the argument order: `createFile`/`ensureFile` take `_content` before `_user`, `writeToFile` takes `_user` before `_content`.

### `AE3_filesystem_fnc_device_writeFile`

Writes or appends text to a file on a laptop, server or flash drive. Callable from any machine; creates the file and missing folders by default; works while the device is in use (the open terminal/desktop/SSH session sees it immediately). Asynchronous.

```sqf
[_computer, _path, _content, _append, _create, _owner, _permissions, _size] call AE3_filesystem_fnc_device_writeFile;
```

| Index | Type | Default | Meaning |
| --- | --- | --- | --- |
| `0` | Object/String | Required | Device or its netId. |
| `1` | String | Required | Absolute file path. |
| `2` | String/Code | Required | Content (code makes it executable; cannot be appended). |
| `3` | Bool | `false` | Append instead of replace. |
| `4` | Bool | `true` | Create the file and folders if missing. |
| `5` | String | `"root"` | Owner when created. |
| `6` | Array | `[[true,true,false],[true,false,false]]` | Permissions when created. |
| `7` | Number/String | `-1` | Virtual size (`"50MB"` or bytes); `-1` keeps the current size. |

```sqf
[_laptop, "/home/user/notes.txt", "Meet at the bridge."] call AE3_filesystem_fnc_device_writeFile;
[_laptop, "/var/log/ops.log", "Contact at grid 042" + endl, true] call AE3_filesystem_fnc_device_writeFile;
```

### Virtual file size

Any file can carry a virtual size: copies (`cp`, desktop paste, SSH app upload/download) and Cyber Warfare downloads take as long as that size needs at the configured transfer speed (`AE3_TransferSpeedLocal`/`Usb`/`Network`, capped by `AE3_TransferMaxDuration`). Content is unchanged; `ls -l` and Properties show the size. The size travels with the file through copies.

```sqf
[_server, "/data/deathstar_plans.bin", "<binary>", false, true, "root", [[true,true,false],[true,false,false]], "800MB"] call AE3_filesystem_fnc_device_writeFile;
[_server, "/data/existing.db", "1.5GB"] call AE3_filesystem_fnc_device_setFileSize; // -1 restores the real size
```

Helpers: `AE3_filesystem_fnc_getFileSize [_entry]`, `AE3_filesystem_fnc_getFileEntry [_pntr, _fs, _path, _user]`, `AE3_filesystem_fnc_setFileSize [_pntr, _fs, _path, _user, _bytes]`, `AE3_filesystem_fnc_parseSize ["50MB"]`, `AE3_filesystem_fnc_formatSize [_bytes]`, `AE3_armaos_fnc_shell_transferDuration [_bytes, _medium]`.

### `AE3_filesystem_fnc_device_addDir`

```sqf
[_device, _path, _owner, _permissions] call AE3_filesystem_fnc_device_addDir;
```

```sqf
[_laptop, "/tmp/logs", "root", [[true, true, true], [false, false, false]]] call AE3_filesystem_fnc_device_addDir;
```

### `AE3_filesystem_fnc_device_addFile`

```sqf
[_computer, _path, _content, _isCode, _owner, _permissions, _isEncrypted, _encryptionAlgorithm, _encryptionKey, _overwrite, _isPicture, _pictureType, _size] call AE3_filesystem_fnc_device_addFile;
```

Arguments:

| Index | Type | Default | Meaning |
| --- | --- | --- | --- |
| `0` | Object | Required | Laptop or flash drive. |
| `1` | String | Required | File path. |
| `2` | String | Required | Content. Plain text, or SQF source if `_isCode`. |
| `3` | Bool | Required | If `true`, content is compiled to `CODE` (for command files under `/bin`, `/sbin`). |
| `4` | String | Required | Owner. |
| `5` | Array | Required | Permissions `[[ownerR,W,X],[everyoneR,W,X]]`. |
| `6` | Bool | `false` | Pre-encrypt the content (see below). Ignored/forced off for code files. |
| `7` | String | — | `"caesar"` or `"columnar"`, when `_isEncrypted`. |
| `8` | String | — | Encryption key: caesar wants a number 1-25 as a string (clamped if out of range); columnar wants a string of length ≥2 (padded with `_` if shorter). |
| `9` | Bool | `false` | Overwrite: remove an existing file with the same name (case-insensitive) first. Without it an existing file is left untouched. |
| `10` | Bool | `false` | Treat `_content` as a base64 image (inline picture). |
| `11` | String | `"auto"` | Image type hint for `_isPicture`. |
| `12` | Number/String | `-1` | Virtual file size (`"50MB"` or bytes). |

Server only (does nothing on a client). While the device is in use the file is added to the live session copy asynchronously.

Plain example:

```sqf
[_laptop, "/tmp/test.txt", "Hello World", false, "root", [[false,true,true],[false,true,false]]] call AE3_filesystem_fnc_device_addFile;
```

Command file example:

```sqf
[_laptop, "/bin/relay", "call myMod_fnc_relayCommand", true, "root", [[true,false,false],[true,false,false]]] call AE3_filesystem_fnc_device_addFile;
```

**Pre-encrypted content** (distinct from [locked files](../Systems/Encryption-and-Security.md) — this stores actual ciphertext with no password prompt; a player must run terminal `crypto -m decrypt` themselves to read it):

```sqf
[_laptop, "/home/admin/orders.enc", "MEET AT DAWN", false, "root", [[true,true,false],[true,false,false]], true, "caesar", "13"] call AE3_filesystem_fnc_device_addFile;
```

The file created on disk contains the *encrypted* text (`ZRRG NG QNJA` for the example above), so `cat` shows ciphertext and the player needs `crypto -m decrypt -a caesar -k 13 /home/admin/orders.enc` to recover it. See [Encryption and Security](../Systems/Encryption-and-Security.md) for puzzle design guidance and the difference from locked files.

## Low-Level Helpers

These are used internally by the terminal/desktop and are most useful when building custom commands, apps, or a framework extension.

### `AE3_filesystem_fnc_fsObjExists`

Checks whether a file or directory exists at a path, without throwing.

```sqf
private _exists = [[], _fs, "/tmp/test.txt", "root"] call AE3_filesystem_fnc_fsObjExists;
```

Use this to branch (`ensureFile`/`createFile`) without a try/catch.

### `AE3_filesystem_fnc_hasPermission`

Checks a permission on an already-resolved filesystem object and throws if denied; root and empty-owner objects always pass.

```sqf
[_fileObj, "root", 0] call AE3_filesystem_fnc_hasPermission;
```

Most of the time you don't call this directly — `getFile`/`writeToFile`/etc. already do the check — but it's useful when writing a custom command that needs the same permission semantics.

### `AE3_filesystem_fnc_resolvePntr`

Resolves a directory pointer (array of directory names) to its filesystem object, throwing if any segment doesn't exist.

```sqf
private _homeDir = [["home", "admin"], _fs] call AE3_filesystem_fnc_resolvePntr;
```

### `AE3_filesystem_fnc_symlinkTarget`

Given a filesystem object's content slot, returns the absolute target path if it's a symlink, or `""` otherwise.

```sqf
private _target = [(_obj select 0)] call AE3_filesystem_fnc_symlinkTarget;
```

Used to follow links transparently when reading/copying and to expose link targets to the web desktop.

## Idempotent Laptop Content Example

This example creates a repeatable setup block for one laptop:

```sqf
if (isServer) then {
    private _fs = _laptop getVariable "AE3_filesystem";
    private _dirPerms = [[true, true, true], [true, false, true]];
    private _filePerms = [[true, true, false], [true, false, false]];

    [[], _fs, "/home/admin/intel", "root", "admin", _dirPerms] call AE3_filesystem_fnc_ensureDir;
    [[], _fs, "/home/admin/intel/orders.txt", "Orders pending.", "root", "admin", _filePerms] call AE3_filesystem_fnc_ensureFile;
    [[], _fs, "/home/admin/intel/orders.txt", "root", "Move at 0430." + endl, false] call AE3_filesystem_fnc_writeToFile;

    _laptop setVariable ["AE3_filesystem", _fs, true];
};
```

## Common Failure Points

| Symptom | Likely cause |
| --- | --- |
| Duplicate path exception | Use `ensureDir`/`ensureFile` or delete the object before recreating it. |
| Permission exception | The `_user` argument does not own the file and everyone permission is not enough. Use `root` for setup scripts. |
| File appears on server but not client | The edited filesystem was not published back to the laptop, or publication used the wrong target locality. |
| GUI app cannot open file | The file content is not the marker or launcher format that app expects. |
| Mounted drive changes disappear | The flash drive object filesystem was not updated during unmount. Use Flashdrive API instead of direct mount calls. |
