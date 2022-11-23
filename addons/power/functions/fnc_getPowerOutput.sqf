/**
 * Returns device power output. Optional displays hint.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 1: Hint <BOOLEAN> (Optional)
 * 
 * Returns:
 * 0: Power Output <STRING>
 */

params ["_entity", ["_hint", false]];

// Update local copy of server var
[_entity, _hint] spawn
{
    params ["_entity", "_hint"];

    [_entity, "AE3_power_powerCapacity"] call AE3_main_fnc_getRemoteVar; 

    if (_hint) then
    {
        private _powerCap = _entity getVariable ['AE3_power_powerCapacity', 0];

        // Watts
        _powerCap = _powerCap * 3600 * 1000;
        
        hint format [localize "STR_AE3_Power_Interaction_PowerOutputHint", _powerCap];
    };
};

private _powerCap = _entity getVariable ['AE3_power_powerCapacity', 0];

// Watts
_powerCap = _powerCap * 3600 * 1000;

_powerCap;
