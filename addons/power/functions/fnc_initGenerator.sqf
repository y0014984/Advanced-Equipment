/**
 * Initializes a generator.
 * 
 * Arguments:
 * 0: Generator <OBJECT>
 * 1: Fuel Capacity <NUMBER>
 * 2: Fuel Consumption <NUMBER>
 * 3: Power Output <NUMBER>
 * 4: Fuel Level <NUMBER> (Optional)
 *
 * Results:
 * None
*/

params['_entity', '_fuelCapacity', '_fuelConsumption', '_power', ['_fuelLevel', 1]];

if(!isDedicated) then
{
	private _check = ["AE3_PowerAction", "Check Fuel Level", "", 
				{params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_power_fnc_checkFuelLevelAction;}, 
				{alive _target}] call ace_interact_menu_fnc_createAction;

	[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _check] call ace_interact_menu_fnc_addActionToObject;
};

if(isServer) then
{
	_entity setFuel (_fuelLevel);
	_entity setVariable ["AE3_fuelCapacity", _fuelCapacity, true];
	_entity setVariable ["AE3_fuelLevel", _fuelCapacity * _fuelLevel, true];
	_entity setVariable ["AE3_fuelConsumption", _fuelConsumption, true];
	_entity setVariable ["AE3_powerMax", _power, true];
	_entity setVariable ['AE3_connectedDevices', [], true];
};