# Eden Editor Guide

This guide covers how to use the Eden Editor (3DEN) to set up AE3 (Advanced Equipment) missions. Learn how to configure laptops, power grids, network topologies, and filesystems before mission start.

---

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [Connection Types](#connection-types)
  - [Power Connections](#power-connections)
  - [Network Connections](#network-connections)
- [Setting Up Computers](#setting-up-computers)
- [Setting Up Power Grids](#setting-up-power-grids)
- [Setting Up Networks](#setting-up-networks)
- [Best Practices](#best-practices)
- [Example Scenarios](#example-scenarios)
- [Troubleshooting](#troubleshooting)

---

## Overview

The Eden Editor allows you to set up complete AE3 systems before starting a mission. Unlike Zeus modules (which work during gameplay), Eden Editor configurations are applied when the mission loads.

**Key Capabilities:**
- Connect devices to power sources visually
- Create network topologies with routers
- Pre-configure filesystems and user accounts
- Set initial battery and fuel levels
- Design complex cyber warfare scenarios

**Important:** Most AE3 setup is done via scripting in Eden Editor's init fields or through Zeus during gameplay. Eden Editor primarily provides connection management.

---

## Getting Started

### Placing AE3 Objects

1. **Open Eden Editor** (Tools → Eden Editor from main menu)
2. **Create a new mission** or open an existing one
3. **Place AE3 objects** from the editor:
   - **Laptops**: Search for "Laptop" in object browser
   - **Generators**: Search for "Generator"
   - **Batteries**: Search for "Battery" (if custom AE3 batteries available)
   - **Routers**: Search for "Router" (if custom AE3 routers available)
   - **Solar Panels**: Search for "Solar" (if available)

**Note:** Many AE3 devices use vanilla Arma 3 objects enhanced with AE3 scripts. Look for objects with "AE3" in their names when available.

### Accessing AE3 Connections

AE3 provides two connection types in Eden Editor:

1. **Right-click** on an object in the editor
2. **Select "Connect"** from context menu
3. **Choose connection type**:
   - **AE3: connect device to power source**
   - **AE3: connect device to network router**
4. **Click the target object** to complete the connection

---

## Connection Types

### Power Connections

**Purpose:** Connect power-consuming devices (laptops, batteries) to power sources (generators, solar panels, batteries).

**How to Create:**
1. **Right-click** the power consumer (e.g., laptop)
2. Select **Connect → AE3: connect device to power source**
3. **Click** the power provider (e.g., generator)
4. **Connection line** appears in red color

**Connection Rules:**
- Laptops can connect to generators, solar panels, or batteries
- Batteries can connect to generators or solar panels (for charging)
- One device can connect to multiple power sources
- Connections are directional: consumer → provider

**Visual Indicators:**
- Red connection line in Eden Editor
- Line persists after mission start for visualization

**Example:**
```
Laptop → Generator (laptop powered by generator)
Battery → Solar Panel (battery charges from solar panel)
Laptop → Battery → Generator (laptop uses battery, battery charges from generator)
```

**Automatic Behavior:**
- When mission starts, connections are established automatically
- Power flows from provider to consumer
- Battery charge is managed automatically
- If generator runs out of fuel, batteries take over (if connected)

---

### Network Connections

**Purpose:** Connect devices to routers to create network topologies. Devices on the same network can communicate and hack each other.

**How to Create:**
1. **Right-click** the network device (e.g., laptop)
2. Select **Connect → AE3: connect device to network router**
3. **Click** the router
4. **Connection line** appears in cyan/teal color

**Connection Rules:**
- Laptops must connect to routers (not directly to each other)
- Routers can connect to other routers (creating multi-router networks)
- One device can only connect to one router
- Cyclic connections (router loops) are detected and prevented

**Visual Indicators:**
- Cyan/teal connection line in Eden Editor
- Line persists after mission start

**Example Topologies:**
```
Simple Network:
Laptop1 → Router ← Laptop2
(Laptop1 and Laptop2 can communicate)

Multi-Router Network:
Laptop1 → Router1 ← → Router2 ← Laptop2
(All devices on same network)

Isolated Networks:
Laptop1 → Router1
Laptop2 → Router2
(Laptop1 and Laptop2 CANNOT communicate - different networks)
```

**Automatic Behavior:**
- DHCP assigns IP addresses automatically
- IP addresses are allocated based on network topology
- Devices can ping and discover each other
- Hacking commands only work on devices within the same network

---

## Setting Up Computers

Eden Editor doesn't have dedicated AE3 computer configuration modules. Instead, use **init fields** to configure computers via scripting.

### Basic Computer Initialization

**Step 1:** Place a laptop in Eden Editor

**Step 2:** Right-click → Attributes → Init field

**Step 3:** Add initialization code:

```sqf
// Basic laptop initialization with user account
[this, "player", "password123"] call AE3_armaos_fnc_computer_addUser;
```

### Adding Files in Init Field

```sqf
// Add a mission briefing file
[
    this,
    "/home/player/briefing.txt",
    "Mission: Infiltrate the enemy base and retrieve intel.",
    false,  // not code
    "player",
    [[false,true,true],[false,true,false]]  // owner read/write, everyone read
] call AE3_filesystem_fnc_device_addFile;
```

### Adding Multiple Users

```sqf
// Add multiple users
[this, "admin", "admin123"] call AE3_armaos_fnc_computer_addUser;
[this, "guest", "guest"] call AE3_armaos_fnc_computer_addUser;
[this, "operator", "secure_pass"] call AE3_armaos_fnc_computer_addUser;
```

### Adding Security Commands

```sqf
// Add crypto and crack tools
[this, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;
```

### Adding Games

```sqf
// Add Snake game
[this, true] call AE3_armaos_fnc_computer_addGames;
```

### Complete Laptop Setup Example

```sqf
// Complete laptop configuration
private _laptop = this;

// Add users
[_laptop, "admin", "password123"] call AE3_armaos_fnc_computer_addUser;
[_laptop, "player", "guest"] call AE3_armaos_fnc_computer_addUser;

// Add mission files
[
    _laptop,
    "/home/admin/intel.txt",
    "TOP SECRET: Enemy coordinates...",
    false,
    "admin",
    [[false,true,true],[false,false,false]]  // private to admin
] call AE3_filesystem_fnc_device_addFile;

[
    _laptop,
    "/home/player/readme.txt",
    "Welcome! Type 'help' for available commands.",
    false,
    "player",
    [[false,true,true],[false,true,false]]  // player can edit, everyone can read
] call AE3_filesystem_fnc_device_addFile;

// Add security tools
[_laptop, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;
```

**Important:** Init code runs on mission start, so computers are ready when players access them.

---

## Setting Up Power Grids

### Simple Generator Setup

**Components Needed:**
- 1 Generator
- 1+ Laptops

**Steps:**
1. Place generator in Eden Editor
2. Place laptop(s) near generator
3. Create power connections: Laptop → Generator
4. **(Optional)** Set initial fuel level via init:
   ```sqf
   // Set generator to 50% fuel
   private _fuelLevel = 0.5;
   [this, _fuelLevel] call AE3_power_fnc_setFuelLevel;
   ```

**Result:** Laptops will have power as long as generator has fuel.

---

### Battery Backup System

**Components Needed:**
- 1 Generator
- 1 Battery
- 1+ Laptops

**Steps:**
1. Place all components
2. Create connections:
   - Battery → Generator (battery charges from generator)
   - Laptop → Battery (laptop draws from battery)
3. **(Optional)** Set initial battery level:
   ```sqf
   // Set battery to 75% charge
   [this, 0.75] call AE3_power_fnc_setBatteryLevel;
   ```

**Result:** Laptop uses battery power. Battery recharges from generator. If generator fails, laptop continues on battery until drained.

---

### Solar-Powered System

**Components Needed:**
- 1 Solar Panel
- 1 Battery (recommended)
- 1+ Laptops

**Steps:**
1. Place solar panel outdoors (sunlight access)
2. Place battery
3. Place laptop(s)
4. Create connections:
   - Battery → Solar Panel
   - Laptop → Battery

**Result:** Solar panel charges battery during daytime. Battery powers laptop. System is sustainable during day/night cycles.

---

### Complex Power Grid

**Components Needed:**
- Multiple Generators
- Multiple Batteries
- Multiple Laptops

**Steps:**
1. Place components in a logical layout
2. Create connection hierarchy:
   ```
   Generator1 → Battery1 → Laptop1
   Generator1 → Battery2 → Laptop2
   Generator2 → Battery2
   (Battery2 has redundant power from both generators)
   ```

**Result:** Redundant power sources for critical systems.

---

## Setting Up Networks

### Simple Local Network

**Components Needed:**
- 1 Router
- 2+ Laptops

**Steps:**
1. Place router in central location
2. Place laptops around router
3. Create network connections: Each Laptop → Router
4. Create power connections for all devices

**Result:** All laptops can communicate, ping each other, and access each other's systems (if permissions allow).

---

### Multi-Router Network

**Components Needed:**
- 2+ Routers
- Multiple Laptops

**Steps:**
1. Place routers
2. Connect routers to each other: Router1 ↔ Router2
3. Connect laptops to their nearest router
4. Create power connections

**Example:**
```
Building A:          Building B:
Laptop1 →            Laptop3 →
         Router1 ↔ Router2
Laptop2 →            Laptop4 →
```

**Result:** All laptops (1-4) are on the same network and can communicate across routers.

---

### Isolated Networks (Mission Security)

**Purpose:** Create separate networks that cannot communicate (e.g., player network vs enemy network).

**Components Needed:**
- 2 Routers
- Laptops for each network

**Steps:**
1. Place Router1 (Player Network)
2. Place Router2 (Enemy Network)
3. **DO NOT** connect Router1 to Router2
4. Connect player laptops to Router1
5. Connect enemy laptops to Router2

**Result:** Player laptops cannot directly hack enemy laptops (different networks). Players must physically access enemy laptops or breach the network.

---

## Best Practices

### Organization

- **Name your objects** in Eden Editor for easy identification
  - Right-click → Attributes → General → Name
  - Examples: "PlayerLaptop1", "MainGenerator", "EnemyRouter"
- **Use folders** to organize objects by function
  - Create folders: "Power Grid", "Player Equipment", "Enemy Network"
- **Color-code connections** mentally (red = power, cyan = network)

### Performance

- **Limit number of laptops** to 10-20 per mission (more may impact server performance)
- **Turn off unused laptops** by default (they auto-start otherwise)
  - Init field: `[this] call AE3_armaos_fnc_computer_turnOff;`
- **Use efficient network topologies** (avoid redundant router chains)

### Testing

- **Preview mission regularly** to test configurations
- **Use Zeus interface** during preview to adjust on-the-fly
- **Test all power connections** by checking Asset Attributes in Zeus
- **Test network connections** by using `ping` command from laptops

### Documentation

- **Add comments** in init fields to explain configurations
  ```sqf
  // Player starting laptop - has all basic tools
  [this, "player", "password"] call AE3_armaos_fnc_computer_addUser;
  ```
- **Document network topology** in mission briefing or separate file
- **Create mission notes** explaining power grid layout

---

## Example Scenarios

### Scenario 1: Intelligence Gathering Mission

**Setup:**
- **Player Laptop**: Fully equipped with security tools
- **Enemy Laptop**: Contains encrypted intel file
- **Network**: Both on same network (or players must physically access enemy laptop)
- **Power**: Both on independent power sources

**Eden Setup:**

```sqf
// Player Laptop Init:
[this, "player", "player"] call AE3_armaos_fnc_computer_addUser;
[this, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;  // crypto + crack

// Enemy Laptop Init:
[this, "admin", "SecurePass123"] call AE3_armaos_fnc_computer_addUser;
[
    this,
    "/home/admin/classified.txt",
    "Enemy base coordinates: 123456",
    false,
    "admin",
    [[false,true,true],[false,false,false]],  // private to admin
    true,  // encrypted
    "columnar",
    "SECRETKEY"
] call AE3_filesystem_fnc_device_addFile;
```

**Connections:**
- PlayerLaptop → PlayerRouter
- EnemyLaptop → PlayerRouter (same network for hacking)
- All devices → Generators

**Mission:** Players must crack the password, login as admin, decrypt the classified file.

---

### Scenario 2: Sabotage Mission

**Setup:**
- **Player Laptop**: Basic tools
- **Power Grid**: Enemy base powered by generators
- **Custom Command**: Players can disable generators via hacking

**Eden Setup:**

```sqf
// Generator Init (add custom hack command):
private _generator = this;
[
    _generator,
    "disable",
    "/bin/disable_generator",
    {
        params ["_computer", "_options", "_commandName"];
        // Turn off generator when command is executed
        private _generator = _computer;  // assuming laptop is the generator control terminal
        [_generator] call AE3_power_fnc_turnOff;
        ["Generator disabled!"] call AE3_armaos_fnc_shell_stdout;
    },
    "Disable the generator"
] call AE3_armaos_fnc_computer_addCustomCommand;
```

**Connections:**
- Control Terminal → Network
- All enemy systems → Generator (so disabling it cuts power)

**Mission:** Players infiltrate, hack control terminal, run `disable` command, causing blackout.

---

### Scenario 3: Network Infiltration

**Setup:**
- **Multiple Networks**: Player network, civilian network, enemy network
- **Objective**: Players must bridge networks to access enemy systems

**Eden Setup:**

```
Network Topology:
PlayerLaptop → PlayerRouter
CivilianServer → CivilianRouter
EnemyServer → EnemyRouter

(No connections between routers initially)
```

**Mission Mechanic:**
- Players must physically travel to civilian server location
- Access civilian server to install bridge software (custom command)
- Bridge creates connection: CivilianRouter ↔ EnemyRouter
- Now players can hack enemy systems remotely

**Implementation:**
Use scripting to dynamically create network connection when bridge is activated.

---

## Troubleshooting

### Connections Not Working After Mission Start

**Symptoms:**
- Laptops have no power despite connections
- Devices cannot ping each other despite network connections

**Solutions:**
- Verify connections are correct type (power vs network)
- Check connection direction (consumer → provider for power)
- Ensure all devices have power (generators have fuel, batteries are charged)
- Preview mission and check Asset Attributes in Zeus

### Objects Not Initializing Properly

**Symptoms:**
- Init field code doesn't execute
- Computers have no filesystem

**Solutions:**
- Check for syntax errors in init field code
- Ensure code runs on server: Wrap in `if (isServer) then { ... }`
- Add delays if needed: `[this] spawn { sleep 1; /* code here */ };`
- Verify AE3 mod is loaded in mission

### Network Topology Issues

**Symptoms:**
- Some devices can ping, others cannot
- IP addresses not assigned

**Solutions:**
- Check for cyclic router connections (not allowed)
- Verify all devices connect to routers (not to each other directly)
- Test with simple topology first (1 router, 2 laptops)
- Use Zeus Asset Attributes to view IP addresses

### Power Grid Problems

**Symptoms:**
- Devices randomly lose power
- Batteries drain too quickly

**Solutions:**
- Check generator fuel levels (set initial fuel in init)
- Verify power connections are correct direction
- Ensure generators are turned on (default is on, but check)
- Monitor power consumption vs generation (use Asset Attributes)

### Init Field Code Not Executing

**Symptoms:**
- Users not created
- Files not appearing

**Solutions:**
- Check for typos in function names
- Ensure square brackets and parentheses are balanced
- Add `sleep 0.5;` before commands to allow init to complete:
  ```sqf
  [this] spawn {
      sleep 0.5;
      [_thisScript, "player", "password"] call AE3_armaos_fnc_computer_addUser;
  };
  ```
- Use `private _laptop = this;` if using `this` inside spawn

---

## Advanced Techniques

### Delayed Initialization

For complex setups, delay initialization to ensure dependencies are ready:

```sqf
[this] spawn {
    private _laptop = _this select 0;

    // Wait for filesystem to be ready
    waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };

    // Now safe to add files and users
    [_laptop, "admin", "password"] call AE3_armaos_fnc_computer_addUser;
    [_laptop, "/tmp/test.txt", "data", false, "root", [[false,true,false],[false,true,false]]] call AE3_filesystem_fnc_device_addFile;
};
```

### Dynamic Object References

Reference other objects in init fields:

```sqf
// Generator init - store reference
this setVariable ["myGeneratorName", "MainGenerator", true];

// Laptop init - reference generator
private _generator = missionNamespace getVariable ["MainGenerator", objNull];
if (!isNull _generator) then {
    // Do something with generator reference
};
```

### Custom Mission Scripts

Instead of cluttering init fields, create mission scripts:

**File:** `mission.sqm` folder → `initLaptops.sqf`

```sqf
// initLaptops.sqf
params ["_laptop", "_role"];

switch (_role) do {
    case "player": {
        [_laptop, "player", "password"] call AE3_armaos_fnc_computer_addUser;
        [_laptop, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;
    };
    case "enemy": {
        [_laptop, "admin", "SecurePass"] call AE3_armaos_fnc_computer_addUser;
        // Add enemy-specific files
    };
};
```

**Eden Init Field:**
```sqf
[this, "player"] execVM "initLaptops.sqf";
```

---

## Related Documentation

- [Zeus Guide](Zeus-Guide.md) - Live mission editing with Zeus
- [Mission Maker Guide](Mission-Maker-Guide.md) - Scripting API and advanced mission creation
- [Configuration](Configuration.md) - CBA settings for AE3
- [API Reference](API-Reference.md) - Complete function reference

---

**Need More Help?**

Visit the [Home](Home.md) page for additional resources and community support.
