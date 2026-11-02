// File: fnc_terminal_onChar.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Char / IMEChar handler for the terminal console control. Adds characters above
 * ASCII (any system keyboard layout or IME) to the input buffer. Keys already mapped by the
 * selected terminal layout are skipped.
 *
 * Arguments:
 * 0: _control <CONTROL> - The terminal output control
 * 1: _char <NUMBER> - Character code
 *
 * Return Value:
 * None
 *
 * Example:
 * _terminalCtrl ctrlAddEventHandler ["Char", { _this call AE3_armaos_fnc_terminal_onChar }];
 *
 * Public: No
 */

params ["_control", "_char"];

private _computer = _control getVariable ["AE3_computer", objNull];
if (isNull _computer) exitWith {};

private _terminal = _computer getVariable ["AE3_terminal", createHashMap];

if (_terminal getOrDefault ["AE3_terminalKeyMapped", false]) exitWith { _terminal set ["AE3_terminalKeyMapped", false]; };
if (_char < 128) exitWith {};

[_computer, toString [_char]] call AE3_armaos_fnc_terminal_addCharToInput;
_terminal deleteAt "AE3_autocompleteState";
