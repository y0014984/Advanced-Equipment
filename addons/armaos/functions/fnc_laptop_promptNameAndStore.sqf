/*
 * Author: Root
 * Description: Shows naming dialog and stores the result on the laptop object
 *
 * Arguments:
 * 0: _target <OBJECT> - The laptop object
 * 1: _id <NUMBER> - The laptop ID
 * 2: _player <OBJECT> - The player
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, 5, player] call AE3_armaos_fnc_laptop_promptNameAndStore;
 *
 * Public: No
 */

params ["_target", "_id", "_player"];

// Only run on the player's machine
if (player != _player) exitWith {};

// Show dialog and get name
private _defaultName = format ["Laptop_%1", _id];
private _customName = [_defaultName] call AE3_armaos_fnc_laptop_promptName;

// Store the custom name on the laptop object (sync to server)
_target setVariable ["AE3_laptop_customName", _customName, true];
