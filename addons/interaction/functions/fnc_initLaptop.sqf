/*
 * Author: Root, y0014984
 * Description: Initializes a laptop by setting the open/closed animation state and adding the "Use Terminal"
 * ACE3 interaction. This function checks the laptop's mutex (AE3_computer_mutex) to prevent concurrent
 * terminal access.
 *
 * Arguments:
 * 0: _laptop <OBJECT> - The laptop object to initialize
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop] call AE3_interaction_fnc_initLaptop;
 *
 * Public: Yes
 */

params["_laptop"];

if (AE3_DebugMode) then {
	// DEBUG: Log EVERY call to initLaptop with stack trace and timestamp
	diag_log format ["[AE3 DEBUG] [%1] ========== initLaptop CALLED on %2 ==========", time, _laptop];
	diag_log format ["[AE3 DEBUG] [%1] Call stack: %2", time, diag_stacktrace];
};

// init the open/close state of the laptop
if (_laptop getVariable "AE3_interaction_closeState" == 1) then
{
    [_laptop] call (_laptop getVariable "AE3_interaction_fnc_close");
}
else
{
    [_laptop] call (_laptop getVariable "AE3_interaction_fnc_open");
};

if(!isDedicated) then
{
    // Check if laptop-specific interactions have already been added
    // This prevents duplicate actions when laptop is deployed from inventory
    private _laptopActionsAdded = _laptop getVariable ["AE3_interaction_laptopActionsAdded", false];

    // Declare outside if block so it's available in nested debug blocks
    private _actionsBeforeCount = 0;

    if (AE3_DebugMode) then {
        // DEBUG: Log laptop action attempts with full details
        diag_log format ["[AE3 DEBUG] [%1] ===== initLaptop processing interactions on %2 (type: %3) | laptopActionsAdded: %4 =====", time, _laptop, typeOf _laptop, _laptopActionsAdded];

        // DEBUG: Check ALL flag states to see what's already set
        private _equipmentFlag = _laptop getVariable ["AE3_interaction_equipmentActionsAdded", "UNDEFINED"];
        private _hasEquipmentFlag = _laptop getVariable ["AE3_interaction_hasEquipmentAction", "UNDEFINED"];
        private _powerFlag = _laptop getVariable ["AE3_power_actionsAdded", "UNDEFINED"];
        diag_log format ["[AE3 DEBUG] [%1] Current flag states: laptop=%2 | equipment=%3 | hasEquipment=%4 | power=%5", time, _laptopActionsAdded, _equipmentFlag, _hasEquipmentFlag, _powerFlag];

        // DEBUG: Count ACE actions before we do anything
        private _existingActionsBefore = _laptop getVariable ["ace_interact_menu_Act_SelfActions", []];
        if (_existingActionsBefore isEqualType []) then {
            _actionsBeforeCount = count _existingActionsBefore;
        };
        diag_log format ["[AE3 DEBUG] [%1] ACE actions on laptop BEFORE initLaptop processing: %2", time, _actionsBeforeCount];
    };

    if (!_laptopActionsAdded) then {
        // Mark that we're adding the actions IMMEDIATELY to prevent race conditions
        if (AE3_DebugMode) then {
            diag_log format ["[AE3 DEBUG] [%1] initLaptop: SETTING laptopActionsAdded flag to TRUE for %2", time, _laptop];
        };
        _laptop setVariable ["AE3_interaction_laptopActionsAdded", true];
        if (AE3_DebugMode) then {
            diag_log format ["[AE3 DEBUG] [%1] Adding laptop-specific actions (Use Terminal, Pickup) for %2", time, _laptop];
        };

        // Check if equipment action exists (set by fnc_initInteraction for laptops)
        private _hasEquipmentAction = _laptop getVariable ["AE3_interaction_hasEquipmentAction", false];
        private _parentPath = ["ACE_MainActions", "AE3_EquipmentAction"];

        if (!_hasEquipmentAction) then {
            // Fallback: shouldn't happen for laptops, but defensive programming
            _parentPath = ["ACE_MainActions"];
        };

        // Add "Use Terminal" action directly under Laptop action (no submenu)
        private _useAction =
        [
            "AE3_UseTerminalAction", // internal name
            localize "STR_AE3_ArmaOS_Config_UseDisplayName", // visible name
            "", // icon
            {
                // statement
                params ["_target", "_player", "_params"];

                _target setVariable ["AE3_computer_mutex", _player, true];
                _handle = [_target] spawn AE3_armaos_fnc_terminal_init;
            },
            {
                // condition
                params ["_target", "_player", "_params"];

                (alive _target) && (_target getVariable "AE3_power_powerState" == 1) &&
                (isNull (_target getVariable ["AE3_computer_mutex", objNull]))
            }
        ] call ace_interact_menu_fnc_createAction;
        [_laptop, 0, _parentPath, _useAction] call ace_interact_menu_fnc_addActionToObject;
        if (AE3_DebugMode) then {
            diag_log format ["[AE3 DEBUG] [%1] Added Use Terminal action for %2 under path: %3", time, _laptop, _parentPath];
        };

        // Add "Pickup to Inventory" action
        private _pickupAction =
        [
            "AE3_PickupLaptopAction", // internal name
            localize "STR_AE3_ArmaOS_Laptop_Pickup", // visible name
            "\a3\ui_f\data\igui\cfg\actions\take_ca.paa", // icon
            {
                // statement
                params ["_target", "_player", "_params"];

                // Check deployment type setting: 0 = Stable, 1 = Experimental
                private _deploymentType = missionNamespace getVariable ["AE3_DeploymentType", 0];

                if (_deploymentType == 0) then {
                    // Stable mode - use stable pickup
                    [_target, _player] remoteExec ["AE3_armaos_fnc_laptop_pickup_stable", 2];
                } else {
                    // Experimental mode - use experimental pickup
                    [_target, _player] remoteExec ["AE3_armaos_fnc_laptop_pickup", 2];
                };
            },
            {
                // condition - only when not in use
                params ["_target", "_player", "_params"];
                (alive _target) && (isNull (_target getVariable ["AE3_computer_mutex", objNull]))
            }
        ] call ace_interact_menu_fnc_createAction;
        [_laptop, 0, _parentPath, _pickupAction] call ace_interact_menu_fnc_addActionToObject;
        if (AE3_DebugMode) then {
            diag_log format ["[AE3 DEBUG] [%1] Added Pickup action for %2", time, _laptop];

            // DEBUG: Count ACE actions after adding laptop-specific actions
            private _actionsAfterCount = 0;
            private _existingActionsAfter = _laptop getVariable ["ace_interact_menu_Act_SelfActions", []];
            if (_existingActionsAfter isEqualType []) then {
                _actionsAfterCount = count _existingActionsAfter;
            };
            diag_log format ["[AE3 DEBUG] [%1] ACE actions on laptop AFTER adding laptop actions: %2 (added %3 actions)", time, _actionsAfterCount, _actionsAfterCount - _actionsBeforeCount];
        };
    } else {
        if (AE3_DebugMode) then {
            diag_log format ["[AE3 DEBUG] [%1] Laptop actions already added for %2, skipping", time, _laptop];

            // DEBUG: Count actions even when skipping to detect duplicates
            private _actionsCount = 0;
            private _existingActions = _laptop getVariable ["ace_interact_menu_Act_SelfActions", []];
            if (_existingActions isEqualType []) then {
                _actionsCount = count _existingActions;
            };
            diag_log format ["[AE3 DEBUG] [%1] Current ACE actions on laptop: %2", time, _actionsCount];
        };
    };
};
