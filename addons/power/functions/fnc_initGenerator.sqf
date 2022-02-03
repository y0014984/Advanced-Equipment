/**
 * Initializes a generator.
 * 
 * Arguments:
 * 0: Generator <OBJECT>
 *
 * Results:
 * None
*/

params['_entity', '_fuelCapacity', '_fuelConsumption', '_power', ['_fuelLevel', 1]];

_entity setFuel (_fuelLevel);
_entity setVariable ["AE3_fuelCapacity", _fuelCapacity];
_entity setVariable ["AE3_fuelLevel", _fuelCapacity * _fuelLevel];
_entity setVariable ["AE3_fuelConsumption", _fuelConsumption];
_entity setVariable ["AE3_powerMax", _power];
_entity setVariable ['AE3_connectedDevices', []];

private _check = ["AE3_PowerAction", "Check Fuel Level", "", 
				{params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_power_fnc_checkFuelLevelAction;}, 
				{alive _target}] call ace_interact_menu_fnc_createAction;

[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _check] call ace_interact_menu_fnc_addActionToObject;