// File: fnc_laptop_item2obj.sqf
/*
 * Author: Root
 * Description: Converts a laptop inventory item back to a world object, restoring all state.
 *
 * Arguments:
 * 0: _player <OBJECT> - The player deploying the laptop
 * 1: _item <STRING> - The item class name (e.g., "Item_Laptop_AE3_ID_1")
 * 2: _pos <ARRAY> (Optional) - Position to deploy at, defaults to player position
 *
 * Return Value:
 * <OBJECT> - The created laptop object, objNull if failed
 *
 * Example:
 * [player, "Item_Laptop_AE3_ID_1"] call AE3_armaos_fnc_laptop_item2obj;
 * [player, "Item_Laptop_AE3_ID_1", [0, 0, 0]] call AE3_armaos_fnc_laptop_item2obj;
 *
 * Public: No
 */

params ["_player", "_item", ["_pos", [], [[]]]];

// Sync item data from server if needed
[missionNamespace, "AE3_LAPTOP_ITEM"] call AE3_main_fnc_getRemoteVar;
private _buffer = missionNamespace getVariable ["AE3_LAPTOP_ITEM", createHashMap];

// A base laptop item taken from the arsenal or a loadout (scopeArsenal != 0) was never a world object,
// so it has no buffer entry. Spawn a fresh laptop from its paired object class instead of refusing:
// the normal object init seeds its filesystem and battery. The per-instance ID classes (scopeArsenal = 0)
// always carry a buffer entry and take the restore path below.
private _isFreshItem = !(_item in _buffer)
	&& {(getNumber (configFile >> "CfgWeapons" >> _item >> "scopeArsenal")) != 0}
	&& {(getText (configFile >> "CfgWeapons" >> _item >> "ae3_vehicle")) isNotEqualTo ""};

if (!(_item in _buffer) && {!_isFreshItem}) exitWith {
	hint "Laptop data not found. Item may be corrupted.";
	objNull
};

// Determine deployment position. Terrain height is not the surface a player is standing on once they are
// inside a building, so the floor in front of them is looked for instead: a laptop deployed on an upper
// storey is put down on that storey rather than dropped towards the ground under the building.
if (_pos isEqualTo []) then {
	_pos = [_player] call AE3_armaos_fnc_laptop_deployPos;
};

if (_isFreshItem) exitWith {
	private _objType = getText (configFile >> "CfgWeapons" >> _item >> "ae3_vehicle");
	private _fresh = createVehicle [_objType, _pos, [], 0, "CAN_COLLIDE"];
	_fresh setDir (getDir _player);
	[_player, _item] remoteExecCall ["CBA_fnc_removeItem", _player];
	_fresh
};

private _itemNamespace = _buffer get _item;
// A buffer written by an older version, or one that lost the entry, has no type to build from. Reading
// it with a default keeps the missing case as an empty string, which the check below reports.
private _type = _itemNamespace getOrDefault ["AE3_OBJECT_TYPE", ""];
if !(_type isEqualType "") then { _type = ""; };

if (_type isEqualTo "") exitWith {
	hint "Laptop type data missing. Cannot deploy.";
	objNull
};

if (AE3_DebugMode) then {
	// DEBUG: Log pre-creation state with timestamp
	diag_log format ["[AE3 DEBUG] [%1] ========== laptop_item2obj: ABOUT TO CREATE VEHICLE ==========", time];
	diag_log format ["[AE3 DEBUG] [%1] Call stack: %2", time, diag_stacktrace];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Type: %2 | Pos: %3", time, _type, _pos];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Calling createVehicle NOW...", time];
};

// Create the laptop object
private _object = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];

// CRITICAL: Set restoration flag IMMEDIATELY (before any delays)
// This flag tells init code not to overwrite the restored power state
// Must be set before init handlers complete their execution
_object setVariable ["AE3_laptop_restored", true, true];

// Small delay to allow init events to fire
sleep 0.05;

// Count ACE actions immediately after creation (for debug logging later)
private _actionsPostCreate = 0;
private _existingActionsPostCreate = _object getVariable ["ace_interact_menu_Act_SelfActions", []];
if (_existingActionsPostCreate isEqualType []) then {
	_actionsPostCreate = count _existingActionsPostCreate;
};

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: createVehicle returned, object = %2", time, _object];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: After 50ms delay post-creation", time];

	// DEBUG: Check flag state immediately after creation, before any restoration
	private _flagCheck1 = _object getVariable ["AE3_interaction_laptopActionsAdded", "UNDEFINED"];
	private _flagCheck2 = _object getVariable ["AE3_interaction_equipmentActionsAdded", "UNDEFINED"];
	private _flagCheck3 = _object getVariable ["AE3_power_actionsAdded", "UNDEFINED"];
	private _flagCheck4 = _object getVariable ["AE3_interaction_hasEquipmentAction", "UNDEFINED"];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: POST-CREATE flag check: laptop=%2 | equipment=%3 | power=%4 | hasEquipment=%5", time, _flagCheck1, _flagCheck2, _flagCheck3, _flagCheck4];

	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: ACE actions immediately after createVehicle: %2", time, _actionsPostCreate];
};

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Set restoration flag to TRUE", time];

	// DEBUG: Log restoration process
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Restoring laptop from item %2 to object %3", time, _item, _object];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Will restore %2 variables from saved data", time, count _itemNamespace];

	// DEBUG: Check if critical flags are in the saved data (they should NOT be!)
	private _criticalFlags = ["AE3_interaction_laptopActionsAdded", "AE3_interaction_equipmentActionsAdded", "AE3_power_actionsAdded", "AE3_interaction_hasEquipmentAction"];
	{
		private _flagName = _x;
		if (_flagName in _itemNamespace) then {
			diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: !!!!! WARNING! Flag %2 found in saved data, will be restored !!!!!", time, _flagName];
		} else {
			diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Flag %2 NOT in saved data (correct)", time, _flagName];
		};
	} forEach _criticalFlags;
};

// Restore all variables from item namespace
private _restoredCount = 0;
if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: ===== STARTING variable restoration loop =====", time];
};

// CRITICAL: Double-check exclusion list to prevent restoring variables that contain TEXT or runtime state
// This protects against old data in the buffer that was saved before exclusion list was updated
private _excludedVarsRestore = [
	"AE3_terminal",                 // HashMap containing TEXT
	"AE3_terminalRenderedBuffer",  // Contains TEXT
	"AE3_terminalDialog",           // Display reference
	"AE3_Links",                    // Command links
	"AE3_computer_mutex",           // Runtime lock
	"AE3_laptop_restored",          // Restoration flag
	"AE3_UiOnTexActive",            // Runtime UI-on-Texture flag
	"AE3_UiOnTexDisplayName",       // Runtime UI-on-Texture display name
	"AE3_interaction_hasEquipmentAction",  // Runtime ACE interaction flag
	"AE3_interaction_laptopActionsAdded",  // Runtime flag
	"AE3_interaction_equipmentActionsAdded",  // Runtime flag
	"AE3_power_actionsAdded",       // Runtime flag
	"AE3_power_powerState",         // Power state - always start OFF
	"AE3_power_powerDraw",          // Runtime power draw
	// All CODE references - will be regenerated by init
	"AE3_interaction_fnc_open",
	"AE3_interaction_fnc_close",
	"AE3_interaction_fnc_openWrapper",
	"AE3_interaction_fnc_closeWrapper",
	"AE3_interaction_fnc_openActionCondition",
	"AE3_interaction_fnc_closeActionCondition",
	"AE3_power_fnc_turnOn",
	"AE3_power_fnc_turnOff",
	"AE3_power_fnc_standby",
	"AE3_power_fnc_turnOnWrapper",
	"AE3_power_fnc_turnOffWrapper",
	"AE3_power_fnc_standbyWrapper",
	"AE3_power_fnc_turnOnCondition",
	"AE3_power_fnc_turnOffCondition",
	"AE3_power_fnc_standbyCondition"
];

{
	if (!(_x in ["AE3_OBJECT_TYPE", "AE3_ORIGINAL_POS", "AE3_ORIGINAL_DIR"]) && !(_x in _excludedVarsRestore)) then {
		private _value = _y;
		if (!isNil "_value") then {
			if (AE3_DebugMode) then {
				// DEBUG: Log ALL variables that look like action flags
				if (_x find "Action" >= 0 || _x find "action" >= 0) then {
					diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Restoring action-related var: %2 = %3", time, _x, _value];
				};
				// DEBUG: Log critical flags being restored
				if (_x in ["AE3_interaction_laptopActionsAdded", "AE3_interaction_equipmentActionsAdded", "AE3_power_actionsAdded", "AE3_interaction_hasEquipmentAction"]) then {
					diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: !!!!! ERROR! Restoring runtime flag %2 = %3 (THIS SHOULD NOT HAPPEN) !!!!!", time, _x, _value];
				};
			};
			_object setVariable [_x, _value, true]; // Broadcast to all clients
			_restoredCount = _restoredCount + 1;
		};
	} else {
		if (AE3_DebugMode && (_x in _excludedVarsRestore)) then {
			diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: SKIPPING excluded variable during restoration: %2 (protects against old buffer data)", time, _x];
		};
	};
} forEach _itemNamespace;

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: ===== FINISHED variable restoration loop =====", time];

	// DEBUG: Check flag state after restoration
	private _flagCheckAfter1 = _object getVariable ["AE3_interaction_laptopActionsAdded", "UNDEFINED"];
	private _flagCheckAfter2 = _object getVariable ["AE3_interaction_equipmentActionsAdded", "UNDEFINED"];
	private _flagCheckAfter3 = _object getVariable ["AE3_power_actionsAdded", "UNDEFINED"];
	private _flagCheckAfter4 = _object getVariable ["AE3_interaction_hasEquipmentAction", "UNDEFINED"];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: POST-RESTORE flag check: laptop=%2 | equipment=%3 | power=%4 | hasEquipment=%5", time, _flagCheckAfter1, _flagCheckAfter2, _flagCheckAfter3, _flagCheckAfter4];

	// DEBUG: Count ACE actions after restoration
	private _actionsPostRestore = 0;
	private _existingActionsPostRestore = _object getVariable ["ace_interact_menu_Act_SelfActions", []];
	if (_existingActionsPostRestore isEqualType []) then {
		_actionsPostRestore = count _existingActionsPostRestore;
	};
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: ACE actions after restoration: %2 (delta from post-create: %3)", time, _actionsPostRestore, _actionsPostRestore - _actionsPostCreate];

	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Restored %2 variables to object", time, _restoredCount];
};

// Restore orientation if available
private _originalDir = _itemNamespace getOrDefault ["AE3_ORIGINAL_DIR", getDir _player];
_object setDir _originalDir;

// CRITICAL: Ensure laptop is in proper state when deployed
// Power state was excluded from save, so it needs to be explicitly set here
// Close state should always be OPEN (0) when deployed for usability
if (isServer) then {
	_object setVariable ["AE3_power_powerState", 0, true]; // OFF state
	_object setVariable ["AE3_interaction_closeState", 0, true]; // OPEN state (lid open)
};

// Set texture to OFF state (procedural black texture)
private _offTexture = "#(argb,8,8,3)color(0,0,0,0.0,co)";
_object setObjectTextureGlobal [1, _offTexture];

// Apply any charge accumulated while this laptop was carried in inventory after its internal
// battery has been created by the normal device initialization path.
private _storedCharge = _itemNamespace getOrDefault ["ROOT_EWO_BATTERY_PERCENT", -1];
private _internalBattery = _object getVariable ["AE3_power_internal", objNull];
if (_storedCharge >= 0 && {!isNull _internalBattery}) then {
    [_internalBattery, _storedCharge] remoteExecCall ["AE3_power_fnc_setBatteryLevel", 2];
};

if (AE3_DebugMode) then {
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Set power state to OFF, close state to OPEN, and texture to OFF state", time];
};

// Remove item from player inventory
[_player, _item] remoteExecCall ["CBA_fnc_removeItem", _player];

// Reattach the removable drives that travelled with this laptop. The drive items remain normal
// inventory items while the laptop is packed, so reconnecting them uses the same authoritative
// conversion and mount path as an ACE interaction.
private _savedDrives = _itemNamespace getOrDefault ["AE3_laptop_connectedDrives", []];
private _interfaces = _object getVariable ["AE3_USB_Interfaces", createHashMap];
{
    _x params ["_interface", "_driveItem", ["_wasMounted", false]];
    private _cfg = _interfaces getOrDefault [_interface, []];
    if (_cfg isNotEqualTo [] && {_driveItem in (items _player)}) then {
        [_object, _player, _driveItem, _cfg] call AE3_flashdrive_fnc_connectFlashDrive;
        if (!_wasMounted) then {
            [_object, _interface] remoteExecCall ["AE3_flashdrive_fnc_unmount", 2];
        };
    };
} forEach _savedDrives;

// No deployment hint needed

if (AE3_DebugMode) then {
	// DEBUG: Final state check after everything
	diag_log format ["[AE3 DEBUG] [%1] ========== laptop_item2obj: DEPLOYMENT COMPLETE ==========", time];
	private _finalFlags = format ["laptop=%1 | equipment=%2 | power=%3 | hasEquipment=%4",
		_object getVariable ["AE3_interaction_laptopActionsAdded", "UNDEFINED"],
		_object getVariable ["AE3_interaction_equipmentActionsAdded", "UNDEFINED"],
		_object getVariable ["AE3_power_actionsAdded", "UNDEFINED"],
		_object getVariable ["AE3_interaction_hasEquipmentAction", "UNDEFINED"]
	];
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Final flag states: %2", time, _finalFlags];

	private _actionsFinal = 0;
	private _existingActionsFinal = _object getVariable ["ace_interact_menu_Act_SelfActions", []];
	if (_existingActionsFinal isEqualType []) then {
		_actionsFinal = count _existingActionsFinal;
	};
	diag_log format ["[AE3 DEBUG] [%1] laptop_item2obj: Final ACE action count: %2", time, _actionsFinal];
};

// Return the created object
_object
