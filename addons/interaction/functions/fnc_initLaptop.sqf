/*
 * Author: Root
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

    if (!_laptopActionsAdded) then {
        // Mark that we're adding the actions
        _laptop setVariable ["AE3_interaction_laptopActionsAdded", true];

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

        // Add "Pickup to Inventory" action
        private _pickupAction =
        [
            "AE3_PickupLaptopAction", // internal name
            localize "STR_AE3_ArmaOS_Laptop_Pickup", // visible name
            "\a3\ui_f\data\igui\cfg\actions\take_ca.paa", // icon
            {
                // statement
                params ["_target", "_player", "_params"];
                // Execute pickup function on server using spawn for scheduled environment
                [_target, _player] remoteExec ["AE3_armaos_fnc_laptop_pickup", 2];
            },
            {
                // condition - only when not in use
                params ["_target", "_player", "_params"];
                (alive _target) && (isNull (_target getVariable ["AE3_computer_mutex", objNull]))
            }
        ] call ace_interact_menu_fnc_createAction;
        [_laptop, 0, _parentPath, _pickupAction] call ace_interact_menu_fnc_addActionToObject;
    };
};
