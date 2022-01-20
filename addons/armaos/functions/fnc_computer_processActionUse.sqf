/**
 * Gets triggered by ACE action defined in the config of the computer object. Calls the terminal init fuction.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

[_computer] call AE3_armaos_fnc_terminal_init;