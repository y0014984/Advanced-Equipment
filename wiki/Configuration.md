# Configuration Guide

This guide documents all CBA (Community Base Addons) settings available for the AE3 (Advanced Equipment) framework. These settings allow you to customize the behavior, appearance, and performance of the ArmaOS terminal system.

---

## Table of Contents

- [Accessing CBA Settings](#accessing-cba-settings)
- [Debug Settings](#debug-settings)
- [Terminal Appearance Settings](#terminal-appearance-settings)
- [Terminal Behavior Settings](#terminal-behavior-settings)
- [Performance Settings](#performance-settings)
- [Terminal Customization Settings](#terminal-customization-settings)
- [Recommended Configurations](#recommended-configurations)
- [Troubleshooting](#troubleshooting)

---

## Accessing CBA Settings

### In-Game (Main Menu)

1. Launch Arma 3
2. Click **Options**
3. Click **Addon Options**
4. Find settings under:
   - **Advanced Equipment** (Main category)
   - **ArmaOS** (Terminal-specific category)

### In-Game (During Mission)

1. Press **ESC**
2. Click **Addon Options**
3. Adjust settings (some may require mission restart)

### Server Configuration

Server admins can force settings by editing `userconfig/cba_settings.sqf`:

```sqf
// Force terminal design to ArmaOS theme
force AE3_TerminalDesign = 0;

// Force UI-on-Texture enabled
force AE3_UiOnTexture = true;

// Force debug mode off
force AE3_DebugMode = false;
```

Place in `@CBA_A3/userconfig/cba_settings.sqf` on the server.

---

## Debug Settings

### AE3_DebugMode

**Category:** Advanced Equipment

**Type:** Checkbox (Boolean)

**Default:** `false`

**Description:** Enables debug mode for AE3 framework. When enabled, displays additional debug information and logging.

**Effects:**
- Shows debug overlay with system information
- Logs detailed information to RPT file
- Displays error messages in-game
- Helps troubleshoot issues during development

**Recommended Values:**
- **Production/Public Server:** `false` (disabled)
- **Development/Testing:** `true` (enabled)
- **Mission Making:** `true` (enabled for debugging)

**Requires Mission Restart:** No

**Example:**
```sqf
AE3_DebugMode = true;  // Enable debug mode
```

---

### AE3_NetworkDebug

**Category:** Advanced Equipment

**Type:** Checkbox (Boolean)

**Default:** `false`

**Description:** Logs AE3 remoteExec traffic to `diag_log` for troubleshooting. Verbose; leave disabled on live servers.

**Effects:**
- Writes an entry for each AE3 remoteExec observed on the local machine.
- Useful for diagnosing excessive traffic or unexpected network calls.
- May produce large RPT logs; do not enable in production.

**Recommended Values:**
- **Production/Public Server:** `false`
- **Development/Testing:** `true` only temporarily when investigating network behavior

**Requires Mission Restart:** No

**Example:**
```sqf
AE3_NetworkDebug = true;  // Enable network logging to diag_log
```

---

## Terminal Appearance Settings

### AE3_TerminalDesign

**Category:** ArmaOS

**Type:** List (Dropdown)

**Default:** `0` (ArmaOS)

**Description:** Selects the visual theme for terminal displays. Changes colors, fonts, and overall appearance.

**Options:**
- **0 - ArmaOS** (Default): Modern green-on-black terminal, inspired by classic Unix terminals
- **1 - C64**: Commodore 64 style, blue background with light blue text
- **2 - Apple II**: Apple II style, black background with green text
- **3 - Amber**: Amber monochrome terminal, black background with amber/orange text

**Effects:**
- Changes terminal color scheme
- Modifies font rendering
- Affects UI element colors
- Applies to all terminals in mission

**Recommended Values:**
- **Realism/Immersion:** `0` (ArmaOS) or `3` (Amber)
- **Retro/Fun:** `1` (C64) or `2` (Apple II)
- **Readability:** `0` (ArmaOS) or `3` (Amber)

**Requires Mission Restart:** No (applies immediately)

**Example:**
```sqf
AE3_TerminalDesign = 3;  // Set to Amber theme
```

---

### AE3_KeyboardLayout

**Category:** ArmaOS

**Type:** List (Dropdown)

**Default:** `8` (US)

**Description:** Keyboard layout for terminal input. Affects which keys produce which characters.

**Options:**
- **0 - AR** (Arabic)
- **1 - DE** (Deutschland/German)
- **2 - FR** (France/French)
- **3 - HE** (Hebrew)
- **4 - HU** (Magyarország/Hungarian)
- **5 - IT** (Italia/Italian)
- **6 - RU** (Русский/Russian)
- **7 - TR** (Türkiye/Turkish)
- **8 - US** (United States/English) - Default

**Effects:**
- Remaps keyboard input to match selected layout
- Affects special character placement
- Useful for non-English keyboards

**Recommended Values:**
- **English Speakers:** `8` (US)
- **German Speakers:** `1` (DE)
- **Russian Speakers:** `6` (RU)
- **Other:** Select your native keyboard layout

**Requires Mission Restart:** No

**Example:**
```sqf
AE3_KeyboardLayout = 1;  // German keyboard layout
```

---

### AE3_TerminalDefaultSize

**Category:** ArmaOS

**Type:** Slider

**Default:** `0.75` (75%)

**Range:** `0.5` to `1.0` (50% to 100%)

**Description:** Default font size for terminal displays. Can be adjusted per-terminal with Ctrl+Plus/Minus keys.

**Effects:**
- Scales terminal font size
- Affects readability
- Impacts number of visible lines
- Does not affect UI-on-Texture rendering (uses fixed size)

**Recommended Values:**
- **Small Screens (1080p or lower):** `0.5` to `0.6`
- **Standard Screens:** `0.75` (default)
- **Large Screens (1440p+):** `0.8` to `1.0`
- **Accessibility:** `0.9` to `1.0` (larger for readability)

**Requires Mission Restart:** No

**Example:**
```sqf
AE3_TerminalDefaultSize = 0.85;  // 85% font size
```

---

### AE3_TerminalShowAsciiArt

**Category:** ArmaOS

**Type:** Checkbox (Boolean)

**Default:** `true`

**Description:** Display ASCII art logo in the terminal boot header.

**Effects:**
- Shows/hides ASCII art in terminal header
- Reduces visual clutter if disabled
- Affects boot message length

**Recommended Values:**
- **Immersion/Fun:** `true` (enabled)
- **Performance:** `false` (disabled, slightly faster boot)
- **Clean UI:** `false` (disabled)

**Requires Mission Restart:** No

**Example:**
```sqf
AE3_TerminalShowAsciiArt = false;  // Hide ASCII art
```

---

## Terminal Behavior Settings

### AE3_TerminalScrollSpeed

**Category:** ArmaOS

**Type:** List (Dropdown)

**Default:** `0` (1 line)

**Description:** Number of lines to scroll when using arrow keys in terminal.

**Options:**
- **0 - 1 line** (Default): Scroll one line at a time
- **1 - 2 lines**: Scroll two lines at a time
- **2 - 3 lines**: Scroll three lines at a time

**Effects:**
- Changes scroll speed with Up/Down arrow keys
- Affects terminal navigation speed
- Does not affect mouse wheel scrolling

**Recommended Values:**
- **Precision:** `0` (1 line)
- **Speed:** `2` (3 lines)
- **Balanced:** `1` (2 lines)

**Requires Mission Restart:** No

**Example:**
```sqf
AE3_TerminalScrollSpeed = 2;  // Scroll 3 lines at a time
```

---

## Performance Settings

### AE3_UiOnTexture

**Category:** ArmaOS

**Type:** Checkbox (Boolean)

**Default:** `false`

**Description:** Enable UI-on-Texture rendering for laptop screens. Displays terminal on the laptop's screen texture in 3D world.

**Effects:**
- **Enabled**: Terminal is visible on laptop screen in 3D world
- **Disabled**: Terminal is only visible in dialog window
- Increases network traffic when enabled (transmits terminal state to nearby players)
- When disabled, laptops do not broadcast UI-on-Texture data
- Looks more immersive but has performance cost

**Performance Impact:**
- **Enabled**: Higher network traffic, more rendering overhead
- **Disabled**: Better performance, lower network usage

**Recommended Values:**
- **High-Performance Servers (Dedicated, <20 players):** `true` (enabled for immersion)
- **Low-Performance Servers (>30 players):** `false` (disabled for performance)
- **Single Player/Small Groups:** `true` (enabled)
- **Large Public Servers:** `false` (disabled)

**Requires Mission Restart:** No

**Example:**
```sqf
AE3_UiOnTexture = true;  // Enable UI-on-Texture
```

---

### AE3_UiPlayerRange

**Category:** ArmaOS

**Type:** Slider

**Default:** `5` meters

**Range:** `1` to `500` meters

**Global Setting:** Yes (synchronized across all clients)

**Description:** Maximum distance (in meters) for players to receive UI-on-Texture updates. Only affects players within range of a laptop.

**Effects:**
- Players beyond this range won't see UI-on-Texture updates
- Reduces network traffic by limiting update recipients
- Does not affect dialog window usage

**Performance Impact:**
- **Lower values (1-10m):** Better performance, less network traffic
- **Higher values (50-500m):** Worse performance, more network traffic

**Recommended Values:**
- **Performance Priority:** `5` to `10` meters
- **Balanced:** `15` to `25` meters
- **Immersion Priority (large screens/presentations):** `50` to `100` meters

**Requires Mission Restart:** No

**Example:**
```sqf
AE3_UiPlayerRange = 10;  // Update UI-on-Texture for players within 10m
```

---

### AE3_armaos_uiOnTexUpdateInterval

**Category:** ArmaOS

**Type:** Slider

**Default:** `0.3` seconds

**Range:** `0.1` to `2.0` seconds

**Description:** How often (in seconds) to update UI-on-Texture displays for nearby players. Lower values provide smoother updates but increase network traffic.

**Effects:**
- **Lower values (0.1-0.2s):** Smooth updates, high network traffic
- **Higher values (0.5-2.0s):** Choppy updates, low network traffic
- Only applies when UI-on-Texture is enabled

**Performance Impact:**
- **0.1s:** Very high network traffic, very smooth
- **0.3s (Default):** Balanced, recommended for most servers
- **0.5s:** Lower traffic, slightly choppy
- **1.0s+:** Very low traffic, noticeable lag

**Recommended Values:**
- **High-Performance Servers:** `0.2` to `0.3` seconds
- **Balanced:** `0.3` to `0.5` seconds (default recommended)
- **Low-Performance Servers:** `0.5` to `1.0` seconds
- **Very Low-Performance:** `1.0` to `2.0` seconds

**Requires Mission Restart:** No

**Example:**
```sqf
AE3_armaos_uiOnTexUpdateInterval = 0.5;  // Update every 0.5 seconds
```

**Note:** This setting is critical for multiplayer performance. See "Recommended Configurations" for guidance.

---

### AE3_UiMaxTransmitLines

**Category:** ArmaOS

**Type:** Slider

**Default:** `120` lines

**Range:** `16` to `400` lines

**Description:** Caps how many terminal lines are transmitted to nearby viewers for UI-on-Texture. Only the visible viewport and nearby context are sent.

**Effects:**
- **Lower values (64-120):** Minimal bandwidth use; mirrors the current viewport.
- **Higher values (200-400):** Sends more history; sharply increases bandwidth and may stutter or spike clients/servers. Not advised outside testing.

**Performance Impact:** Directly limits payload size per update. Raising above defaults can cause large network bursts and should be avoided on live servers.

**Recommended Values:**
- **Performance Priority (default):** `64`
- **Tight Bandwidth:** `64` to `96`
- **Testing/Presentations (use with caution):** `160` to `200` (expect higher traffic)

**Requires Mission Restart:** No

**Example:**
```sqf
AE3_UiMaxTransmitLines = 64;  // Cap UI-on-Texture payload to 120 lines
```

**Warning:** Increasing beyond the default is not recommended and may cause severe bandwidth spikes or server network instability.

---

## Terminal Customization Settings

These settings allow you to customize the terminal boot messages and branding.

### AE3_TerminalDialogTitle

**Category:** ArmaOS

**Type:** Text Box (String)

**Default:** `"SHITE™ COMPUTING"`

**Global Setting:** Yes

**Description:** The title shown in the terminal dialog window header.

**Effects:**
- Changes dialog window title bar text
- Visible when terminal is open in dialog mode
- Does not affect UI-on-Texture display

**Example:**
```sqf
AE3_TerminalDialogTitle = "ACME Corp Terminal";
```

---

### AE3_TerminalBiosVersion

**Category:** ArmaOS

**Type:** Text Box (String)

**Default:** `"SHITE™ BIOS v1.0.0"`

**Global Setting:** Yes

**Description:** The BIOS version line shown in the terminal boot header.

**Effects:**
- Displayed during terminal boot sequence
- Part of immersive boot experience
- Can be customized for mission themes

**Example:**
```sqf
AE3_TerminalBiosVersion = "MilTech BIOS v2.4.1";
```

---

### AE3_TerminalCopyright

**Category:** ArmaOS

**Type:** Text Box (String)

**Default:** `"© 2025 System Hardware Integration & Technology Enterprises"`

**Global Setting:** Yes

**Description:** The copyright line shown in the terminal boot header.

**Effects:**
- Displayed during boot sequence
- Adds to immersive branding
- Can include mission-specific text

**Example:**
```sqf
AE3_TerminalCopyright = "© 2035 Special Operations Command";
```

---

### AE3_TerminalBootMessage

**Category:** ArmaOS

**Type:** Text Box (String)

**Default:** `"Initializing kernel... please wait..."`

**Global Setting:** Yes

**Description:** The initialization message shown in the terminal boot header.

**Effects:**
- Displayed during boot sequence
- Sets the tone for terminal experience

**Example:**
```sqf
AE3_TerminalBootMessage = "Loading secure military OS...";
```

---

### AE3_TerminalTipMessage

**Category:** ArmaOS

**Type:** Text Box (String)

**Default:** `"> Tip: SHITE™ laptops perform better when plugged in."`

**Global Setting:** Yes

**Description:** The tip message shown in the terminal boot header.

**Effects:**
- Provides helpful hints to players
- Can include mission-specific tips
- Part of boot sequence

**Example:**
```sqf
AE3_TerminalTipMessage = "> Tip: Type 'help' for available commands.";
```

---

### AE3_TerminalTagline

**Category:** ArmaOS

**Type:** Text Box (String)

**Default:** `"Powered by SHITE™ Technologies – Excellence, from the ground up."`

**Global Setting:** Yes

**Description:** The tagline shown in the terminal header after ASCII art.

**Effects:**
- Displayed after ASCII art (if enabled)
- Adds branding/immersion
- Can be mission-themed

**Example:**
```sqf
AE3_TerminalTagline = "Secure. Reliable. Military-Grade.";
```

---

## Recommended Configurations

### Configuration 1: High-Performance Server (Dedicated, <20 Players)

**Goal:** Maximum immersion with good performance

```sqf
// Performance
AE3_UiOnTexture = true;
AE3_UiPlayerRange = 15;
AE3_armaos_uiOnTexUpdateInterval = 0.3;

// Appearance
AE3_TerminalDesign = 0;  // ArmaOS theme
AE3_TerminalDefaultSize = 0.75;
AE3_TerminalShowAsciiArt = true;

// Behavior
AE3_TerminalScrollSpeed = 1;  // 2 lines

// Debug
AE3_DebugMode = false;

// Keyboard
AE3_KeyboardLayout = 8;  // US (adjust for your region)
```

---

### Configuration 2: Large Public Server (>30 Players)

**Goal:** Best performance, minimal network traffic

```sqf
// Performance (prioritize)
AE3_UiOnTexture = false;  // Disable UI-on-Texture for performance
AE3_UiPlayerRange = 5;
AE3_armaos_uiOnTexUpdateInterval = 0.5;

// Appearance
AE3_TerminalDesign = 0;
AE3_TerminalDefaultSize = 0.7;  // Slightly smaller
AE3_TerminalShowAsciiArt = false;  // Disable for faster boot

// Behavior
AE3_TerminalScrollSpeed = 2;  // 3 lines for faster navigation

// Debug
AE3_DebugMode = false;

// Keyboard
AE3_KeyboardLayout = 8;
```

---

### Configuration 3: Single Player / Co-op (<5 Players)

**Goal:** Maximum immersion and visual quality

```sqf
// Performance (immersion priority)
AE3_UiOnTexture = true;
AE3_UiPlayerRange = 25;  // Larger range for immersion
AE3_armaos_uiOnTexUpdateInterval = 0.2;  // Smoother updates

// Appearance
AE3_TerminalDesign = 3;  // Amber theme (immersive)
AE3_TerminalDefaultSize = 0.85;  // Larger for readability
AE3_TerminalShowAsciiArt = true;

// Behavior
AE3_TerminalScrollSpeed = 1;

// Debug
AE3_DebugMode = false;

// Keyboard
AE3_KeyboardLayout = 8;

// Customization (optional)
AE3_TerminalDialogTitle = "Military Terminal v2.0";
AE3_TerminalBiosVersion = "SecureBIOS v3.1.4";
AE3_TerminalCopyright = "© 2035 Special Operations Division";
AE3_TerminalBootMessage = "Secure kernel loading...";
AE3_TerminalTipMessage = "> Tip: All sessions are monitored.";
AE3_TerminalTagline = "Classified Access Only.";
```

---

### Configuration 4: Development / Testing

**Goal:** Debug and test missions

```sqf
// Performance
AE3_UiOnTexture = true;
AE3_UiPlayerRange = 10;
AE3_armaos_uiOnTexUpdateInterval = 0.3;

// Appearance
AE3_TerminalDesign = 0;
AE3_TerminalDefaultSize = 0.75;
AE3_TerminalShowAsciiArt = true;

// Behavior
AE3_TerminalScrollSpeed = 2;  // Fast scrolling for testing

// Debug (enable for development)
AE3_DebugMode = true;  // Enable debug mode

// Keyboard
AE3_KeyboardLayout = 8;
```

---

### Configuration 5: Retro Theme (Fun)

**Goal:** Nostalgic retro computing experience

```sqf
// Performance
AE3_UiOnTexture = true;
AE3_UiPlayerRange = 15;
AE3_armaos_uiOnTexUpdateInterval = 0.3;

// Appearance (retro)
AE3_TerminalDesign = 1;  // C64 theme
AE3_TerminalDefaultSize = 0.75;
AE3_TerminalShowAsciiArt = true;

// Behavior
AE3_TerminalScrollSpeed = 0;  // 1 line (authentic)

// Debug
AE3_DebugMode = false;

// Keyboard
AE3_KeyboardLayout = 8;

// Customization (retro branding)
AE3_TerminalDialogTitle = "Commodore Terminal 64";
AE3_TerminalBiosVersion = "KERNAL v1.0";
AE3_TerminalCopyright = "© 1982 Commodore Business Machines";
AE3_TerminalBootMessage = "**** COMMODORE 64 BASIC V2 ****";
AE3_TerminalTipMessage = "> Tip: LOAD '*',8,1 to boot from disk.";
AE3_TerminalTagline = "64K RAM SYSTEM  38911 BASIC BYTES FREE";
```

---

## Troubleshooting

### Terminal is Laggy / Choppy

**Possible Causes:**
- UI-on-Texture update interval too low
- Too many players in range
- Server performance issues

**Solutions:**
1. Increase `AE3_armaos_uiOnTexUpdateInterval` to `0.5` or higher
2. Decrease `AE3_UiPlayerRange` to `5` or `10`
3. Consider disabling `AE3_UiOnTexture` on large servers
4. Check server FPS and network bandwidth

---

### Terminal Text Too Small / Too Large

**Possible Causes:**
- `AE3_TerminalDefaultSize` not optimized for screen resolution

**Solutions:**
1. Adjust `AE3_TerminalDefaultSize` slider
2. Use Ctrl+Plus/Minus keys in-game to adjust per-terminal
3. Recommended values:
   - 1080p: `0.6` to `0.75`
   - 1440p: `0.75` to `0.85`
   - 4K: `0.85` to `1.0`

---

### UI-on-Texture Not Updating for Some Players

**Possible Causes:**
- Players beyond `AE3_UiPlayerRange`
- Network latency
- Update interval too high

**Solutions:**
1. Increase `AE3_UiPlayerRange` to cover desired area
2. Decrease `AE3_armaos_uiOnTexUpdateInterval` for faster updates
3. Verify `AE3_UiOnTexture` is enabled
4. Check player network connection

---

### Wrong Keyboard Layout / Characters

**Possible Causes:**
- `AE3_KeyboardLayout` doesn't match physical keyboard

**Solutions:**
1. Set `AE3_KeyboardLayout` to match your keyboard:
   - US/English: `8`
   - German: `1`
   - French: `2`
   - Russian: `6`
   - Etc.
2. Restart terminal (close and reopen)

---

### Terminal Boot Messages Not Customized

**Possible Causes:**
- Settings not synchronized (multiplayer)
- Settings changed after terminal opened

**Solutions:**
1. Verify settings are marked as "Global" (synchronized)
2. Close and reopen terminal to see changes
3. Server admins: Force settings in `cba_settings.sqf`

---

### Performance Issues on Server

**Possible Causes:**
- Too many laptops with UI-on-Texture enabled
- Update interval too aggressive
- Too many players

**Solutions:**
1. **Disable UI-on-Texture** for large servers: `AE3_UiOnTexture = false`
2. **Increase update interval**: `AE3_armaos_uiOnTexUpdateInterval = 0.5` or higher
3. **Reduce range**: `AE3_UiPlayerRange = 5`
4. **Limit number of laptops** in mission (10-20 max)
5. **Turn off unused laptops**: Use `AE3_armaos_fnc_computer_turnOff`

---

## Server Admin Notes

### Forcing Settings

Server admins can force specific settings to ensure consistency:

**File:** `@CBA_A3/userconfig/cba_settings.sqf`

```sqf
// Force settings (players cannot change)
force AE3_DebugMode = false;
force AE3_UiOnTexture = true;
force AE3_UiPlayerRange = 10;
force AE3_armaos_uiOnTexUpdateInterval = 0.3;
force AE3_TerminalDesign = 0;

// Force terminal branding
force AE3_TerminalDialogTitle = "Server Name Terminal";
force AE3_TerminalBiosVersion = "Server BIOS v1.0";
force AE3_TerminalCopyright = "© 2025 Server Community";
```

### Performance Monitoring

Monitor server performance with these settings enabled:

1. Enable `AE3_DebugMode` temporarily
2. Check RPT logs for errors
3. Monitor server FPS
4. Track network traffic
5. Adjust settings based on findings

---

## Related Documentation

- [Zeus Guide](Zeus-Guide.md) - Zeus module usage
- [Eden Editor Guide](Eden-Editor-Guide.md) - Mission setup
- [Mission Maker Guide](Mission-Maker-Guide.md) - Scripting API
- [Terminal Guide](Terminal-Guide.md) - Player terminal usage

---

**Need More Help?**

Visit the [Home](Home.md) page for community support and additional resources.
