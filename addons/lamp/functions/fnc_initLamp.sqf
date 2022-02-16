/**
 * Initializes a lamp;
 *
 * Arguments:
 * 0: Lamp <OBJECT>
 *
 * Returns:
 * None
 */

// TODO: Find the right action class (https://github.com/acemod/ACE3/blob/master/addons/interaction/CfgVehicles.hpp)

params['_entity'];

[_entity, false] call BIS_fnc_switchLamp;

[_entity,0,['ACE_MainActions', 'ACE_interact_TurnOn']] remoteExecCall ['ace_interact_menu_fnc_removeActionFromObject', 0];
[_entity,0,['ACE_MainActions', 'ACE_interact_TurnOff']] remoteExecCall ['ace_interact_menu_fnc_removeActionFromObject', 0];