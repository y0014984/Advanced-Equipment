// File: XEH_preInit.sqf
#include "script_component.hpp"
#include "XEH_PREP.hpp"

/* ================================================================================ */

// Server-side: keep /sys/battery/capacity file content in sync with the actual battery level
if (isServer) then
{
	["ae3_armaos_updateBatterySysFile", {
		params ["_computerNetId", "_percent"];

		private _computer = objectFromNetId _computerNetId;
		if (isNull _computer) exitWith {};

		private _filesystem = _computer getVariable ["AE3_filesystem", []];
		if (_filesystem isEqualTo []) exitWith {};

		try
		{
			[[], _filesystem, "/sys/battery/capacity", "root", format ["%1", round _percent], false] call AE3_filesystem_fnc_writeToFile;
			_computer setVariable ["AE3_filesystem", _filesystem];
		}
		catch
		{
			INFO_1("Could not update /sys/battery/capacity: %1",_exception);
		};
	}] call CBA_fnc_addEventHandler;
};

// Client-side: force-close an open terminal dialog (e.g. when the computer crashes)
if (hasInterface) then
{
	["ae3_armaos_forceCloseTerminal", {
		params ["_computer"];

		private _display = findDisplay 15984;
		if (isNull _display) exitWith {};

		if ((_display getVariable ["AE3_computer", objNull]) isEqualTo _computer) then
		{
			_display closeDisplay 2;
		};
	}] call CBA_fnc_addEventHandler;
};

/* ================================================================================ */

[
	"AE3_AllowRootLogin",
	"CHECKBOX",
	["Allow direct root login", "Default for laptops that do not set their own root login policy in the editor. Allows logging in directly as root at the terminal. When disabled (default), use a regular user plus the sudo command (users listed in /etc/sudoers)."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	false,
	1, // global
	{ params ["_value"]; },
	false
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_CliElevateSudoers",
	"CHECKBOX",
	["Sudoers act as root at the terminal", "Let accounts listed in /etc/sudoers read and write any file from the terminal, the way they already can from the desktop file manager. When disabled, the terminal keeps strict Unix semantics and a sudoer must use sudo or su before reaching another user's files."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	true,
	1, // global
	{ params ["_value"]; },
	false
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_DefaultRootPassword",
	"EDITBOX",
	["Default root password", "Password of the root account every laptop is created with. A laptop's own root password (editor attribute or AE3_armaos_fnc_computer_setRootPassword) overrides it."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"toor",
	1, // global
	{ params ["_value"]; },
	false
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_EnableErrorSound",
	"CHECKBOX",
	["Error sound", "Play a short error sound at the computer when a command fails (wrong usage, command not found, permission denied)."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	true,
	1, // global
	{ params ["_value"]; },
	false
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TransferSpeedLocal",
	"SLIDER",
	["Transfer speed: local (KB/s)", "Simulated file transfer speed for local copies. 0 disables transfer simulation."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[0, 102400, 20480, 0],
	1,
	{ params ["_value"]; },
	false
] call CBA_fnc_addSetting;

[
	"AE3_TransferSpeedUsb",
	"SLIDER",
	["Transfer speed: USB (KB/s)", "Simulated file transfer speed for copies from/to USB flash drives. 0 disables transfer simulation."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[0, 102400, 2048, 0],
	1,
	{ params ["_value"]; },
	false
] call CBA_fnc_addSetting;

[
	"AE3_TransferSpeedNetwork",
	"SLIDER",
	["Transfer speed: network (KB/s)", "Simulated file transfer speed for network transfers (ssh, downloads). 0 disables transfer simulation."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[0, 102400, 512, 0],
	1,
	{ params ["_value"]; },
	false
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_KeyboardLayout",
	"LIST",
	["STR_AE3_Main_CbaSettings_KeyboardLayoutName", "STR_AE3_Main_CbaSettings_KeyboardLayoutTooltip"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[
		["AR", "DE", "FR", "HE", "HU", "IT", "RU", "TR", "US"],
		[["AR", "Arabic"], ["DE", "Deutschland"], ["FR", "France"], ["HE", "Hebrew"], ["HU", "Magyarország"], ["IT", "Italia"], ["RU", "Русский"], ["TR", "Türkiye"], ["US", "United States"]],
		8
	],
    0, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalDesign",
	"LIST",
	["STR_AE3_Main_CbaSettings_TerminalDesignName", "STR_AE3_Main_CbaSettings_TerminalDesignTooltip"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[
		[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19],
		[
			["STR_AE3_Main_CbaSettings_TerminalDesignNameArmaOS", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipArmaOS"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameC64", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipC64"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameAppleII", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipAppleII"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameAmber", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipAmber"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameMidnightBlue", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipMidnightBlue"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameLightMode", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipLightMode"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameRetroRed", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipRetroRed"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameTealTerm", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipTealTerm"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameNeonViolet", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipNeonViolet"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameDarkGray", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipDarkGray"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameIceBlue", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipIceBlue"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameSepiaVintage", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipSepiaVintage"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameHighContrastDark", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipHighContrastDark"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameHighContrastLight", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipHighContrastLight"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameYellowOnBlack", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipYellowOnBlack"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameCyanOnBlack", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipCyanOnBlack"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameOrangeOnBlack", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipOrangeOnBlack"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameCreamMode", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipCreamMode"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameTerminalGreen", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipTerminalGreen"],
			["STR_AE3_Main_CbaSettings_TerminalDesignNameSoftBlue", "STR_AE3_Main_CbaSettings_TerminalDesignTooltipSoftBlue"]
		],
		9
	],
    0, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalScrollSpeed",
	"LIST",
	["STR_AE3_Main_CbaSettings_TerminalScrollSpeedName", "STR_AE3_Main_CbaSettings_TerminalScrollSpeedTooltip"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[
		[1, 2, 3],
		[
			["STR_AE3_Main_CbaSettings_1line", "STR_AE3_Main_CbaSettings_1line"],
			["STR_AE3_Main_CbaSettings_2lines", "STR_AE3_Main_CbaSettings_2lines"],
			["STR_AE3_Main_CbaSettings_3lines", "STR_AE3_Main_CbaSettings_3lines"]
		],
		0
	],
    0, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalDefaultSize",
	"SLIDER",
	["Terminal Default Size", "The default font size for terminal displays (0.5 = 50%, 1.0 = 100%). You can also use Ctrl + Plus/Minus to adjust size in-game."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[0.5, 1.0, 0.75, 2],
    0, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_UiOnTexture",
	"CHECKBOX",
	["STR_AE3_Main_CbaSettings_UiOnTextureName", "STR_AE3_Main_CbaSettings_UiOnTextureTooltip"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	false,
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_UiPlayerRange",
	"SLIDER",
	["UI-on-Texture Range", "Max Range (in meter) for players to be for the UI to update for them when viewing the laptop(s)"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[1, 10, 2, 0],
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    {
        params ["_value"];
		missionNamespace setVariable ["AE3_UiPlayerRange", _value, true];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_armaos_uiOnTexUpdateInterval",
	"SLIDER",
	["UI-on-Texture Update Interval", "How often (in seconds) to update UI-on-Texture displays for nearby players. 0 = Real-time synchronization (instant updates, highest network usage). 0.1-2.0 = Hybrid mode with throttled full updates + real-time input tracking (balanced). Recommended: 1.0 seconds for normal play, 0.3 for demonstrations."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[0, 2.0, 1.0, 1], // min, max, default, decimal places
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_UiMaxConcurrentViewers",
	"SLIDER",
	["UI-on-Texture Max Viewers", "Maximum number of players who can simultaneously receive UI-on-Texture updates from a single laptop. Limits network bandwidth usage. Set to -1 for unlimited (not recommended for dedicated servers with many players)."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[-1, 50, 3, 0], // min, max, default, decimal places (-1 = unlimited)
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_UiMaxTransmitLines",
	"SLIDER",
	["STR_AE3_Main_CbaSettings_UiOnTexMaxLinesName", "STR_AE3_Main_CbaSettings_UiOnTexMaxLinesTooltip"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[16, 400, 64, 0], // min, max, default, decimal places
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_UiKeystrokeSyncInterval",
	"SLIDER",
	["UI-on-Texture Keystroke Sync Interval", "Minimum interval (in seconds) between keystroke synchronization to nearby players. 0 = Real-time per-keystroke sync (highest responsiveness, high network usage). 0.1-0.5 = Debounced sync (balanced). Recommended: 0.3 seconds."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[0, 1.0, 0.3, 2], // min, max, default, decimal places
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_UiEnableChangeDetection",
	"CHECKBOX",
	["UI-on-Texture Change Detection", "Only send terminal updates when content actually changes. Significantly reduces network usage when terminals are idle. Recommended: Enabled."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	true,
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can't be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalDialogTitle",
	"EDITBOX",
	["Terminal Dialog Title", "The title shown in the terminal dialog window header"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"SHITE™ COMPUTING",
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalBiosVersion",
	"EDITBOX",
	["Terminal BIOS Version", "The BIOS version line shown in the terminal header"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"SHITE™ BIOS v1.0.0",
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalCopyright",
	"EDITBOX",
	["Terminal Copyright", "The copyright line shown in the terminal header"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"© 2025 System Hardware Integration & Technology Enterprises",
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalBootMessage",
	"EDITBOX",
	["Terminal Boot Message", "The initialization message shown in the terminal header"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"Initializing kernel... please wait...",
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalTipMessage",
	"EDITBOX",
	["Terminal Tip Message", "The tip message shown in the terminal header"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"> Tip: SHITE™ laptops perform better when plugged in.",
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalShowAsciiArt",
	"CHECKBOX",
	["Show ASCII Art", "Display ASCII art in the terminal header"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	true,
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_TerminalTagline",
	"EDITBOX",
	["Terminal Tagline", "The tagline shown in the terminal header after ASCII art"],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	"Powered by SHITE™ Technologies - Excellence, from the ground up.",
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_StartupTime",
	"SLIDER",
	["Laptop Startup Time", "Time (in seconds) for laptop to complete cold boot startup animation. Warm boot (from standby) is always 3 seconds."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[3, 15, 15, 0], // min, max, default, decimal places
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

[
	"AE3_ShutdownTime",
	"SLIDER",
	["Laptop Shutdown Time", "Time (in seconds) for laptop to complete shutdown animation."],
	"STR_AE3_ArmaOS_CbaSettings_ArmaOSCategoryName",
	[1, 15, 15, 0], // min, max, default, decimal places
    1, // "_isGlobal" flag. '1' = all clients share the same setting, '2' = setting can’t be overwritten (optional, default: 0)
    {
        params ["_value"];
    }, // function that will be executed once on mission start and every time the setting is changed.
    false // Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;

/* ================================================================================ */

// Add ACE self-action for deploying laptops from inventory
if (!isDedicated) then {
	// A laptop item that never was a world object: the arsenal / loadout base class (scopeArsenal != 0)
	// rather than one of the per-instance Item_Laptop_AE3_ID_N classes. It carries no tracked object and
	// no item buffer entry, so it is deployed by spawning a fresh laptop from its paired object class.
	missionNamespace setVariable ["AE3_armaos_isFreshLaptopItem", {
		params ["_item"];
		(_item isKindOf ["Item_Laptop_AE3", configFile >> "CfgWeapons"])
		&& {(getNumber (configFile >> "CfgWeapons" >> _item >> "scopeArsenal")) != 0}
		&& {(getText (configFile >> "CfgWeapons" >> _item >> "ae3_vehicle")) isNotEqualTo ""}
	}];

	[
		{
			// Add deploy laptop self-action when ACE interactions are ready
			private _deployAction =
			[
				"AE3_DeployLaptopAction", // internal name
				localize "STR_AE3_ArmaOS_Laptop_Deploy", // visible name
				"",
				{},  // No direct action - uses children
				{
					// condition - only show if player has a laptop item in inventory (a packed laptop or
					// a fresh arsenal one)
					params ["_player", "_player", "_params"];
					private _isFresh = missionNamespace getVariable ["AE3_armaos_isFreshLaptopItem", {false}];
					private _hasLaptop = false;
					{
						if (_x find "Item_Laptop_AE3_ID_" == 0 || {[_x] call _isFresh}) exitWith {
							_hasLaptop = true;
						};
					} forEach (items _player);
					_hasLaptop
				},
				{
					// Insert children - dynamic list of laptops
					params ["_player", "_player", "_params"];

					// Build list of laptop items
					private _isFresh = missionNamespace getVariable ["AE3_armaos_isFreshLaptopItem", {false}];
					private _laptopItems = [];
					private _actions = [];

					{
						if (_x find "Item_Laptop_AE3_ID_" == 0 || {[_x] call _isFresh}) then {
							_laptopItems pushBack _x;
						};
					} forEach (items _player);

					// Create an action for each laptop
					{
						private _itemClass = _x;
						private _laptopName = "";

						if ([_itemClass] call _isFresh) then {
							// Fresh arsenal laptop: no ID, no stored name - label it with its item name.
							_laptopName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
						} else {
							// Extract ID from item class name (e.g., "Item_Laptop_AE3_ID_5" -> "5")
							private _idStr = _itemClass select [19]; // Skip "Item_Laptop_AE3_ID_" (19 chars)

							// Get custom name from laptop object if in stable mode
							private _customName = "";
							private _laptopTracker = missionNamespace getVariable ["AE3_LAPTOP_STABLE_TRACKER", createHashMap];
							if (_itemClass in _laptopTracker) then {
								private _laptopObj = _laptopTracker get _itemClass;
								if (!isNull _laptopObj) then {
									_customName = _laptopObj getVariable ["AE3_laptop_customName", ""];
								};
							};

							// Format action label: "CustomName (RootBook X)" or "RootBook X" if no custom name
							_laptopName = if (_customName != "") then {
								format ["%1 (RootBook %2)", _customName, _idStr]
							} else {
								format ["RootBook %1", _idStr]
							};
						};

						// Create action for this specific laptop
						private _laptopAction = [
							format ["AE3_DeployLaptop_%1", _itemClass],
							_laptopName,
							"", // icon
							{
								params ["_target", "_player", "_params"];

								// Spawn to run in scheduled environment (required for getRemoteVar)
								[_player, _params] spawn {
									params ["_player", "_params"];
									private _itemToDeploy = _params select 0;

									// A fresh arsenal laptop has no packed object to unhide, so it is created
									// straight from its item class regardless of the deployment mode.
									private _isFresh = missionNamespace getVariable ["AE3_armaos_isFreshLaptopItem", {false}];
									if ([_itemToDeploy] call _isFresh) exitWith {
										[_player, _itemToDeploy] call AE3_armaos_fnc_laptop_item2obj;
									};

									// Check deployment type setting: 0 = Stable, 1 = Experimental
									private _deploymentType = missionNamespace getVariable ["AE3_DeploymentType", 0];

									if (_deploymentType == 0) then {
										// Stable mode - use stable deployment
										[_player, _itemToDeploy] call AE3_armaos_fnc_laptop_deploy_stable;
									} else {
										// Experimental mode - use experimental deployment
										// Calculate deployment position
										private _deployPos = _player modelToWorld [0, 1.5, 0];
										private _terrainHeight = getTerrainHeightASL [_deployPos select 0, _deployPos select 1];
										_deployPos set [2, _terrainHeight];

										// Deploy the selected laptop
										[_player, _itemToDeploy, _deployPos] call AE3_armaos_fnc_laptop_item2obj;

										// Laptop deployed successfully (no hint needed)
									};
								};
							},
							{true},
							{},
							[_itemClass, _laptopName]  // Pass item class and name as params
						] call ace_interact_menu_fnc_createAction;

						_actions pushBack [_laptopAction, [], _player];
					} forEach _laptopItems;

					_actions
				}
			] call ace_interact_menu_fnc_createAction;

			["CAManBase", 1, ["ACE_SelfActions", "ACE_Equipment"], _deployAction, true] call ace_interact_menu_fnc_addActionToClass;

			// Self-action to use a laptop straight from the inventory, without deploying it into the
			// world - useful when a player cannot place a laptop (e.g. seated in a vehicle). Only
			// available in stable deployment mode, where the packed laptop still has a live (hidden)
			// object carrying its state in AE3_LAPTOP_STABLE_TRACKER.
			private _useFromInventory = {
				params ["_itemClass", "_mode"];

				// A fresh arsenal laptop has no packed object yet: create it, then immediately pack it
				// through the normal pickup path so it becomes a hidden, tracked Item_Laptop_AE3_ID_N
				// laptop like any other - and can be used from the inventory from here on.
				private _isFresh = missionNamespace getVariable ["AE3_armaos_isFreshLaptopItem", {false}];
				if ([_itemClass] call _isFresh) then {
					private _spawned = [player, _itemClass] call AE3_armaos_fnc_laptop_item2obj;
					if (isNull _spawned) exitWith {};
					[_spawned, player] call AE3_armaos_fnc_laptop_pickup_stable;
					private _tracked = missionNamespace getVariable ["AE3_LAPTOP_STABLE_TRACKER", createHashMap];
					_itemClass = "";
					{
						if (_y isEqualTo _spawned) exitWith { _itemClass = _x; };
					} forEach _tracked;
					if (_itemClass isEqualTo "") exitWith {};
				};
				if (_itemClass isEqualTo "") exitWith {};

				private _tracker = missionNamespace getVariable ["AE3_LAPTOP_STABLE_TRACKER", createHashMap];
				private _laptop = _tracker getOrDefault [_itemClass, objNull];
				if (isNull _laptop) exitWith {};

				// Respect the same access model as the world "Use" actions.
				if (!isNil "AE3_desktop_fnc_canAccessInterface" && {!([_laptop, player, _mode] call AE3_desktop_fnc_canAccessInterface)}) exitWith {};
				if (!([_laptop] call AE3_armaos_fnc_computer_isFree)) exitWith {};

				// A laptop packed while switched off is powered on before opening the interface.
				if ((_laptop getVariable ["AE3_power_powerState", 0]) != 1) then {
					[_laptop] remoteExecCall ["AE3_power_fnc_turnOnDevice", 2];
					private _timeout = time + 5;
					waitUntil { (_laptop getVariable ["AE3_power_powerState", 0]) == 1 || {!alive _laptop} || {time > _timeout} };
				};
				if ((_laptop getVariable ["AE3_power_powerState", 0]) != 1) exitWith {};

				_laptop setVariable ["AE3_computer_mutex", player, true];

				// The laptop is in use rather than packed away, so anything that was acting on it as stowed
				// kit - a charger cabled to it, for one - is no longer connected to anything.
				["AE3_laptop_removedFromInventory", [player, _itemClass]] call CBA_fnc_globalEvent;

				// The real laptop stays hidden while it is used straight from the inventory, so spawn a
				// networked stand-in model (the laptop's non-AE3 base class - same model, no simulation
				// or interactions) attached to the operator, so nearby and late-joining players see it
				// too. It is removed as soon as the session ends, the player dies, or the laptop is gone.
				// While packed, the laptop object sits hidden near the map origin. Anything that measures
				// range from the laptop (wifi scan, server connect, power scan) finds nothing there, so
				// carry the hidden object with the operator for the session and park it back afterwards.
				private _hidePos = getPosATL _laptop;
				_laptop setVariable ["AE3_laptop_hidePos", _hidePos, true];
				[_laptop, [player, [0, 0, -5]]] remoteExec ["attachTo", _laptop];

				[_laptop, player] remoteExec ["AE3_armaos_fnc_inventoryProp_spawn", 2];
				[_laptop] spawn {
					params ["_laptop"];
					waitUntil {
						sleep 0.5;
						isNull _laptop
						|| {!alive player}
						|| {(_laptop getVariable ["AE3_computer_mutex", objNull]) isNotEqualTo player}
					};
					[_laptop] remoteExec ["AE3_armaos_fnc_inventoryProp_remove", 2];
					if (!isNull _laptop) then {
						private _parkPos = _laptop getVariable ["AE3_laptop_hidePos", []];
						_laptop remoteExec ["detach", _laptop];
						if (_parkPos isNotEqualTo []) then {
							[_laptop, _parkPos] remoteExec ["setPosATL", _laptop];
						};
					};
				};

				if (_mode isEqualTo "cli") then {
					[_laptop] spawn AE3_armaos_fnc_terminal_init;
				} else {
					[_laptop] spawn AE3_desktop_fnc_desktop_openWeb;
				};
			};

			private _useAction =
			[
				"AE3_UseLaptopAction",
				localize "STR_AE3_ArmaOS_Laptop_Use",
				"",
				{},
				{
					// condition - stable mode + a held laptop that has a tracked object, or a fresh arsenal
					// laptop (which is packed into a tracked one the moment it is used)
					params ["_player"];
					if ((missionNamespace getVariable ["AE3_DeploymentType", 0]) != 0) exitWith { false };
					private _isFresh = missionNamespace getVariable ["AE3_armaos_isFreshLaptopItem", {false}];
					private _tracker = missionNamespace getVariable ["AE3_LAPTOP_STABLE_TRACKER", createHashMap];
					private _has = false;
					{
						if ((_x find "Item_Laptop_AE3_ID_" == 0 && {!isNull (_tracker getOrDefault [_x, objNull])}) || {[_x] call _isFresh}) exitWith { _has = true; };
					} forEach (items _player);
					_has
				},
				{
					// children - a Terminal and (when the desktop addon is present) a Desktop entry per laptop
					params ["_player"];
					private _isFresh = missionNamespace getVariable ["AE3_armaos_isFreshLaptopItem", {false}];
					private _tracker = missionNamespace getVariable ["AE3_LAPTOP_STABLE_TRACKER", createHashMap];
					private _hasDesktop = !isNil "AE3_desktop_fnc_desktop_openWeb";
					private _actions = [];

					{
						private _itemClass = _x;
						private _laptopObj = _tracker getOrDefault [_itemClass, objNull];
						private _fresh = [_itemClass] call _isFresh;
						if (((_itemClass find "Item_Laptop_AE3_ID_" == 0) && {!isNull _laptopObj}) || _fresh) then {
							private _laptopName = "";
							if (_fresh) then {
								_laptopName = getText (configFile >> "CfgWeapons" >> _itemClass >> "displayName");
							} else {
								private _idStr = _itemClass select [19];
								private _customName = _laptopObj getVariable ["AE3_laptop_customName", ""];
								_laptopName = if (_customName != "") then {
									format ["%1 (RootBook %2)", _customName, _idStr]
								} else {
									format ["RootBook %1", _idStr]
								};
							};

							private _cliChild = [
								format ["AE3_UseLaptopCli_%1", _itemClass],
								format ["%1 - %2", _laptopName, localize "STR_AE3_ArmaOS_Config_UseDisplayName"],
								"",
								{ params ["_target", "_player", "_params"]; _params spawn (missionNamespace getVariable ["AE3_armaos_useFromInventory", {}]); },
								{true},
								{},
								[_itemClass, "cli"]
							] call ace_interact_menu_fnc_createAction;
							_actions pushBack [_cliChild, [], _player];

							if (_hasDesktop) then {
								private _guiChild = [
									format ["AE3_UseLaptopGui_%1", _itemClass],
									format ["%1 - %2", _laptopName, localize "STR_AE3_Interaction_UseDesktop"],
									"",
									{ params ["_target", "_player", "_params"]; _params spawn (missionNamespace getVariable ["AE3_armaos_useFromInventory", {}]); },
									{true},
									{},
									[_itemClass, "gui"]
								] call ace_interact_menu_fnc_createAction;
								_actions pushBack [_guiChild, [], _player];
							};
						};
					} forEach (items _player);

					_actions
				}
			] call ace_interact_menu_fnc_createAction;

			// Expose the shared open routine to the per-laptop child statements.
			missionNamespace setVariable ["AE3_armaos_useFromInventory", _useFromInventory];

			["CAManBase", 1, ["ACE_SelfActions", "ACE_Equipment"], _useAction, true] call ace_interact_menu_fnc_addActionToClass;
		},
		[],
		0.5 // Delay to ensure ACE is fully loaded
	] call CBA_fnc_waitAndExecute;

	// Register event handlers for vanilla inventory operations (drag-and-drop)
	// This ensures laptops work correctly when dropped or transferred via inventory UI
	["Item_Laptop_AE3", "Put", {
		params ["_unit", "_container", "_item"];
		[_unit, _container, _item] call AE3_armaos_fnc_laptop_handlePut;
	}] call CBA_fnc_addItemEventHandler;

	["Item_Laptop_AE3", "Take", {
		params ["_unit", "_container", "_item"];
		[_unit, _container, _item] call AE3_armaos_fnc_laptop_handleTake;
	}] call CBA_fnc_addItemEventHandler;
};

/* ================================================================================ */
