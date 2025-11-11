# Advanced Equipment (AE3) Framework Wiki

Welcome to the AE3 Framework Developer Documentation. AE3 is an Arma 3 mod framework that implements a terminal-based cyber warfare system called ArmaOS. This wiki provides comprehensive technical documentation for mod developers and mission makers.

## What is AE3?

AE3 (Advanced Equipment Revamped) is a **framework**, not an end-user mod. It provides:

- **ArmaOS**: Unix-like terminal interface for in-game computers
- **Virtual Filesystem**: Hierarchical file system with permissions
- **Network Simulation**: Router-based networking with DHCP
- **Power Management**: Batteries, generators, solar panels with realistic consumption
- **Device Control**: Hack and control doors, lights, vehicles, drones, GPS trackers
- **Zeus/Eden Integration**: Modules for mission makers
- **ACE3 Interactions**: Dynamic interaction menus for equipment

Players use in-game laptops with terminal interfaces to hack and control mission-critical devices. The framework supports complex cyber warfare scenarios with realistic power constraints, network topology, and file permissions.

## Quick Reference

### Common Terminal Commands

```bash
ls [-l] [PATH]              # List directory contents
cd [PATH]                   # Change directory
cat FILE                    # Display file contents
mkdir PATH                  # Create directory
rm PATH                     # Delete file/directory
touch FILE [CONTENT]        # Create file

devices                     # List hackable devices
door -n NAME [-o|-c|-l|-u]  # Control doors (open/close/lock/unlock)
light -n NAME [-o|-c]       # Control lights (on/off)
vehicle -n NAME [ACTION]    # Control vehicles

ipconfig                    # Show network configuration
ping IP                     # Test network connectivity
lsusb                       # List USB devices
mount INTERFACE             # Mount flash drive
unmount INTERFACE           # Unmount flash drive

crypto -a ALG -m MODE -k KEY MSG  # Encrypt/decrypt messages
crack -a ALG -m MODE MSG           # Crack encrypted messages
```

### Common API Functions

```sqf
// Computer Control
[_computer, "username", "password"] call AE3_armaos_fnc_computer_addUser;
[_computer] call AE3_armaos_fnc_computer_turnOn;
[_computer] call AE3_armaos_fnc_computer_turnOff;

// Filesystem Operations
[[], _filesystem, "/tmp/file.txt", "Hello", "root"] call AE3_filesystem_fnc_createFile;
[[], _filesystem, "/tmp/logs", "root"] call AE3_filesystem_fnc_createDir;
private _content = [[], _filesystem, "/tmp/file.txt", "root", 1] call AE3_filesystem_fnc_getFile;

// Power Management
private _batteryInfo = [_battery] call AE3_power_fnc_getBatteryLevel;
[_generator] call AE3_power_fnc_turnOnDevice;

// Flash Drive
[_laptop, "usb0", "user"] call AE3_flashdrive_fnc_mount;
[_laptop, "usb0", "user"] call AE3_flashdrive_fnc_unmount;
```

## Documentation Navigation

### Core Documentation

- **[API Reference](API-Reference.md)** - Complete API documentation for all public functions
- **[Architecture Guide](Architecture.md)** - System architecture, data structures, and design patterns
- **[Terminal Guide](Terminal-Guide.md)** - Terminal interface, OS commands, and customization
- **[ACE Mutex Guide](ACE-Mutex.md)** - Understanding and using the computer mutex system

### Getting Started

1. Read the [Architecture Guide](Architecture.md) to understand how AE3 works
2. Review the [API Reference](API-Reference.md) for available functions
3. Check the [Terminal Guide](Terminal-Guide.md) for OS commands
4. See [ACE Mutex](ACE-Mutex.md) for concurrency handling

### For Mission Makers

- Use Zeus/Eden modules to register devices and configure networks
- Add users to computers with the "Add User" module
- Configure power connections and battery levels
- Set up network topology with routers and DHCP

### For Mod Developers

- Extend ArmaOS with custom OS commands
- Create custom filesystem objects
- Add new power-consuming devices
- Integrate with the network system
- Build custom device control interfaces

## Framework Structure

AE3 is organized into modular addons under `addons/`:

```
addons/
├── main/           # Core framework, Zeus UI, debug overlay, remote sync
├── armaos/         # Terminal/shell system, OS commands, UI rendering
├── filesystem/     # Virtual filesystem with permissions
├── network/        # Network simulation with routers and DHCP
├── power/          # Power grid, batteries, generators, solar panels
├── flashdrive/     # USB flash drive items for data transfer
└── interaction/    # ACE3 interaction menus for equipment
```

## Key Features

### Terminal System
- 4 retro terminal themes (ArmaOS, C64, Apple II, Amber)
- 9 keyboard layouts (AR, DE, FR, HE, HU, IT, RU, TR, US)
- Command history and autocomplete
- UI-on-Texture support for in-world laptop screens
- Multiplayer synchronization

### Filesystem
- Hierarchical directory structure (Unix-like)
- Per-file/directory permissions (execute/read/write)
- User ownership and access control
- Mount points for external storage
- Supports files containing strings, code, or any serializable data

### Network
- Router-based network topology
- DHCP server for automatic IP assignment
- Ping functionality for connectivity testing
- Cyclic connection detection
- Device visibility based on network access

### Power System
- Realistic battery consumption
- Solar panel power generation (time-of-day and orientation-aware)
- Fuel-powered generators
- Power connections between devices
- Configurable power costs per device action

### Device Control
- Doors (open/close/lock/unlock)
- Lights (on/off with power consumption)
- Vehicles (engine, lights, lock)
- Drones (future implementation)
- GPS trackers (future implementation)
- Power grids (control entire networks)

## Build System

AE3 uses HEMTT (Arma 3 build tool):

```bash
hemtt check         # Lint and validate code
hemtt dev           # Build for development
hemtt build         # Build for testing
hemtt release       # Build release version
```

## Requirements

- **Arma 3** version 2.12+ (required for UI-on-Texture)
- **CBA** (Community Base Addons) - settings, events, function compilation
- **ACE3** - interaction menus
- **ACEX** - extended ACE functionality

## Performance Notes

- Tested with 67+ players on dedicated servers
- Terminal updates throttled (configurable, default 0.3s) to reduce network traffic
- **NEVER transmit TEXT (structured text) via remoteExec** - always send STRING and render locally
- Network topology calculations cached for performance
- Filesystem operations validate paths before execution

## Support and Contribution

For issues, feature requests, or contributions, see the main repository README.

---

**Framework Version**: See `addons/main/script_version.hpp`

**Last Updated**: 2025-11-11
