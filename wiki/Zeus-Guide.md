# Zeus Guide

This guide covers all Zeus modules and interfaces available in the Advanced Equipment (AE3) framework. Zeus curators can use these tools during live missions to manage computers, filesystems, power, and network configurations without scripting.

---

## Table of Contents

- [Overview](#overview)
- [Zeus Modules](#zeus-modules)
  - [Add User Module](#add-user-module)
  - [Add File Module](#add-file-module)
  - [Add Directory Module](#add-directory-module)
  - [Add Games Module](#add-games-module)
  - [Add Security Commands Module](#add-security-commands-module)
  - [Add Connection Module](#add-connection-module)
- [Zeus Interfaces](#zeus-interfaces)
  - [Filesystem Browser](#filesystem-browser)
  - [Asset Attributes Interface](#asset-attributes-interface)
- [Common Workflows](#common-workflows)
- [Troubleshooting](#troubleshooting)

---

## Overview

AE3 provides Zeus curators with powerful tools to manage the cyber warfare system during gameplay. All modules are accessible through the Zeus interface and work on computers that have been initialized with filesystems.

**Important Notes:**
- Most modules require the target computer to have a filesystem initialized
- Modules are placed directly on objects (laptops, desks with laptops)
- The module will automatically delete after execution
- Feedback messages appear in the Zeus interface confirming success or errors

---

## Zeus Modules

### Add User Module

**Purpose:** Creates a new user account on a computer with a username and password.

**How to Use:**
1. Open Zeus interface (Y key by default)
2. Navigate to **AE3 Main Modules** category
3. Select **Add User** module
4. Place the module directly on a laptop or computer object
5. Fill in the module dialog:
   - **Username**: Account name (no spaces allowed)
   - **Password**: Account password
6. Click **OK** to create the user

**Parameters:**
- **Username** (Required): User account name. Cannot contain spaces.
- **Password** (Required): User password for login.

**What It Does:**
- Creates a user account in the computer's userlist
- Automatically creates a home directory at `/home/<username>` (except for root user)
- Sets proper ownership and permissions for the home directory

**Example Use Cases:**
- Creating player accounts for mission objectives
- Setting up multiple users with different access levels
- Adding temporary guest accounts

**Troubleshooting:**
- **"Username Missing" or "Password Missing"**: Fill in both required fields
- **"Username contains spaces"**: Remove spaces from the username
- **"Filesystem not ready"**: Wait a few seconds and try again. The computer may still be initializing.

---

### Add File Module

**Purpose:** Creates a new file on the computer's filesystem with content, permissions, and optional encryption.

**How to Use:**
1. Open Zeus interface
2. Navigate to **AE3 Main Modules** category
3. Select **Add File** module
4. Place the module on a laptop/computer
5. Fill in the module dialog:
   - **Path**: Full file path (e.g., `/tmp/intel.txt` or `/home/admin/secret.txt`)
   - **Content**: File contents (plain text or code)
   - **Is Code**: Check if content should be compiled as SQF code
   - **Owner**: Username who owns the file
   - **Owner Permissions**: Execute, Read, Write checkboxes for owner
   - **Everyone Permissions**: Execute, Read, Write checkboxes for all users
   - **Enable Encryption**: Check to encrypt the file
   - **Encryption Algorithm**: Caesar or Columnar
   - **Encryption Key**: Key for encryption/decryption
6. Click **OK** to create the file

**Parameters:**
- **Path** (Required): Absolute file path. Cannot contain spaces. Must include filename.
- **Content**: File contents as text. Can be empty.
- **Is Code**: If checked, content will be compiled as executable SQF code.
- **Owner** (Required): Username who owns the file. Cannot contain spaces.
- **Owner Permissions**:
  - **Execute**: Owner can run the file as a program
  - **Read**: Owner can read file contents
  - **Write**: Owner can modify/delete the file
- **Everyone Permissions**: Same as owner but applies to all users
- **Enable Encryption**: Encrypt file contents
- **Encryption Algorithm**:
  - **Caesar**: Simple shift cipher (key must be number 1-25)
  - **Columnar**: Transposition cipher (key is any string, min length 2)
- **Encryption Key** (Required if encryption enabled): Key for encryption

**Common Permission Patterns:**
```
Public readable text file:
Owner: [Execute: NO, Read: YES, Write: YES]
Everyone: [Execute: NO, Read: YES, Write: NO]

Private executable:
Owner: [Execute: YES, Read: YES, Write: NO]
Everyone: [Execute: NO, Read: NO, Write: NO]

Shared document:
Owner: [Execute: NO, Read: YES, Write: YES]
Everyone: [Execute: NO, Read: YES, Write: YES]
```

**Example Use Cases:**
- Creating mission-critical intelligence files with encryption
- Adding executable scripts players must find and run
- Setting up readme files with mission hints
- Creating decoy or dummy files

**Troubleshooting:**
- **"Path Missing" or "Owner Missing"**: Fill in required fields
- **"Path contains spaces"**: Use underscores or hyphens instead of spaces
- **"Key Missing"**: Provide an encryption key if encryption is enabled
- **"File already exists"**: File was already created. Use Filesystem Browser to delete or rename it first.

---

### Add Directory Module

**Purpose:** Creates a new directory (folder) on the computer's filesystem with owner and permissions.

**How to Use:**
1. Open Zeus interface
2. Navigate to **AE3 Main Modules** category
3. Select **Add Directory** module
4. Place the module on a laptop/computer
5. Fill in the module dialog:
   - **Path**: Full directory path (e.g., `/tmp/mission` or `/home/admin/intel`)
   - **Owner**: Username who owns the directory
   - **Owner Permissions**: Execute, Read, Write checkboxes for owner
   - **Everyone Permissions**: Execute, Read, Write checkboxes for all users
6. Click **OK** to create the directory

**Parameters:**
- **Path** (Required): Absolute directory path. Cannot contain spaces.
- **Owner** (Required): Username who owns the directory.
- **Owner/Everyone Permissions**: Same as Add File module

**Directory Permission Meanings:**
- **Execute**: Allows entering the directory (required to access contents)
- **Read**: Allows listing directory contents with `ls`
- **Write**: Allows creating/deleting files within the directory

**Example Use Cases:**
- Creating mission-specific folder structures
- Setting up restricted directories for specific users
- Organizing files for hacking challenges

**Troubleshooting:**
- Same as Add File module
- **Note**: Parent directories must exist first (e.g., create `/tmp` before `/tmp/mission`)

---

### Add Games Module

**Purpose:** Adds game programs to the computer (currently: Snake game).

**How to Use:**
1. Open Zeus interface
2. Navigate to **AE3 Main Modules** category
3. Select **Add Games** module
4. Place the module on a laptop/computer
5. Check **Snake** to install the Snake game
6. Click **OK**

**Parameters:**
- **Snake**: Install the Snake game program

**What It Does:**
- Installs the Snake game executable in `/usr/games/snake`
- Adds the `snake` command to the terminal
- Players can run `snake` in the terminal to play

**Example Use Cases:**
- Adding entertainment to downtime during missions
- Creating Easter eggs for players to discover
- Testing terminal functionality

**Game Controls (Snake):**
- Arrow keys to move
- Collect items to grow
- Avoid hitting walls or yourself

---

### Add Security Commands Module

**Purpose:** Adds security/hacking tools to the computer (crypto and crack commands).

**How to Use:**
1. Open Zeus interface
2. Navigate to **AE3 Main Modules** category
3. Select **Add Security Commands** module
4. Place the module on a laptop/computer
5. Check the tools to install:
   - **Crypto**: Encryption/decryption tool
   - **Crack**: Password cracking tool
6. Click **OK**

**Parameters:**
- **Crypto**: Install the `crypto` command for encrypting/decrypting files
- **Crack**: Install the `crack` command for password cracking

**What They Do:**

**Crypto Command:**
- Encrypts or decrypts file contents
- Supports Caesar and Columnar ciphers
- Usage: `crypto <mode> <algorithm> <key> <input_file> <output_file>`
  - Mode: `encrypt` or `decrypt`
  - Algorithm: `caesar` or `columnar`
  - Key: Encryption key
  - Input file: Source file path
  - Output file: Destination file path

**Crack Command:**
- Attempts to crack encrypted files using brute force
- Usage: `crack <algorithm> <input_file>`
  - Algorithm: `caesar` or `columnar`
  - Input file: Encrypted file to crack

**Example Use Cases:**
- Setting up hacking challenges for players
- Creating cyber warfare scenarios
- Allowing players to encrypt sensitive data
- Password cracking missions

---

## Zeus Interfaces

### Filesystem Browser

**Purpose:** Graphical interface for browsing and managing a computer's filesystem. Allows creating, editing, renaming, moving, and deleting files and folders.

**How to Access:**
1. Open Zeus interface
2. Right-click on a laptop/computer object
3. Select **Attributes** from the context menu
4. Click the **Filesystem Browser** button in the attributes panel

**Features:**

**Navigation:**
- **Tree View (Left)**: Hierarchical folder structure
- **File List (Right)**: Contents of selected directory
- **Go Back Button**: Navigate to parent directory
- **Path Display**: Shows current directory path

**Creating Files/Folders:**
- **New File Button**: Creates a new file in current directory
  - Enter filename, content, owner, and permissions
- **New Folder Button**: Creates a new folder in current directory
  - Enter folder name, owner, and permissions

**Editing Files:**
- **Double-click** a file in the list to open the edit dialog
- Modify content, permissions, or ownership
- Click **Apply Changes** to save

**File Operations:**
- **Rename**: Change file/folder name
- **Move**: Relocate file/folder to different directory
- **Delete**: Remove file/folder (confirmation required)

**Example Workflow:**
1. Open Filesystem Browser on a laptop
2. Navigate to `/home/admin/`
3. Click **New File**
4. Create `mission_briefing.txt` with mission details
5. Set permissions: Owner Read/Write, Everyone Read
6. Click **OK**
7. Players can now read the file with `cat /home/admin/mission_briefing.txt`

**Troubleshooting:**
- **"No Filesystem"**: Object doesn't have an AE3 filesystem. Only works on laptops and computers.
- **Changes not appearing**: Close and reopen the browser to refresh
- **Permission denied**: Ensure you're editing as the correct user or as root

---

### Asset Attributes Interface

**Purpose:** Displays real-time information about AE3 devices and provides quick control buttons.

**How to Access:**
1. Open Zeus interface
2. Right-click on any AE3 device (laptop, generator, battery, etc.)
3. Select **Attributes** from context menu

**Information Displayed:**
- **Class Name**: Object's config class
- **Power State**: Current power state (On, Off, Standby, No Power, Charging)
- **Power Output**: Current power generation (for generators/solar panels)
- **Power Required**: Power consumption rate
- **IP Address**: Network IP address (if connected to network)
- **Battery Level**: Battery charge percentage (if has battery)
- **Fuel Level**: Fuel percentage (if has fuel tank)

**Control Buttons:**

**Turn On Button:**
- Powers on the device
- Only enabled when device is off or in standby
- Requires power source or battery charge

**Turn Off Button:**
- Powers off the device
- Only enabled when device is on
- Saves battery life

**Standby Button:**
- Puts device in low-power standby mode
- Faster to wake up than full power on
- Reduces power consumption

**Open Button (Laptops):**
- Opens the laptop lid (visual animation)
- Required before using the laptop

**Close Button (Laptops):**
- Closes the laptop lid (visual animation)

**Battery/Fuel Sliders:**
- **Battery Level**: Adjust battery charge (Zeus only, for testing)
- **Fuel Level**: Adjust fuel level (Zeus only, for testing)
- Useful for simulating low power scenarios

**Auto-Updating Display:**
- Information updates every second automatically
- Real-time monitoring of device status

**Example Use Cases:**
- Quickly checking if a laptop has power
- Viewing network topology via IP addresses
- Simulating battery drain during missions
- Emergency power control during gameplay
- Testing power grid setups

---

## Common Workflows

### Setting Up a New Laptop for Players

1. **Place the laptop** in the mission (done in Eden or via Zeus)
2. **Open Attributes** on the laptop
3. **Turn On** the laptop using the control button
4. **Place Add User module** on the laptop
   - Username: `player`
   - Password: `password123`
5. **Place Add File module** to create mission briefing
   - Path: `/home/player/briefing.txt`
   - Content: Mission details
   - Owner: `player`
   - Permissions: Owner R/W, Everyone Read
6. **(Optional) Add Security Commands** if players need hacking tools
7. **Test** by opening the laptop terminal and logging in

---

### Creating an Encrypted Intelligence File

1. **Open Attributes** on target laptop
2. **Place Add File module**
3. **Configure encryption**:
   - Path: `/tmp/classified.txt`
   - Content: Secret intelligence data
   - Owner: `root`
   - Permissions: Owner R/W, Everyone None (private)
   - Enable Encryption: YES
   - Algorithm: Columnar
   - Key: `SECRETKEY123`
4. **Place Add Security Commands module** on a different laptop (player's laptop)
   - Install Crypto and Crack
5. **Mission Objective**: Players must find the encrypted file, transfer it, and crack it

---

### Setting Up a Hacking Challenge

**Scenario:** Players must hack into an enemy computer to retrieve intel.

1. **Enemy Laptop Setup**:
   - Place Add User: `admin` / `admin123`
   - Place Add File: `/home/admin/intel.txt` with encrypted content
   - Place Add Security Commands: Add Crack tool (so players can decrypt)

2. **Player Laptop Setup**:
   - Place Add User: `player` / `player`
   - Place Add File: `/home/player/password_list.txt` (hints for passwords)

3. **Test the challenge**:
   - Players must discover the admin password
   - Login as admin
   - Use crack command to decrypt intel file
   - Read decrypted intel

---

### Managing Power During Missions

1. **Monitor Battery Levels**:
   - Right-click laptops → Attributes
   - Check Battery Level slider

2. **Simulate Power Outage**:
   - Open Attributes on generators
   - Click **Turn Off** button
   - Laptops on battery will continue running

3. **Emergency Power Restore**:
   - Adjust Fuel Level sliders on generators
   - Click **Turn On** button
   - Verify laptops reconnect

---

## Troubleshooting

### "Filesystem not ready. Please wait and try again."

**Cause:** The computer's filesystem hasn't finished initializing yet.

**Solution:**
- Wait 5-10 seconds and try again
- If persistent, check that the object is a valid AE3 computer
- Verify the laptop was properly initialized in mission setup

---

### Module Dialog Won't Open / Closes Immediately

**Cause:** Module was not placed on a valid computer object.

**Solution:**
- Ensure you're placing the module directly on a laptop object
- Check that the laptop has been initialized with an AE3 filesystem
- Try placing the module on a desk if the laptop is on a desk

---

### "Username contains spaces" / "Path contains spaces"

**Cause:** Unix-like filesystems don't allow spaces in usernames or paths.

**Solution:**
- Use underscores instead: `my_file.txt`
- Use hyphens: `my-file.txt`
- Use camelCase: `myFile.txt`

---

### Files/Folders Not Appearing in Terminal

**Cause:** Filesystem browser changes may not sync immediately, or permissions issue.

**Solution:**
- Have player close and reopen the terminal
- Use `ls -la` command to show all files including hidden ones
- Check file permissions in Filesystem Browser
- Verify owner matches the logged-in user

---

### Encrypted Files Won't Decrypt

**Cause:** Wrong encryption key or algorithm.

**Solution:**
- Verify the encryption algorithm (Caesar vs Columnar)
- Check the encryption key matches exactly (case-sensitive)
- For Caesar cipher, key must be a number between 1-25
- For Columnar cipher, key must be at least 2 characters

---

### Asset Attributes Shows "No Data"

**Cause:** Object is not an AE3 power device.

**Solution:**
- Only AE3-enabled devices show attributes
- Check that the object has AE3 power/network systems initialized
- Some objects (like desks) may have limited attributes

---

### Battery/Fuel Sliders Don't Work

**Cause:** Object doesn't have a battery or fuel tank.

**Solution:**
- Only objects with batteries (laptops, battery units) have battery sliders
- Only objects with fuel (generators) have fuel sliders
- Sliders are disabled (grayed out) if not applicable

---

## Advanced Tips

### Using Filesystem Browser Efficiently

- **Navigate via tree view** for quick access to deep folders
- **Double-click** to edit instead of right-click menu
- **Rename** files to organize better (e.g., prefix with numbers: `01_intro.txt`, `02_mission.txt`)
- **Create folder structures** before adding files via modules

### Testing Missions as Zeus

- Use **Standby** button instead of Turn Off to quickly pause computers
- **Adjust battery levels** to simulate mission time passage
- **Monitor IP addresses** to verify network connections
- **Use Filesystem Browser** to check player progress by reading their files

### Performance Considerations

- **Don't create too many files** on a single computer (>100 may slow down)
- **Use Filesystem Browser** for bulk operations instead of multiple modules
- **Delete unused files/folders** to keep filesystems clean
- **Turn off** unused laptops to save server performance

---

## Related Documentation

- [Eden Editor Guide](Eden-Editor-Guide.md) - Setup missions with AE3 modules
- [Terminal Guide](Terminal-Guide.md) - Player commands and usage
- [API Reference](API-Reference.md) - Scripting AE3 programmatically
- [Configuration](Configuration.md) - CBA settings for AE3

---

**Need More Help?**

Check the [Home](Home.md) page for additional resources and community links.
