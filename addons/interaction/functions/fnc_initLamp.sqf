/**
 * Initializes a lamp;
 *
 * Arguments:
 * 0: Lamp <OBJECT>
 *
 * Returns:
 * None
 */

params ["_entity"];

// Switch off the lamp on init
[_entity, false] call BIS_fnc_switchLamp;

// Remove default ACE3 interactions to turn on/off the light
[typeOf _entity, 0,["ACE_MainActions", "ace_interaction_TurnOff"]] call ace_interact_menu_fnc_removeActionFromClass;
[typeOf _entity, 0,["ACE_MainActions", "ace_interaction_TurnOn"]] call ace_interact_menu_fnc_removeActionFromClass;
