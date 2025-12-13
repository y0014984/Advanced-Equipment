/*
 * Author: Root, y0014984
 * Description: Initializes a lamp by switching it off and removing default ACE3 TurnOn/TurnOff interactions
 * (replaced with custom AE3 power-integrated lamp controls).
 *
 * Arguments:
 * 0: _entity <OBJECT> - The lamp object to initialize
 *
 * Return Value:
 * None
 *
 * Example:
 * [_lamp] call AE3_interaction_fnc_initLamp;
 *
 * Public: Yes
 */

params ["_entity"];

// Switch off the lamp on init
[_entity, false] call BIS_fnc_switchLamp;

// Remove default ACE3 interactions to turn on/off the light
[typeOf _entity, 0,["ACE_MainActions", "ace_interaction_TurnOff"]] call ace_interact_menu_fnc_removeActionFromClass;
[typeOf _entity, 0,["ACE_MainActions", "ace_interaction_TurnOn"]] call ace_interact_menu_fnc_removeActionFromClass;
