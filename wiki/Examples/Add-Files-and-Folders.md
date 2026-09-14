# Add Files and Folders

This recipe adds readable laptop documents and folders. It includes the Eden Editor workflow, the Zeus live workflow, and the API workflow.

Use folders when you want players to browse a believable filesystem. Use files when the content is the actual clue, log, note, code fragment, password hint, or evidence.

## Result

After this recipe, players can find content such as:

```text
/home/admin/intel/orders.txt
/home/admin/logs/radio.txt
/var/log/site.log
```

Players can read the content through:

- GUI Desktop: Files app, Notepad/viewer behavior, or other file-aware apps.
- Terminal/TUI: commands such as `ls`, `cd`, `cat`, `find`, and `grep`.

## Path Planning

Use absolute paths for mission setup:

| Path | Good use |
| --- | --- |
| `/home/admin/Desktop/brief.txt` | Easy GUI discovery for the `admin` user. |
| `/home/admin/intel/orders.txt` | Player browses into an intel folder. |
| `/var/log/browser_history` | Browser history store; normally use Browser API instead of editing directly. |
| `/tmp/new/example.txt` | Temporary/testing content. |

For ordinary player-readable text, keep `Is Code` disabled. Enable code only when you intentionally create executable terminal command content.

### Rules a Path Must Follow

A path or owner name that breaks one of these is rejected outright, and the module that carried it is removed at mission start without creating anything:

| Rule | Example that fails | Use instead |
| --- | --- | --- |
| No spaces anywhere in the path | `/home/admin/mission orders.txt` | `/home/admin/mission_orders.txt` |
| No spaces in the owner name | `site admin` | `admin` |
| Path must not be empty | *(blank Path field)* | `/home/admin/notes.txt` |
| Owner must not be empty | *(blank Owner field)* | `admin` |
| Encryption key must not be empty when encryption is enabled | *(blank Key field)* | any key string |

A rejection is written to the RPT log, naming the rule and the value that broke it:

```text
AE3: Add File module skipped - the file path contains a space, which paths cannot hold (path: '/home/admin/mission orders.txt', owner: 'admin')
```

If a file you added never appears in game, search the RPT for `AE3: Add File module skipped` or `AE3: Add Directory module skipped` before looking anywhere else.

### Who Can Read What, and Why `/root` Says "Permission denied"

The filesystem enforces Unix-style ownership. A file carries an owner plus two permission sets: one for the owner, one for everyone else. `/root` is root's own home directory and grants nothing to everyone else, so a laptop logged in as `admin` browsing to `/root` is told `Permission denied` - the path exists, the account simply has no claim on it. Content meant for a player belongs under that player's own home, typically `/home/admin`, or needs Everyone Read enabled.

Three ways to reach another user's files:

- Log in as `root` directly. Only possible when the laptop or the mission allows direct root login; see the *Allow direct root login* setting and the per-laptop Eden attribute.
- Use `sudo` or `su` from an account listed in `/etc/sudoers`.
- Rely on superuser elevation: with the *Sudoers act as root at the terminal* setting enabled (the default), an account in `/etc/sudoers` reads and writes any file from the terminal without typing `sudo` first, matching what the desktop Files app already does for that account. Turn the setting off and both interfaces hold that account to strict Unix rules instead.

The `admin` account is treated as a superuser throughout, so mission content owned by `root` is still reachable from it.

## Eden Editor Workflow

Use this before the mission starts.

### Add a Folder in Eden

1. Place an AE3 laptop.
2. Place the `AE3: Add Directory` module from the AE3 filesystem module category.
3. Double-click the module to open its attributes.
4. Set `Path` to an absolute folder path, for example `/home/admin/intel`.
5. Set `Owner` to the user who should own it, for example `admin`; use `root` for system-owned content.
6. Set permissions:
   - Owner Read: enabled.
   - Owner Write: enabled if the owner should edit it.
   - Owner Execute: enabled for folders players must enter.
   - Everyone Read/Execute: enabled if any logged-in user may browse it.
   - Everyone Write: usually disabled unless shared editing is intended.
7. Sync the module to the target laptop.
8. Preview the mission and verify the folder exists.

### Add a File in Eden

1. Place the `AE3: Add File` module.
2. Double-click the module to open its attributes.
3. Set `Path`, for example `/home/admin/intel/orders.txt`.
4. Fill `Content` with the text players should read.
5. Leave `Is Code` disabled for normal documents.
6. Set `Owner`, usually `admin` or `root`.
7. Set file permissions:
   - Owner Read: enabled.
   - Owner Write: enabled if the owner can edit.
   - Owner Execute: disabled for normal documents.
   - Everyone Read: enabled if other users should read it.
   - Everyone Write/Execute: usually disabled.
8. Optional: enable encryption only when the mission intentionally uses encryption gameplay.
9. Sync the module to the same laptop.
10. Preview and test from the intended player slot.

### Eden Ordering Tip

If you add both a folder and a file inside that folder, place both modules and sync both to the laptop. The directory module has earlier priority than the file module, so the folder should be created before the file during mission start.

## Copy-Paste Bundle

Use this when the folder structure itself should be part of the clue:

```sqf
if (isServer) then {
    private _fs = _laptop getVariable "AE3_filesystem";
    private _dirPerms = [[true, true, true], [true, false, true]];
    private _filePerms = [[true, true, false], [true, false, false]];

    [[], _fs, "/home/admin/intel", "root", "admin", _dirPerms] call AE3_filesystem_fnc_ensureDir;
    [[], _fs, "/home/admin/intel/notes", "root", "admin", _dirPerms] call AE3_filesystem_fnc_ensureDir;
    [[], _fs, "/home/admin/intel/orders.txt", "Move at dawn." + endl + "Check the relay before departure.", "root", "admin", _filePerms] call AE3_filesystem_fnc_ensureFile;
    [[], _fs, "/home/admin/intel/notes/route.txt", "Route Red is primary." + endl + "Blue tunnel is fallback.", "root", "admin", _filePerms] call AE3_filesystem_fnc_ensureFile;
    [[], _fs, "/var/log/site.log", "", "root"] call AE3_filesystem_fnc_ensureFile;
    [[], _fs, "/var/log/site.log", "root", "02:17 motion detected" + endl, true] call AE3_filesystem_fnc_writeToFile;

    _laptop setVariable ["AE3_filesystem", _fs, true];
};
```

Pair it with a browser page or email when you want players to discover the path instead of being handed the whole tree.

## Zeus Workflow

Use this during a live mission.

### Add a Folder in Zeus

1. Open Zeus.
2. Place the `AE3: Add Directory` module.
3. Use the module dialog to enter the folder path, owner, and permissions.
4. Place it on, or sync it to, the target laptop depending on the curator workflow shown by the module.
5. Confirm/apply the module.
6. If players have a GUI Files app open, ask them to refresh/reopen the folder if it does not update immediately.

### Add a File in Zeus

1. Open Zeus.
2. Place the `AE3: Add File` module.
3. Enter the file path and content.
4. Leave code disabled for normal text.
5. Set owner and permissions.
6. Place/sync it to the target laptop.
7. Confirm that players can read it through the interface they are using.

### Zeus Live-Play Advice

- Do not silently rewrite evidence while players are looking at it.
- Add a new file instead of changing an existing clue unless the story calls for tampering.
- Keep live-added content short enough to read under mission pressure.
- If the new file is important, give players an in-world reason to check the laptop again.

## API Workflow

Use the Filesystem API for direct control. Run setup on the server.

### Create Folder and File

```sqf
if (isServer) then {
    private _fs = _laptop getVariable "AE3_filesystem";
    private _dirPerms = [[true, true, true], [true, false, true]];
    private _filePerms = [[true, true, false], [true, false, false]];

    [[], _fs, "/home/admin/intel", "root", "admin", _dirPerms] call AE3_filesystem_fnc_ensureDir;
    [[], _fs, "/home/admin/intel/orders.txt", "Move at dawn.", "root", "admin", _filePerms] call AE3_filesystem_fnc_ensureFile;

    _laptop setVariable ["AE3_filesystem", _fs, true];
};
```

### Append to a Log File

```sqf
if (isServer) then {
    private _fs = _laptop getVariable "AE3_filesystem";

    [[], _fs, "/var/log", "root"] call AE3_filesystem_fnc_ensureDir;
    [[], _fs, "/var/log/site.log", "", "root"] call AE3_filesystem_fnc_ensureFile;
    [[], _fs, "/var/log/site.log", "root", "02:17 motion detected" + endl, true] call AE3_filesystem_fnc_writeToFile;

    _laptop setVariable ["AE3_filesystem", _fs, true];
};
```

### Read Back During Debugging

```sqf
private _fs = _laptop getVariable "AE3_filesystem";
private _content = [[], _fs, "/home/admin/intel/orders.txt", "admin", 0] call AE3_filesystem_fnc_getFile;
systemChat _content;
```

## Testing

GUI test:

1. Log into the laptop as the intended user.
2. Open the Files app.
3. Browse to the folder.
4. Open the file.
5. Confirm text, media marker, or locked-file behavior is correct.

Terminal test:

```text
whoami
ls /home/admin
ls /home/admin/intel
cat /home/admin/intel/orders.txt
```

Permission test:

1. Log in as a different user.
2. Try to browse/read the same path.
3. Confirm the result matches the intended permissions.

## Common Mistakes

| Problem | Fix |
| --- | --- |
| File module is not synced | Sync the module to the laptop in Eden, or place/apply it correctly in Zeus. |
| File path uses a missing folder | Add the folder first or use API `ensureDir`. |
| Players cannot enter a folder | Folder execute permission is disabled. |
| Players can read too much | Disable Everyone Read on sensitive files. |
| GUI user cannot find the file | Put it under `/home/<user>/Desktop` or give a clue to the path. |
| API file exists only on server | Publish the edited filesystem back to the laptop with `setVariable`. |

## Related Pages

- [Filesystem System](../Systems/Filesystem.md)
- [Filesystem API](../Reference/Filesystem-API.md)
- [Eden Editor Guide](../Eden-Editor-Guide.md)
- [Zeus Guide](../Zeus-Guide.md)
- [Examples Library](README.md)
