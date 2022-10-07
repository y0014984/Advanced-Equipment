/**
 * Initializes the terminal of a given computer by showing the terminal window, initializing terminal settings and adding event handlers.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

#include "\a3\ui_f\hpp\definedikcodes.inc"

params ["_computer"];

if (!dialog) then
{
	private _ok = createDialog "AE3_ArmaOS_Main_Dialog";
	if (!_ok) then {hint "Dialog couldn't be opened!"};
};

private _consoleDialog = findDisplay 15984;	
private _consoleOutput = _consoleDialog displayCtrl 1100;
private _languageButton = _consoleDialog displayCtrl 1310;

/*
private _handle = [_computer] spawn AE3_power_fnc_showBatteryLevel;

private _ip = _computer getVariable ["AE3_ipAddress", "127.0.0.1"];

_consoleInput setVariable ["ip", _ip];
*/

private _filesystem = _computer getVariable "AE3_filesystem";

private _pointer = [];
if (isNil { _computer getVariable "AE3_filepointer" }) then 
{
	_computer setVariable ["AE3_filepointer", _pointer, true];
};
_pointer = _computer getVariable "AE3_filepointer";

private _terminal = createHashMapFromArray
	[
		["AE3_terminalBuffer", []],
		["AE3_terminalBufferVisable", []],
		["AE3_terminalScrollPosition", 0],
		["AE3_terminalCursorLine", 0],
		["AE3_terminalCursorPosition", 0],
		["AE3_terminalCommandHistory", []],
		["AE3_terminalCommandHistoryIndex", -1],
		["AE3_terminalComputer", _computer],
		["AE3_terminalPrompt", "/>"],
		["AE3_terminalApplication", "LOGIN"],
		["AE3_terminalMaxRows", 21],
		["AE3_terminalMaxColumns", 85],
		["AE3_terminalKeyboardLayout", "US"]
	];

// Only nessecary to allow Event Handlers the access to _computer
_consoleOutput setVariable ["AE3_computer", _computer];
_consoleDialog setVariable ["AE3_computer", _computer];

if (isNil { _computer getVariable "AE3_terminal" }) then 
{
	_computer setVariable ["AE3_terminal", _terminal, true];
};
_terminal = _computer getVariable "AE3_terminal";

_terminal set ["AE3_terminalOutput", _consoleOutput];

private _localGameLanguage = language;
// we can determine the language of arma 3 but not the language of the keyboard layout
// if the language is german, it's obvious, that the keyboard layout is also german (this is not the case, if game language is english)
// perhaps we need to provide a CBA setting for changing keyboard layout or allow to change the layout directly in the terminal window

private _terminalKeyboardLayout = _terminal get "AE3_terminalKeyboardLayout";

[_computer, _languageButton, _consoleOutput, _terminalKeyboardLayout] call AE3_armaos_fnc_terminal_setKeyboardLayout;

[_consoleDialog, _consoleOutput, _languageButton] call AE3_armaos_fnc_terminal_addEventHandler;

_terminalBuffer = _terminal get "AE3_terminalBuffer";
if (_terminalBuffer isEqualTo []) then
{
	[_computer] call AE3_armaos_fnc_terminal_addHeader;
	
	private _terminalApplication = _terminal get "AE3_terminalApplication";
	if (_terminalApplication == "LOGIN") then
	{
		_terminal set ["AE3_terminalPrompt", "LOGIN>"];
	}
	else 
	{
		[_computer] call AE3_armaos_fnc_terminal_updatePromptPointer;
	};
	[_computer] call AE3_armaos_fnc_terminal_setPrompt;
};

[_computer, _consoleOutput] call AE3_armaos_fnc_terminal_updateOutput;

_computer setVariable ["AE3_terminal", _terminal, true];