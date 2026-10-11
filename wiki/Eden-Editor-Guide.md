# Eden Editor Guide

This guide explains how to configure AE3 in 3DEN without scripting. It covers placing objects, opening attributes, using modules, syncing modules, and creating power/network connections.

## Finding AE3 Objects

AE3 objects appear in editor asset categories added by the mod. The exact category names can vary with localization, but the objects include laptops, routers, generators, batteries, solar panels, lights, desks, and flash drives.

Common placed objects:

- AE3 laptop.
- AE3 router variants.
- Portable generators.
- Batteries.
- Solar panels.
- Portable lights.
- Flash drive objects.

## Opening Object Attributes

To configure an AE3 object:

1. Place the object.
2. Double-click it in the 3DEN viewport or entity list.
3. Scroll through the attributes window.
4. Look for AE3-specific fields mixed with the normal Arma attributes.
5. Change the values.
6. Confirm the attribute window.

Object attributes are best for settings that belong to that object: laptop interface mode, static IP, router wireless settings, initial fuel, initial battery level, and powered-on behavior.

## Laptop Attributes

AE3 laptops have object attributes for the computer itself.

Important fields:

- Power level: initial internal battery or power state value where available.
- Interface mode: controls whether players get CLI, GUI, both, or the default interface behavior.
- Static IP: optional fixed IP address for the laptop when connected to a router.
- Software-related attributes: command and laptop setup fields exposed by the laptop class.

Interface mode options:

- Default: use the mission/default setting.
- CLI: terminal command line only.
- GUI: graphical desktop only.
- Both: expose both interfaces.

Use laptop attributes when every player should see the same base behavior from mission start.

## Server Attributes

Headless servers are under **AE3 > Servers**. They have no screen or local interface and are used over the network (SSH). Fields: Hostname, SSH enabled, Requires external power (off = mains power), Static IP, Transfer speed, Powered On At Start, root/sudo settings. Content is added with the same modules as laptops. See [Laptops and Interfaces](Systems/Laptops-and-Interfaces.md#headless-servers).

## Router Attributes

Routers are configured by double-clicking the router object.

Router fields:

- Network Name (SSID): the name shown for the wireless network. Blank keeps the default object name.
- Default Gateway: optional address for the router. Blank keeps auto-assigned subnet behavior.
- Wifi Range (m): maximum distance for connections.
- Network Password: password required to connect. Blank means open network.
- Power level: initial internal battery/power value where available.
- Powered On At Start: starts the router automatically.
- Allow External SSH: allows ping/SSH from other gateways.
- External Allowed IPs: optional allow list for external sources. Blank allows any source when external access is enabled.
- Transfer speed (KB/s): network transfer speed for every device on this wifi network. `0` keeps the mission default.

For simple missions, set an SSID, optionally set a password, leave gateway blank, and turn on Powered On At Start.

## Power Device Attributes

Generators, batteries, and solar panels can expose attributes such as:

- Fuel level.
- Battery/power level.
- Powered-on-at-start behavior where supported.

Use these attributes to decide whether players can immediately use equipment or must restore power during the mission.

## 3DEN Connection Tools

AE3 adds custom editor connection types:

- `AE3: connect device to power source`
- `AE3: connect device to network router`

Use these from the 3DEN connection menu, similar to syncing or other editor connection workflows.

### Power Connection

Purpose: connect a powered consumer to a provider.

Typical pairs:

- Laptop to generator.
- Laptop to battery.
- Router to generator.
- Light to generator.
- Battery to solar panel when using a charging setup.

Workflow:

1. Select the connection tool `AE3: connect device to power source`.
2. Start the connection on the device that needs power.
3. End the connection on the generator, battery, or solar panel.
4. Preview the mission and verify the powered device can turn on.

### Network Connection

Purpose: connect a network device to a router.

Typical pairs:

- Laptop to router.
- Router to parent router.

Workflow:

1. Select the connection tool `AE3: connect device to network router`.
2. Start the connection on the laptop or child router.
3. End the connection on the router.
4. Preview the mission.
5. Check that the laptop can use network features when powered.

## Using AE3 Modules

Modules are used to add content or behavior to an object. Most laptop-content modules must be synced to one or more laptops.

General module workflow:

1. Place the target laptop.
2. Place the AE3 module.
3. Double-click the module.
4. Fill in the module fields.
5. Sync the module to the laptop.
6. Preview the mission.
7. Open the laptop as a player and verify the result.

If nothing happens, first check the sync line.

## Laptop Content Modules

These modules are used to populate laptop content.

### AE3: Add User

Adds a login user to a synced laptop.

Fields:

- Username.
- Password.

Sync target:

- AE3 laptop.

Use this before expecting players to log in with those credentials.

### AE3: Add Directory

Creates a folder on a synced laptop filesystem.

Fields:

- Path.
- Owner.
- Owner permissions.
- Everyone permissions.

Sync target:

- AE3 laptop.

Create folders before adding files inside them.

### AE3: Add File

*Virtual file size* (e.g. `750KB`, `50MB`, `1.5GB`) makes the file take that long to copy or download at the configured transfer speed (empty = real size). Works for any file type.

Creates a file on a synced laptop filesystem.

Fields:

- Path.
- Content.
- Is Code.
- Owner.
- Owner permissions.
- Everyone permissions.
- Is Encrypted.
- Encryption algorithm.
- Encryption key.

Sync target:

- AE3 laptop.

For normal mission notes, leave Is Code off. Use encryption only when players are expected to solve an encryption/security step.

### AE3: Add Calendar Event

Adds an event to the laptop Calendar app.

Fields:

- Date.
- Title.
- Location.
- Details.

Sync target:

- AE3 laptop.

Use calendar entries for appointments, meeting clues, deadlines, or schedule intel.

### AE3: Add Webpage

Adds a page to the desktop Browser app.

Fields:

- URL.
- Title.
- Content.

Sync target:

- AE3 laptop.

Use stable, simple URLs such as `intel.root/page` or `facility.local/status`.

### AE3: Add Browser History

Adds an entry to the laptop browser history.

Fields:

- URL.
- Time.

Sync target:

- AE3 laptop.

This does not create the page by itself. Add the webpage separately if players should be able to open it.

### AE3: Add Email

Adds an email to the laptop mail system.

Fields:

- From.
- To.
- Subject.
- Body.
- Received time.
- Create sender address.
- Create recipient address.

Sync target:

- AE3 laptop.

Use email for narrative clues, orders, identity hints, and social engineering gameplay.

### AE3: Add Media

Adds a media marker file to the laptop.

Fields:

- Source path.
- Media type: image, video, or audio.
- Laptop path.
- Path type: mission file or mod path.
- Try Web View for experimental image handling.

Sync target:

- AE3 laptop.

Use mission-file paths for media shipped with the mission. Use mod paths only when the file is provided by a loaded mod.

### AE3: Add Passworded File

Creates a locked file that requires a password.

Fields:

- Laptop path.
- Password.
- Content.
- Owner.

Sync target:

- AE3 laptop.

Players can open these through GUI prompts or terminal unlock behavior, depending on the laptop interface.

## Special Modules

### AE3: Save Laptop

Stores a server-side snapshot of a synced laptop into a named save slot.

Field:

- Save slot.

Sync target:

- AE3 laptop.

Use this for scenarios where Zeus or mission flow may need to preserve laptop state.

### AE3: Restore Laptop

Restores a laptop from a named save slot.

Field:

- Save slot.

Sync target:

- AE3 laptop.

Use this to replace a lost or disabled laptop with a saved state.

### AE3: Crash Device

Crashes synced AE3 laptops. A crashed laptop shows crash behavior and must be power-cycled to recover.

Sync target:

- AE3 laptop.

Use with triggers or Zeus for sabotage, failed hacking, or scripted incident moments.

### AE3: Network Speed

Sets the simulated network transfer speed (KB/s) used by SSH app transfers and Cyber Warfare downloads.

- Sync it to routers (whole wifi network), laptops/servers (whole device), or laptops/servers with *User accounts* filled (comma-separated account names; only those users).
- Priority: user > computer > wifi network > mission setting (*Transfer speed: network*).
- `0` removes the override.

Placed in Zeus onto a router or computer it opens a dialog for the same values.

## Module Syncing

To sync a module:

1. Select the module.
2. Use the standard 3DEN sync connection.
3. Drag the sync line to the target laptop or object.
4. Confirm the line remains visible.

Most AE3 content modules accept a laptop as the synced target. Some modules can be synced to multiple laptops when you want the same content on more than one device.

## Common Editor Recipes

### Laptop With Login and Browser Clue

1. Place a laptop.
2. Set Interface Mode to GUI or Both.
3. Place `AE3: Add User`.
4. Enter credentials.
5. Sync it to the laptop.
6. Place `AE3: Add Webpage`.
7. Fill URL, title, and content.
8. Sync it to the laptop.
9. Place `AE3: Add Browser History`.
10. Use the same URL.
11. Sync it to the laptop.
12. Preview and open the Browser app.

### Laptop With Terminal File Clue

1. Place a laptop.
2. Set Interface Mode to CLI or Both.
3. Add a user.
4. Place `AE3: Add Directory`.
5. Create the folder path.
6. Place `AE3: Add File`.
7. Put the file in that folder path.
8. Sync all modules to the laptop.
9. Preview and read the file through the terminal.

### Powered Network Laptop

1. Place a laptop.
2. Place a router.
3. Place a generator or battery.
4. Configure the router attributes.
5. Connect laptop to router with `AE3: connect device to network router`.
6. Connect laptop and router to a power source with `AE3: connect device to power source`.
7. Preview and verify power first, then network.

## Troubleshooting 3DEN Setup

- Module did nothing: check that it is synced to the laptop.
- File is missing: check that the folder path exists or add the folder first.
- Browser history opens nowhere: check that the matching webpage exists.
- Players cannot open GUI: check laptop Interface Mode and access restrictions.
- Players cannot use terminal: check laptop Interface Mode and installed commands.
- Network tools fail: check router power, router range, password, and connection line.
- Device will not turn on: check power source, connection direction, fuel, and battery level.
