/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Returns the current power output of a generator or solar panel in Watts. Optionally displays a hint showing power output in kW or W. Power capacity is converted from kWh to instantaneous Watts.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Generator or solar panel object
 * 1: _hint <BOOL> - (Optional, default: false) Display hint with power output
 *
 * Return Value:
 * Power output in Watts <NUMBER>
 *
 * Example:
 * private _powerW = [_generator, true] call AE3_power_fnc_getPowerOutput;
 * private _solarOutput = [_solarPanel, false] call AE3_power_fnc_getPowerOutput;
 *
 * Public: Yes
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
        private _prefix = "k";

        // kWatts
        _powerCap = _powerCap * 3600;
        if (_powerCap < 1.0) then
        {
            _powerCap = _powerCap * 1000;
            _prefix = "";
        };
        
        hint format [localize "STR_AE3_Power_Interaction_PowerOutputHint", _powerCap, _prefix];
    };
};

private _powerCap = _entity getVariable ['AE3_power_powerCapacity', 0];

// Watts
_powerCap = _powerCap * 3600 * 1000;

_powerCap;
