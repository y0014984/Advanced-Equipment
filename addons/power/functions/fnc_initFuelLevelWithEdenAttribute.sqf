/**
 * Sets the fuel level for a given generator if value is changed in Eden Editor.
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

    // wait until the eden attribute is set via expression; unset is -1; regular values should be between 0 and 1
    waitUntil { !(isNil {_generator getVariable "AE3_EdenAttribute_FuelLevel"}) };

    private _edenAttributeFuelLevel = _generator getVariable "AE3_EdenAttribute_FuelLevel";

    // wait until all "init" processes are done, see: https://community.bistudio.com/wiki/Initialization_Order
    waitUntil { !isNil "BIS_fnc_init" };

    // only set power level if changed in Eden Editor; -1 is default value
    if (_edenAttributeFuelLevel != -1) then
    {
        // apply min and max values
        if (_edenAttributeFuelLevel < 0) then { _edenAttributeFuelLevel = 0; };
        if (_edenAttributeFuelLevel > 1) then { _edenAttributeFuelLevel = 1; };

        // set fuel level
        _generator setFuel _edenAttributeFuelLevel;
    };
};