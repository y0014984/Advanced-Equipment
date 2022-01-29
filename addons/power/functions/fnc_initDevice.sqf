/**
 * Initializes a device.
 * 
 * Arguments:
 * 0: Device <OBJECT>
 * 1: Device name <STRING> (Optional)
 * 2: Powerstate (0 = off, 1 = on, n+1 = custom) <INT>  (Optional)
 * 3: Turn on function <CODE> (Optional)
 * 4: Turn off function <CODE> (Optional)
 *
 * Results:
 * None
*/

params ["_entity", ["_name", "Device"], ["_powerState", 0], ["_turnOnFnc", {}], ["_turnOffFnc", {}]];

_entity setVariable ["AE3_powerState", 0, true];

_entity setVariable ["AE3_power_fnc_turnOn", _turnOnFnc, true];
_entity setVariable ["AE3_power_fnc_turnOff", _turnOffFnc, true];

// Add check power state action
private _parentAction = ["AE3_DeviceAction", _name, "", {}, {true}] call ace_interact_menu_fnc_createAction;
private _power = ["AE3_PowerAction", "Check Power State", "", {[_target] call AE3_power_fnc_checkPowerStateAction}, {true}] call ace_interact_menu_fnc_createAction;

[_entity, 0, ["ACE_MainActions"], _parentAction] call ace_interact_menu_fnc_addActionToObject;
[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _power] call ace_interact_menu_fnc_addActionToObject;

// Add turn on/off action
if (!((_turnOnFnc isEqualTo {}) || (_turnOffFnc isEqualTo {}))) then
{
	
	_connect = ["AE3_TurnOnAction", "Turn On", "", 
				{params ['_target', '_player', '_params']; [_target] call _params}, 
				{(alive _target) and (_target getVariable 'AE3_powerState' != 1)},
				{},
				_turnOnFnc] call ace_interact_menu_fnc_createAction;

	_disconnect = ["AE3_TurnOffAction", "Turn Off", "", 
					{params ['_target', '_player', '_params']; [_target] call _params}, 
					{(alive _target) and (_target getVariable 'AE3_powerState' != 0)},
					{},
					_turnOffFnc] call ace_interact_menu_fnc_createAction;

	[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _connect] call ace_interact_menu_fnc_addActionToObject;
	[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _disconnect] call ace_interact_menu_fnc_addActionToObject;

};