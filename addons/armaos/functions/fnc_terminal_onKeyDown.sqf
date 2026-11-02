// File: fnc_terminal_onKeyDown.sqf
#include "..\script_component.hpp"
#include "\a3\ui_f\hpp\definedikcodes.inc"
/*
 * Author: Root
 * Description: KeyDown handler for the terminal console control. Dispatches typing, editing,
 * history, autocomplete, scrolling/zoom and command execution.
 *
 * Arguments:
 * 0: _displayorcontrol <CONTROL> - The terminal output control
 * 1: _key <NUMBER> - DIK code
 * 2: _shift <BOOL>
 * 3: _ctrl <BOOL>
 * 4: _alt <BOOL>
 *
 * Return Value:
 * Whether the key event is consumed <BOOL>
 *
 * Example:
 * _terminalCtrl ctrlAddEventHandler ["KeyDown", { _this call AE3_armaos_fnc_terminal_onKeyDown }];
 *
 * Public: No
 */

params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

private _computer = _displayorcontrol getVariable "AE3_computer";
private _terminal = _computer getVariable "AE3_terminal";
private _terminalApplication = _terminal get "AE3_terminalApplication";
private _terminalAllowedKeys = _terminal get "AE3_terminalAllowedKeys";

_terminal set ["AE3_terminalScrollPosition", 0];

private _keyCombination = format ["%1-%2-%3-%4", _key, _shift, _ctrl, _alt];

/* ---------------------------------------- */

// SIG INT
if (_key isEqualTo DIK_C && _ctrl && !_shift && !_alt) then
{
	private _process = _terminal get "AE3_terminalProcess";
	if (!(isNil "_process")) then
	{
		if (!(isNull _process)) then
		{
			terminate _process;
		}
	}
};

_terminal set ["AE3_terminalKeyMapped", _keyCombination in _terminalAllowedKeys];

if (_keyCombination in _terminalAllowedKeys) then
{
	private _keyChar = _terminalAllowedKeys get _keyCombination;

	[_computer, _keyChar] call AE3_armaos_fnc_terminal_addCharToInput;

	// Clear autocomplete state when typing
	_terminal deleteAt "AE3_autocompleteState";
};

/* ---------------------------------------- */

if (_key isEqualTo DIK_BACKSPACE) then
{
	[_computer] call AE3_armaos_fnc_terminal_removeCharFromInput;

	// Clear autocomplete state when deleting
	_terminal deleteAt "AE3_autocompleteState";
};

/* ---------------------------------------- */

if (_key isEqualTo DIK_TAB) then
{
	if (_terminalApplication == "SHELL") then
	{
		[_computer] call AE3_armaos_fnc_terminal_autocomplete;
	};
};

/* ---------------------------------------- */

if ((_key isEqualTo DIK_RETURN) || (_key isEqualTo DIK_NUMPADENTER)) then
{
	private _input = [_computer] call AE3_armaos_fnc_terminal_getInput;

	[_terminal, _terminalApplication, _computer, _displayorcontrol, _input] call
	{
		params ['_terminal', '_terminalApplication', '_computer', '_displayorcontrol', '_input'];

		if (_terminalApplication isEqualTo "LOGIN") exitWith
		{
			_terminal deleteAt "AE3_terminalInputBuffer";
			[_computer, _input] call AE3_armaos_fnc_terminal_appendLine;

			[_computer, _input] call AE3_armaos_fnc_shell_findLoginUser;
		};
		if (_terminalApplication isEqualTo "PASSWORD") exitWith
		{
			_terminal deleteAt "AE3_terminalInputBuffer";
			[_computer, _input regexReplace [".", "*"]] call AE3_armaos_fnc_terminal_appendLine;

			[_computer, _input] call AE3_armaos_fnc_shell_validatePassword;
		};
		if (_terminalApplication isEqualTo "INPUT") exitWith
		{
			[_computer, ""] call AE3_armaos_fnc_terminal_setInputMode;
			[_computer, _input] call AE3_armaos_fnc_terminal_appendLine;
		};
		if (_terminalApplication isEqualTo "SHELL") exitWith
		{
			_terminal deleteAt "AE3_terminalInputBuffer";
			[_computer, _input] call AE3_armaos_fnc_terminal_appendLine;
			[_computer, _displayorcontrol] call AE3_armaos_fnc_terminal_updateOutput;

			[_computer, _input] spawn AE3_armaos_fnc_shell_process;
		};
	};

};

/* ---------------------------------------- */

if ((_key isEqualTo DIK_UPARROW) || (_key isEqualTo DIK_DOWNARROW)) then
{
	if (_terminalApplication == "SHELL") then
	{
		[_computer, _key] call AE3_armaos_fnc_terminal_setCommandLineByHistory;
	};
};

if (_key isEqualTo DIK_RIGHTARROW) then {[_computer, true] call AE3_armaos_fnc_terminal_shiftInputBuffer;};
if (_key isEqualTo DIK_LEFTARROW) then {[_computer, false] call AE3_armaos_fnc_terminal_shiftInputBuffer;};

if (_key isEqualTo DIK_END) then {[_computer, true, true] call AE3_armaos_fnc_terminal_shiftInputBuffer;};
if (_key isEqualTo DIK_HOME) then {[_computer, false, true] call AE3_armaos_fnc_terminal_shiftInputBuffer;};

if (_ctrl && _key isEqualTo DIK_ADD) then
{
	private _size = _terminal get "AE3_terminalSize";
	if (_size + 0.05 <= 1.0) then
	{
		_terminal set ["AE3_terminalSize", _size + 0.05];
		[_computer] call AE3_armaos_fnc_terminal_reRenderBuffer;
	};
};

if (_ctrl && _key isEqualTo DIK_SUBTRACT) then
{
	private _size = _terminal get "AE3_terminalSize";
	if (_size - 0.05 >= 0.5) then
	{
		_terminal set ["AE3_terminalSize", _size - 0.05];
		[_computer] call AE3_armaos_fnc_terminal_reRenderBuffer;
	};
};

/* ---------------------------------------- */

[_computer, _displayorcontrol] call AE3_armaos_fnc_terminal_updateOutput;

// Check if Arsenal or other high-priority dialogs are open
// Display 602 = ACE Arsenal, Display 312 = Virtual Arsenal, Display 49 = Escape Menu
private _arsenalOpen = !(isNull findDisplay 602) || !(isNull findDisplay 312);
private _escMenuOpen = !(isNull findDisplay 49);

// If high-priority dialogs are open, don't intercept keys - let them handle input
if (_arsenalOpen || _escMenuOpen) exitWith { false };

// Otherwise intercept to prevent default actions (eg. pressing escape won't close the terminal dialog)
true
