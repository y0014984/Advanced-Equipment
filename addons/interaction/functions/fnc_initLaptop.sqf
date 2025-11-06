/**
 * Initializes a laptop, especially the initially open/closed animation phase and the interaction menu.
 *
 * Arguments:
 * 0: Laptop <OBJECT>
 *
 * Returns:
 * None
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
    // Check if equipment action exists (set by fnc_initInteraction for laptops)
    private _hasEquipmentAction = _laptop getVariable ["AE3_interaction_hasEquipmentAction", false];
    private _parentPath = [];
    private _armaOSSubmenuPath = [];

    if (_hasEquipmentAction) then {
        // Nest under existing equipment action with ArmaOS submenu
        _parentPath = ["ACE_MainActions", "AE3_EquipmentAction"];

        // Create ArmaOS submenu
        private _armaOSSubmenu = ["AE3_ArmaOSSubmenu", localize "STR_AE3_ArmaOS_Config_ArmaOSDisplayName", "", {}, {true}] call ace_interact_menu_fnc_createAction;
        [_laptop, 0, _parentPath, _armaOSSubmenu] call ace_interact_menu_fnc_addActionToObject;

        _armaOSSubmenuPath = _parentPath + ["AE3_ArmaOSSubmenu"];
    } else {
        // Fallback for non-laptop objects (shouldn't happen, but defensive programming)
        private _armaOSAction = ["AE3_ArmaOSAction", localize "STR_AE3_ArmaOS_Config_ArmaOSDisplayName", "", {}, {true}] call ace_interact_menu_fnc_createAction;
        [_laptop, 0, ["ACE_MainActions"], _armaOSAction] call ace_interact_menu_fnc_addActionToObject;
        _armaOSSubmenuPath = ["ACE_MainActions", "AE3_ArmaOSAction"];
    };

    // add the 'use' interaction to the armaOS Menu
    private _useAction =
    [
        "AE3_UseAction", // internal name
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
    [_laptop, 0, _armaOSSubmenuPath, _useAction] call ace_interact_menu_fnc_addActionToObject; // 0 = action; 1 = self-action
};
