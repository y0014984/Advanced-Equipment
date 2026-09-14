# Terminal Commands

This page documents the commands available in the AE3 terminal/TUI when they are installed on a laptop. A command must exist as a link on that laptop before a player can run it. Mission makers can install all base commands, a selected subset, optional security commands, optional games, and runtime custom commands.

For script APIs that install commands, see [ArmaOS API](ArmaOS-API.md).

## Installing Commands

All base commands:

```sqf
[_laptop, ["all"], false, false, []] call AE3_armaos_fnc_computer_initWithCommands;
```

Selected base commands:

```sqf
[_laptop, ["help", "man", "ls", "cd", "cat", "exit"], false, false, []] call AE3_armaos_fnc_computer_initWithCommands;
```

Security commands:

```sqf
[_laptop, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;
```

Games:

```sqf
[_laptop, true] call AE3_armaos_fnc_computer_addGames;
```

## Base Commands

| Command | Path | Purpose |
| --- | --- | --- |
| `help` | `/bin/help` | Lists available commands and descriptions. |
| `man` | `/bin/man` | Shows manual/help text for a command. |
| `ls` | `/bin/ls` | Lists directory contents. |
| `cd` | `/bin/cd` | Changes current directory. |
| `cat` | `/bin/cat` | Reads a file. Also opens readable content such as text intel. |
| `date` | `/bin/date` | Prints current mission date/time. |
| `history` | `/bin/history` | Shows command history. |
| `clear` | `/bin/clear` | Clears terminal output. |
| `rm` | `/bin/rm` | Removes a file or directory. |
| `mv` | `/bin/mv` | Moves or renames a file or directory. |
| `cp` | `/bin/cp` | Copies a file or directory. |
| `whoami` | `/bin/whoami` | Prints current logged-in user. |
| `mkdir` | `/bin/mkdir` | Creates a directory. |
| `touch` | `/bin/touch` | Creates an empty file. |
| `echo` | `/bin/echo` | Prints text. |
| `find` | `/bin/find` | Searches the filesystem by object name. |
| `grep` | `/bin/grep` | Searches text content. |
| `sudo` | `/bin/sudo` | Runs a single command as `root`. Available to `root` and to accounts listed in `/etc/sudoers` (see the [ArmaOS API](ArmaOS-API.md#superuser-access)). |
| `su` | `/bin/su` | Switches the session to another account, or to `root` when none is given. Same requirement as `sudo`. Unlike `sudo` the switch lasts until `exit`, which returns to the previous account. |

## System and Network Commands

| Command | Path | Purpose |
| --- | --- | --- |
| `ping` | `/sbin/ping` | Tests reachability to an IP. |
| `ip` | `/sbin/ip` | Shows or configures network/IP information. |
| `ifconfig` | `/sbin/ifconfig` | Alias using the same backend as `ip`. |
| `ssh` | `/sbin/ssh` | Opens a remote shell session when route and credentials allow it. |
| `msg` | `/sbin/msg` | Sends a message to another reachable device. |
| `exit` | `/sbin/exit` | Logs out or exits an SSH session. |
| `shutdown` | `/sbin/shutdown` | Turns the computer off. |
| `standby` | `/sbin/standby` | Puts the computer in standby. |
| `desktop` | `/bin/desktop` | Switches from the terminal to the GUI desktop (requires the desktop addon and GUI interface access). |

Network commands depend on power and routing. If a laptop or router is off, route checks may fail even when the physical connection exists.

## USB Commands

| Command | Path | Purpose |
| --- | --- | --- |
| `lsusb` | `/bin/lsusb` | Lists USB interfaces and attached flash drives. |
| `mount` | `/bin/mount` | Mounts an attached flash drive into `/mnt/<interface>`. |
| `umount` | `/bin/umount` | Unmounts an attached flash drive and saves its filesystem back to the drive. |
| `chown` | `/bin/chown` | Changes owner of files/directories. Often useful after mounting. |

Typical player sequence:

```text
lsusb
mount usb0
ls /mnt/usb0
cat /mnt/usb0/brief.txt
umount usb0
```

## Locked Files

| Command | Path | Purpose |
| --- | --- | --- |
| `unlock` | `/bin/unlock` | Opens a passworded file and prints its content if the password is correct. |

```text
unlock /home/admin/secret.txt hunter2
unlock -p /home/admin/secret.txt hunter2
```

`-p` permanently unlocks the file (rewrites it as plain content) if the user has write permission. Wrong passwords are logged to `/var/log/auth.log` and play an error sound — mission makers can use that log as its own clue trail (repeated failed attempts, brute-force detection, etc). Locked file content is stored as `AE3_LOCKED|<passwordLength>|<password><payload>`; see [Encryption and Security](../Systems/Encryption-and-Security.md).

## Security Commands

Security commands are optional and are not installed unless the mission maker enables them (per-laptop Crypto/Crack object attributes, or `AE3_armaos_fnc_computer_addSecurityCommands`).

| Command | Path | Purpose |
| --- | --- | --- |
| `crypto` | `/bin/crypto` | Encrypts or decrypts text or a file using a chosen algorithm and key. |
| `crack` | `/bin/crack` | Attempts to break `crypto` output without the key (bruteforce/statistics/key-length analysis). |

Both commands support `caesar` (shift cipher) and `columnar` (transposition cipher) algorithms, and `-h`/`--help` for full in-terminal help text.

### `crypto`

```text
crypto -m encrypt -a caesar -k 3 "MEET AT DAWN"
crypto -m decrypt -a caesar -k 3 "PHHW DW GDZQ"
crypto -m encrypt -a columnar -k KEY "MEET AT DAWN"
crypto -m encrypt -a caesar -k 3 -o /home/admin/message.enc "MEET AT DAWN"
crypto -m decrypt -a caesar -k 3 /home/admin/message.enc
```

| Option | Meaning |
| --- | --- |
| `-m encrypt\|decrypt` | Required. Direction. |
| `-a caesar\|columnar` | Algorithm, defaults to `caesar`. |
| `-k <key>` | Required. Caesar: a positive integer shift. Columnar: a string whose length is the column count. |
| `-o <path>` | Optional. Write output to a file instead of stdout (creates the file if missing). |
| Last argument | A quoted string, or a file path to read as input. |

For columnar mode, spaces in the message are replaced with `_` before encryption so the transposition round-trips cleanly.

### `crack`

```text
crack -m bruteforce -a caesar "PHHW DW GDZQ"
crack -m statistics -a caesar "PHHW DW GDZQ"
crack -m key -a columnar "encrypted text here"
crack -m bruteforce -a columnar "encrypted text here"
```

| Mode | Caesar | Columnar |
| --- | --- | --- |
| `bruteforce` | Prints all 26 shift attempts. | Prints every candidate key length's grid layout. |
| `statistics` | Frequency analysis, guesses shift assuming `E` is the most common letter. | Not available. |
| `key` | Not available. | Lists candidate key lengths (divisors of the message length). |

`crack` cannot recover a `columnar` key string directly — it narrows down key *length* by factoring the message length, then a player reconstructs the grid from the `bruteforce` layout output. This makes columnar puzzles naturally harder than caesar puzzles, which `crack -m statistics` can often solve outright on real English text.

These commands are useful for puzzle laptops and intelligence workflows. Install only on laptops meant to provide those tools — see [Encryption and Security](../Systems/Encryption-and-Security.md) for mission design guidance.

## Games

| Command | Path | Purpose |
| --- | --- | --- |
| `snake` | `/games/snake` | Starts the Snake game. |

`snake` is interactive and is not SSH-compatible.

## SSH Compatibility

Some commands can run through SSH sessions. Interactive or graphical commands are blocked over SSH when their config marks `sshCompatible = 0`.

Known blocked commands:

| Command | Reason |
| --- | --- |
| `ssh` | Nested SSH is blocked. |
| `snake` | Interactive game. |

When writing custom commands, avoid opening displays or requiring local-only UI if the command might run during SSH. If your addon defines config commands, mark interactive commands as not SSH-compatible.

## Custom Runtime Command Example

```sqf
[
    _laptop,
    "relay",
    "/bin/relay",
    {
        params ["_computer", "_options", "_commandName"];
        private _mode = _options param [0, "status"];

        switch (_mode) do {
            case "open": {
                missionNamespace setVariable ["myMission_relayOpen", true, true];
                [_computer, "Relay opened."] call AE3_armaos_fnc_shell_stdout;
            };
            case "close": {
                missionNamespace setVariable ["myMission_relayOpen", false, true];
                [_computer, "Relay closed."] call AE3_armaos_fnc_shell_stdout;
            };
            default {
                private _state = ["closed", "open"] select (missionNamespace getVariable ["myMission_relayOpen", false]);
                [_computer, format ["Relay is %1.", _state]] call AE3_armaos_fnc_shell_stdout;
            };
        };
    },
    "Control relay",
    "relay [status|open|close]"
] call AE3_armaos_fnc_computer_addCustomCommand;
```

## Config Command Shape

Addon-provided terminal commands are defined in config using `CfgOsFunctions`, `CfgSecurityCommands`, or `CfgGames` style classes.

```cpp
class CfgOsFunctions
{
    class myCommand
    {
        path = "/bin/myCommand";
        description = "Runs my command.";
        man = "myCommand: detailed help text.";
        code = "call myTag_fnc_myCommand";
        sshCompatible = 1;
    };
};
```

The target function receives the normal command arguments used by AE3 shell execution.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| `help` does not list a command | The command was not installed on that laptop. |
| Command file exists but cannot run | Execute permission may be missing. |
| Command prints nothing | Use `AE3_armaos_fnc_shell_stdout`; do not use `hint` for terminal output. |
| Command works locally but not over SSH | It may be blocked by `sshCompatible = 0`, route policy, credentials, or power state. |
| Custom command fails during mission start | Wait until the laptop filesystem exists before adding the command. |
