/**
 * Sets the fuel level for a given generator if value is changed in Eden Editor. This will only work for an
 * entity that is placed in Eden Editor. In Zeus Mode, the variables are not set.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 * 
 * Returns:
 * None
 */

params ["_generator"];

[_generator] spawn
{
    params ["_generator"];

    // wait until all "init" processes are done, see: https://community.bistudio.com/wiki/Initialization_Order
    waitUntil { !isNil "BIS_fnc_init" };

    private _edenAttributeFuelLevel = _generator getVariable ["AE3_EdenAttribute_FuelLevel", nil];

    // var is nil if entity is set via zeus instead of eden editor
    if (!isNil "_edenAttributeFuelLevel") then
    {
        // only set power level if changed in Eden Editor; -1 is default value
        // unset is -1; regular values should be between 0 and 1
        if (_edenAttributeFuelLevel != -1) then
        {
            // apply min and max values
            if (_edenAttributeFuelLevel < 0) then { _edenAttributeFuelLevel = 0; };
            if (_edenAttributeFuelLevel > 1) then { _edenAttributeFuelLevel = 1; };

            // set fuel level
            _generator setFuel _edenAttributeFuelLevel;
        };
    };
};