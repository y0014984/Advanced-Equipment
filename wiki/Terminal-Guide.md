# ArmaOS Terminal Guide

This guide covers the ArmaOS terminal interface, built-in OS commands, customization options, and how to extend the system with custom commands.

## Table of Contents

1. [Terminal Interface](#terminal-interface)
2. [Basic Navigation](#basic-navigation)
3. [File System Commands](#file-system-commands)
4. [Device Control Commands](#device-control-commands)
5. [Network Commands](#network-commands)
6. [Security Commands](#security-commands)
7. [System Commands](#system-commands)
8. [Terminal Customization](#terminal-customization)
9. [Command History](#command-history)
10. [Adding Custom Commands](#adding-custom-commands)

---

## Terminal Interface

### Opening a Terminal

1. Interact with a laptop using ACE interact menu
2. Select "Equipment" > "Turn On"
3. Select "Equipment" > "Open Laptop"
4. Terminal interface will appear

### Terminal Layout

```
┌─────────────────────────────────────────────────┐
│ ArmaOS Terminal                    [Language][Design] │
│                                                 │
│ admin@armaOS:/>                                │
│                                                 │
│ (terminal output appears here)                 │
│                                                 │
│                                                 │
│                                                 │
│                                                 │
│                                                 │
│                                                 │
│ admin@armaOS:/> _                              │
└─────────────────────────────────────────────────┘
```

### Keyboard Shortcuts

- **Enter** - Execute command
- **Up/Down Arrow** - Navigate command history
- **Page Up/Page Down** - Scroll terminal output
- **Ctrl + Plus/Minus** - Adjust font size
- **Tab** - Autocomplete (if enabled)
- **ESC** - Close terminal

---

## Basic Navigation

### Login

First time accessing a computer, you'll see the login prompt:

```
armaOS login: admin
Password: ********

Welcome to ArmaOS
admin@armaOS:/>
```

**Default Credentials:**
- Username: `admin`
- Password: `admin`

Mission makers can add additional users with different credentials.

### Understanding the Prompt

```
admin@armaOS:/home/user>
│     │        │        │
│     │        │        └── Current directory
│     │        └─────────── Hostname
│     └──────────────────── Username
└────────────────────────── Prompt indicator
```

### Special Path Characters

- `/` - Root directory
- `~` - Home directory (e.g., `/home/admin`)
- `.` - Current directory
- `..` - Parent directory

---

## File System Commands

### ls - List Directory Contents

Lists files and directories in the current or specified directory.

**Syntax:**
```bash
ls [-l] [PATH]
```

**Options:**
- `-l` - Long format (shows permissions and owner)

**Examples:**
```bash
ls                  # List current directory
ls /home            # List /home directory
ls -l               # Detailed listing
ls -l /tmp          # Detailed listing of /tmp
```

**Output:**
```
# Standard format
documents
file.txt
scripts

# Long format (-l)
drwxr--r--  admin  documents
-rw-r--r--  admin  file.txt
-rwxr-xr-x  root   scripts
```

**Permission Format:**
```
drwxrwxrwx
││││││││││
│└┴┴┴┴┴┴┴┴─── Permissions
└──────────── Type (d=directory, -=file)

First three: Owner permissions (x=execute, r=read, w=write)
Last three:  Everyone permissions (x=execute, r=read, w=write)
```

---

### cd - Change Directory

Changes the current working directory.

**Syntax:**
```bash
cd [PATH]
```

**Examples:**
```bash
cd /home            # Go to /home
cd ..               # Go to parent directory
cd ../admin         # Go to sibling directory
cd ~                # Go to home directory
cd ~/documents      # Go to documents in home
```

---

### pwd - Print Working Directory

Displays the current directory path (not a standalone command, shown in prompt).

---

### cat - Display File Contents

Displays the contents of a file.

**Syntax:**
```bash
cat FILE
```

**Examples:**
```bash
cat readme.txt
cat /etc/config
cat ~/notes.txt
```

---

### mkdir - Create Directory

Creates a new directory.

**Syntax:**
```bash
mkdir PATH
```

**Examples:**
```bash
mkdir logs
mkdir /tmp/data
mkdir ~/projects
```

**Notes:**
- Requires write permission on parent directory
- Cannot create if directory already exists

---

### touch - Create File

Creates a new empty file or file with content.

**Syntax:**
```bash
touch FILE [CONTENT]
```

**Examples:**
```bash
touch file.txt
touch notes.txt "This is my note"
touch /tmp/data.txt "Important data"
```

---

### rm - Remove File/Directory

Deletes a file or directory.

**Syntax:**
```bash
rm PATH
```

**Examples:**
```bash
rm file.txt
rm /tmp/oldfile
rm ~/documents/draft.txt
```

**Notes:**
- Requires write permission on the object
- No confirmation prompt - deletion is immediate

---

### mv - Move/Rename File

Moves or renames a file or directory.

**Syntax:**
```bash
mv SOURCE TARGET
```

**Examples:**
```bash
mv old.txt new.txt          # Rename file
mv file.txt /tmp/           # Move to /tmp
mv /home/user/file /tmp/    # Move with absolute paths
```

---

### cp - Copy File

Copies a file or directory.

**Syntax:**
```bash
cp SOURCE TARGET
```

**Examples:**
```bash
cp file.txt backup.txt      # Copy file
cp data.txt /tmp/           # Copy to /tmp
```

**Notes:**
- Requires read permission on source
- Requires write permission on target directory

---

### chown - Change Owner

Changes the owner of a file or directory.

**Syntax:**
```bash
chown [-r] OWNER PATH
```

**Options:**
- `-r` - Recursive (apply to directory contents)

**Examples:**
```bash
chown admin file.txt
chown -r admin /home/user
chown root /etc/config
```

**Notes:**
- Only owner or root can change ownership
- Recursive option applies to all files/subdirectories

---

### find - Find Files

Searches for files by name.

**Syntax:**
```bash
find FILENAME
```

**Examples:**
```bash
find config.txt
find password.txt
```

**Output:**
```
/etc/config.txt
/home/admin/config.txt
2 files found
Permission denied for 3 directories
```

---

## Device Control Commands

### devices - List Hackable Devices

Lists all devices accessible from the current computer.

**Syntax:**
```bash
devices
```

**Example Output:**
```
Name             Type        Status      IP Address
------------------------------------------------
main_door        Door        Locked      192.168.1.10
office_light     Light       Off         192.168.1.11
patrol_vehicle   Vehicle     Locked      192.168.1.12
```

**Notes:**
- Only shows devices on the same network
- Requires network connection to see devices

---

### door - Control Doors

Controls door locks and positions.

**Syntax:**
```bash
door -n NAME [-o|-c|-l|-u]
```

**Options:**
- `-n NAME` - Door name (required)
- `-o` - Open door
- `-c` - Close door
- `-l` - Lock door
- `-u` - Unlock door

**Examples:**
```bash
door -n main_door -o        # Open main door
door -n back_door -u        # Unlock back door
door -n vault_door -l       # Lock vault door
```

**Power Cost:** Configurable via CBA settings (default: varies by action)

---

### light - Control Lights

Controls light switches.

**Syntax:**
```bash
light -n NAME [-o|-c]
```

**Options:**
- `-n NAME` - Light name (required)
- `-o` - Turn light on
- `-c` - Turn light off

**Examples:**
```bash
light -n office_light -o    # Turn on office light
light -n hallway -c         # Turn off hallway light
```

**Power Cost:** Lights consume power when on

---

### vehicle - Control Vehicles

Controls vehicle systems.

**Syntax:**
```bash
vehicle -n NAME -a ACTION
```

**Options:**
- `-n NAME` - Vehicle name (required)
- `-a ACTION` - Action to perform:
  - `engine_on` - Start engine
  - `engine_off` - Stop engine
  - `lights_on` - Turn on lights
  - `lights_off` - Turn off lights
  - `lock` - Lock vehicle
  - `unlock` - Unlock vehicle

**Examples:**
```bash
vehicle -n patrol_car -a unlock
vehicle -n humvee -a engine_on
vehicle -n truck -a lights_on
```

---

## Network Commands

### ipconfig - Show Network Configuration

Displays the computer's network configuration.

**Syntax:**
```bash
ipconfig
```

**Example Output:**
```
IP Address: 192.168.1.10
Router: 192.168.1.1
Connected: Yes
```

---

### ping - Test Network Connectivity

Tests network connectivity to an IP address.

**Syntax:**
```bash
ping IP_ADDRESS
```

**Examples:**
```bash
ping 192.168.1.1        # Ping router
ping 192.168.1.10       # Ping device
```

**Output:**
```
Pinging 192.168.1.10...
Reply from 192.168.1.10: Connected
```

---

### lsusb - List USB Devices

Lists USB flash drives connected to the computer.

**Syntax:**
```bash
lsusb
```

**Example Output:**
```
Interface    Device          Mounted
----------------------------------------
usb0         FlashDrive_01   No
usb1         (empty)         -
```

---

### mount - Mount USB Drive

Mounts a USB flash drive to `/mnt/<interface>`.

**Syntax:**
```bash
mount INTERFACE
```

**Examples:**
```bash
mount usb0              # Mount drive on usb0 to /mnt/usb0
```

**Notes:**
- Drive must be physically connected (via ACE interaction)
- Creates mount point at `/mnt/<interface>`
- Drive files become accessible after mounting

---

### unmount - Unmount USB Drive

Safely unmounts a USB flash drive.

**Syntax:**
```bash
unmount INTERFACE
```

**Examples:**
```bash
unmount usb0            # Unmount drive from usb0
```

**Notes:**
- Saves filesystem changes back to drive
- Drive can be safely disconnected after unmounting

---

## Security Commands

**Note:** Security commands must be added to computers via Zeus modules or scripting.

### crypto - Encrypt/Decrypt Messages

Encrypts or decrypts messages using various algorithms.

**Syntax:**
```bash
crypto -a ALGORITHM -m MODE -k KEY MESSAGE
```

**Parameters:**
- `-a ALGORITHM` - Encryption algorithm (`caesar` or `columnar`)
- `-m MODE` - Operation mode (`encrypt` or `decrypt`)
- `-k KEY` - Encryption key
- `MESSAGE` - Text to encrypt/decrypt

**Caesar Cipher:**
```bash
crypto -a caesar -m encrypt -k 3 HELLO WORLD
# Output: KHOOR ZRUOG

crypto -a caesar -m decrypt -k 3 KHOOR ZRUOG
# Output: HELLO WORLD
```

**Caesar Notes:**
- Shifts each letter by KEY positions in alphabet
- Only supports uppercase Latin alphabet A-Z
- Spaces preserved, other characters removed
- Key range: 1-26 (higher numbers wrap around)

**Columnar Transposition:**
```bash
crypto -a columnar -m encrypt -k ARMA TheEnemyWillAttackAt0600h
# Output: TnWAc0hEylat0_emltA0_heitk6_

crypto -a columnar -m decrypt -k ARMA TnWAc0hEylat0_emltA0_heitk6_
# Output: TheEnemyWillAttackAt0600h___
```

**Columnar Notes:**
- Transposes text based on keyword
- Supports UTF-8 characters (decimal 33-126)
- Message length padded to fit columns
- More secure than Caesar cipher

---

### crack - Crack Encrypted Messages

Attempts to crack encrypted messages using various methods.

**Syntax:**
```bash
crack -a ALGORITHM -m MODE MESSAGE
```

**Parameters:**
- `-a ALGORITHM` - Encryption algorithm (`caesar` or `columnar`)
- `-m MODE` - Cracking mode (`bruteforce`, `statistics`, or `key`)

**Caesar Bruteforce:**
```bash
crack -a caesar -m bruteforce WKLV LV PB VHFUHW PHVVDJH
# Output: All 26 possible decryptions
# Test 1: VJKU KU OA UGETGV OGUUCIG
# Test 2: UIJT JT NZ TFDSFU NFTTBHF
# Test 3: THIS IS MY SECRET MESSAGE  <-- Correct
# ...
```

**Caesar Statistics:**
```bash
crack -a caesar -m statistics WKLV LV PB VHFUHW PHVVDJH
# Output: Character frequency analysis
# Character 'V' found 5 times (Possible key, if this is an 'E': 17)
# Character 'H' found 4 times (Possible key, if this is an 'E': 3)
# ...
```

**Columnar Key:**
```bash
crack -a columnar -m key TnWAc0hEylat0_emltA0_heitk6_
# Output: Possible Key-Lengths are:
# 2
# 4
# 7
# 14
```

**Columnar Bruteforce:**
```bash
crack -a columnar -m bruteforce TnWAc0hEylat0_emltA0_heitk6_
# Output: Shows column arrangements for each possible key length
# You must manually form words from columns
```

---

## System Commands

### help - Show Available Commands

Lists all available commands.

**Syntax:**
```bash
help
```

**Example Output:**
```
Available commands:
cat      - Display file contents
cd       - Change directory
ls       - List directory contents
...
```

---

### man - Show Command Manual

Displays detailed help for a specific command.

**Syntax:**
```bash
man COMMAND
```

**Examples:**
```bash
man ls
man crypto
man door
```

---

### history - Show Command History

Displays command history for the current user.

**Syntax:**
```bash
history
```

**Example Output:**
```
1: ls -l
2: cd /tmp
3: cat readme.txt
4: devices
```

**Notes:**
- History is per-user
- Persists across sessions
- Can recall with Up/Down arrows

---

### whoami - Show Current User

Displays the currently logged in username.

**Syntax:**
```bash
whoami
```

**Example Output:**
```
admin
```

---

### clear - Clear Terminal

Clears the terminal screen.

**Syntax:**
```bash
clear
```

---

### echo - Print Text

Prints text to the terminal.

**Syntax:**
```bash
echo TEXT
```

**Examples:**
```bash
echo Hello World
echo "This is a test"
```

---

### date - Show Current Date/Time

Displays current in-game date and time.

**Syntax:**
```bash
date
```

**Example Output:**
```
2025-11-11 14:30:45
```

---

### exit - Exit Terminal

Logs out of the current session.

**Syntax:**
```bash
exit
```

**Notes:**
- Returns to login screen
- Terminal state preserved

---

### shutdown - Shut Down Computer

Shuts down the computer.

**Syntax:**
```bash
shutdown
```

**Notes:**
- Closes terminal
- Computer must be turned back on to use again

---

### standby - Enter Standby Mode

Puts the computer into standby mode.

**Syntax:**
```bash
standby
```

**Notes:**
- Faster wake-up than full shutdown
- Preserves terminal state
- Lower power consumption than full operation

---

## Terminal Customization

### Keyboard Layouts

Change keyboard layout via the Language button or CBA settings.

**Supported Layouts:**
- **US** - United States (English)
- **DE** - Deutschland (German)
- **FR** - France (French)
- **IT** - Italia (Italian)
- **RU** - Русский (Russian)
- **AR** - Arabic
- **HE** - Hebrew
- **HU** - Magyarország (Hungarian)
- **TR** - Türkiye (Turkish)

**To Change:**
1. Click the language button in top-right corner of terminal
2. Or modify `AE3_KeyboardLayout` in CBA settings

---

### Terminal Themes

Four retro terminal themes available via the Design button or CBA settings.

**Available Themes:**

1. **ArmaOS** (Default)
   - Modern green-on-black terminal
   - Cyberpunk aesthetic

2. **C64**
   - Commodore 64 blue-on-blue theme
   - Retro 1980s feel

3. **Apple II**
   - Green-on-black like classic Apple II
   - Vintage computing nostalgia

4. **Amber**
   - Amber monochrome monitor theme
   - 1970s terminal look

**To Change:**
1. Click the design button in top-right corner of terminal
2. Or modify `AE3_TerminalDesign` in CBA settings

---

### Font Size

Adjust terminal font size for readability.

**To Change:**
- **Ctrl + Plus** - Increase font size
- **Ctrl + Minus** - Decrease font size
- Or modify `AE3_TerminalDefaultSize` in CBA settings (0.5-1.0)

---

### Scroll Speed

Configure how fast the terminal scrolls with Page Up/Down.

**CBA Setting:** `AE3_TerminalScrollSpeed`
- **1 line** - Precise scrolling
- **2 lines** - Default
- **3 lines** - Fast scrolling

---

## Command History

### Navigating History

- **Up Arrow** - Previous command in history
- **Down Arrow** - Next command in history
- Press **Enter** to execute recalled command

### History Persistence

- Command history is saved per-user
- Persists across terminal sessions
- View full history with `history` command

### History Storage

History is stored in the terminal hashmap:

```sqf
_terminal get "AE3_terminalCommandHistory"  // Hashmap of user -> commands array
```

---

## Adding Custom Commands

Developers can add custom commands to computers dynamically or via config.

### Dynamic Custom Commands

Add commands at runtime using the API:

```sqf
[_computer, "nano", "/bin/nano", {
    params ["_computer", "_options", "_commandName"];

    [_computer, "Nano Text Editor v1.0"] call AE3_armaos_fnc_shell_stdout;
    [_computer, "Usage: nano [filename]"] call AE3_armaos_fnc_shell_stdout;

}, "Simple text editor", "Nano is a simple text editor"] call AE3_armaos_fnc_computer_addCustomCommand;
```

### Custom Command with User Input

```sqf
[_computer, "survey", "/usr/bin/survey", {
    params ["_computer", "_options", "_commandName"];

    [_computer, "What is your name?"] call AE3_armaos_fnc_shell_stdout;
    private _name = [_computer] call AE3_armaos_fnc_shell_stdin;

    [_computer, format ["Hello, %1!", _name]] call AE3_armaos_fnc_shell_stdout;

}, "Interactive survey"] call AE3_armaos_fnc_computer_addCustomCommand;
```

### Custom Command with Options

```sqf
[_computer, "greet", "/bin/greet", {
    params ["_computer", "_options", "_commandName"];

    private _commandSettings = [
        "greet",
        [
            ["_greeting", "-g", "--greeting", "string", "Hello", false, "Greeting message"],
            ["_name", "-n", "--name", "string", "World", false, "Name to greet"]
        ],
        [[1, 0]]  // Syntax: requires 1 thing, 0 or more options
    ];

    private _ae3OptsSuccess = false;
    [] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

    if (_ae3OptsSuccess) then {
        [_computer, format ["%1, %2!", _greeting, _name]] call AE3_armaos_fnc_shell_stdout;
    };

}, "Greet someone", "Usage: greet [-g greeting] [-n name]"] call AE3_armaos_fnc_computer_addCustomCommand;
```

**Usage:**
```bash
greet                           # Output: Hello, World!
greet -n Alice                  # Output: Hello, Alice!
greet -g Hi -n Bob              # Output: Hi, Bob!
greet --greeting Hey --name Eve # Output: Hey, Eve!
```

### Config-Based Custom Commands

Add commands via config for persistence:

```cpp
// In CfgOsFunctions
class myCommand {
    path = "/usr/bin/mycommand";
    code = "params ['_computer', '_options', '_commandName']; [_computer, 'Hello!'] call AE3_armaos_fnc_shell_stdout;";
    description = "My custom command";
    manual = "Usage: mycommand\nDescription: Does something useful";
};
```

Then initialize with:

```sqf
[_computer, "CfgOsFunctions", ["myCommand"]] call AE3_armaos_fnc_link_init;
```

---

## Tips and Tricks

### Tab Completion

If autocomplete is enabled, press Tab to complete commands and paths.

### Relative vs Absolute Paths

```bash
# Absolute paths (start with /)
cd /home/admin
cat /tmp/file.txt

# Relative paths (from current directory)
cd documents        # Go to ./documents
cat ../file.txt     # Go up one level, then access file.txt
```

### Command Chaining

Commands are executed sequentially - you cannot chain commands with `&&` or `;` in ArmaOS.

### Permission Denied

If you get "Permission denied":
1. Check file permissions with `ls -l`
2. Ensure you have required permission (x, r, or w)
3. Try logging in as a different user
4. Or use `chown` as root to change ownership

### Network Troubleshooting

If devices don't appear:
1. Check network connection with `ipconfig`
2. Ping the router: `ping 192.168.1.1`
3. Ensure devices are on the same network
4. Verify router DHCP is configured

### Power Management

Monitor battery levels:
1. Check battery via ACE interaction menu
2. Power-intensive operations drain battery faster
3. Connect to generator or solar panel for continuous operation

---

## For Mission Makers

### Adding Users

```sqf
[_laptop, "admin", "admin123"] call AE3_armaos_fnc_computer_addUser;
[_laptop, "guest", ""] call AE3_armaos_fnc_computer_addUser;  // No password
```

### Adding Security Commands

```sqf
[_laptop, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;
// Adds crypto and crack commands
```

### Adding Games

```sqf
[_laptop, true] call AE3_armaos_fnc_computer_addGames;
// Adds snake game
```

### Initializing with Specific Commands

```sqf
[_laptop, ["ls", "cd", "cat", "devices"], true, false, []] call AE3_armaos_fnc_computer_initWithCommands;
// Basic commands + security, no games
```

---

For more information, see:
- [API Reference](API-Reference.md) - Complete function documentation
- [Architecture Guide](Architecture.md) - System architecture
- [ACE Mutex Guide](ACE-Mutex.md) - Concurrency handling
