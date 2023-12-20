/**
 * Adds event handler to the user interface elements of a terminal.
 *
 * Arguments:
 * 0: Console Dialog <DIALOG>
 * 1: Invisible Input Control <CONTROL>
 * 2: Check Battery Button <CONTROL>
 * 3: Change Design Button <CONTROL>
 *
 * Results:
 * None
 */

#include "\a3\ui_f\hpp\definedikcodes.inc"

params ["_consoleDialog", "_inputCtrl", "_batteryButtonCtrl", "_designButtonCtrl"];

/* ================================================================================ */

private _result = _inputCtrl ctrlAddEventHandler
[
	"Char",
	{
		params ["_control", "_charCode"];

		private _computer = _control getVariable "AE3_computer";
		private _consoleOutput = _control getVariable "AE3_consoleOutput";
		private _terminal = _computer getVariable "AE3_terminal";

		_terminal set ["AE3_terminalScrollPosition", 0];

		private _char = toString [_charCode];

		[_computer, _char] call AE3_armaos_fnc_terminal_addCharToInput;

		[_computer, _consoleOutput] call AE3_armaos_fnc_terminal_updateOutput;

		// can't delete the input while running in this event handler
		// spawn moves the execution into the next frame or so
		[_control] spawn { params["_control"]; _control ctrlSetText ""; };
	}
];

/* ================================================================================ */

private _result = _inputCtrl ctrlAddEventHandler
[
	"KeyDown", 
	{
		params ["_control", "_key", "_shift", "_ctrl", "_alt"];

		private _computer = _control getVariable "AE3_computer";
		private _consoleOutput = _control getVariable "AE3_consoleOutput";
		private _terminal = _computer getVariable "AE3_terminal";
		private _terminalApplication = _terminal get "AE3_terminalApplication";

		_terminal set ["AE3_terminalScrollPosition", 0];

		/* ---------------------------------------- */

		// SIG INT
		if (_key isEqualTo DIK_C && _ctrl && !_shift && !_alt) then
		{
			_process = _terminal get "AE3_terminalProcess";
			if (!(isNil "_process")) then
			{
				if (!(isNull _process)) then
				{
					terminate _process;
				}
			}
		};

		/* ---------------------------------------- */

		if (_key isEqualTo DIK_BACKSPACE) then
		{
			[_computer] call AE3_armaos_fnc_terminal_removeCharFromInput;
		};

		/* ---------------------------------------- */

		if ((_key isEqualTo DIK_RETURN) || (_key isEqualTo DIK_NUMPADENTER)) then	
		{
			private _input = [_computer] call AE3_armaos_fnc_terminal_getInput;

			[_terminal, _terminalApplication, _computer, _consoleOutput, _input] call
			{
				params ['_terminal', '_terminalApplication', '_computer', '_consoleOutput', '_input'];

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
					[_computer, _consoleOutput] call AE3_armaos_fnc_terminal_updateOutput;

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

		/* ---------------------------------------- */

		if (_key isEqualTo DIK_RIGHTARROW) then {[_computer, true] call AE3_armaos_fnc_terminal_shiftInputBuffer;};
		if (_key isEqualTo DIK_LEFTARROW) then {[_computer, false] call AE3_armaos_fnc_terminal_shiftInputBuffer;};

		/* ---------------------------------------- */

		if (_key isEqualTo DIK_END) then {[_computer, true, true] call AE3_armaos_fnc_terminal_shiftInputBuffer;};
		if (_key isEqualTo DIK_HOME) then {[_computer, false, true] call AE3_armaos_fnc_terminal_shiftInputBuffer;};

		/* ---------------------------------------- */

		if (_ctrl && _key isEqualTo DIK_ADD) then
		{
			_size = _terminal get "AE3_terminalSize";
			if (_size + 0.05 <= 1.0) then
			{
				_terminal set ["AE3_terminalSize", _size + 0.05];
				[_computer] call AE3_armaos_fnc_terminal_reRenderBuffer;
			};
		};

		if (_ctrl && _key isEqualTo DIK_SUBTRACT) then
		{
			_size = _terminal get "AE3_terminalSize";
			if (_size - 0.05 >= 0.5) then
			{
				_terminal set ["AE3_terminalSize", _size - 0.05];
				[_computer] call AE3_armaos_fnc_terminal_reRenderBuffer;
			};
		};

		/* ---------------------------------------- */

		[_computer, _consoleOutput] call AE3_armaos_fnc_terminal_updateOutput;

		true // Intercepts the default action, eg. pressing escape won't close the dialog.
	}
];

/* ================================================================================ */

private _result = _inputCtrl ctrlAddEventHandler
[
	"MouseZChanged", 
	{
		params ["_control", "_scroll"];

		private _computer = _control getVariable "AE3_computer";
		private _consoleOutput = _control getVariable "AE3_consoleOutput";
		private _terminal = _computer getVariable "AE3_terminal";
		private _terminalScrollPosition = _terminal get "AE3_terminalScrollPosition";
		private _terminalApplication = _terminal get "AE3_terminalApplication";

		if (_terminalApplication == "SHELL") then
		{
			if (_scroll >= 0) then 
			{
				_terminal set ["AE3_terminalScrollPosition", _terminalScrollPosition + AE3_TerminalScrollSpeed];
			}
			else
			{
				_terminal set ["AE3_terminalScrollPosition", _terminalScrollPosition - AE3_TerminalScrollSpeed];
			};
		};

		[_computer, _consoleOutput] call AE3_armaos_fnc_terminal_updateOutput;
	}
];

/* ================================================================================ */

_designButtonCtrl buttonSetAction
	"
		private _consoleDialog = findDisplay 15984;

		[_consoleDialog] call AE3_armaos_fnc_terminal_switchTerminalDesign;
	";

/* ================================================================================ */

_batteryButtonCtrl buttonSetAction
	"
		[(uiNamespace getVariable 'AE3_Battery'), true] call AE3_power_fnc_getBatteryLevel;
		ctrlSetFocus (uiNamespace getVariable 'AE3_ConsoleInput');
	";

/* ================================================================================ */

/* Unlocks terminal after it is closed */
private _result = _consoleDialog displayAddEventHandler
[
	"Unload",
	{
		params ["_display", "_exitCode"];

		private _computer = _display getVariable "AE3_computer";
		_computer setVariable ["AE3_computer_mutex", objNull, true];

		_handleUpdateBatteryStatus = _display getVariable "AE3_handleUpdateBatteryStatus";
		[_handleUpdateBatteryStatus] call CBA_fnc_removePerFrameHandler;

		
		/* ------------- UI on Texture ------------ */

		_handleUpdateUiOnTexture = _display getVariable "AE3_handleUpdateUiOnTexture";
		[_handleUpdateUiOnTexture] call CBA_fnc_removePerFrameHandler;

		/* ---------------------------------------- */

		// load variables
		private _terminal = _computer getVariable "AE3_terminal";
		private _filepointer = _computer getVariable "AE3_filepointer";

		// crop terminal buffer to max lines; -1 means 'no limit'
		if (!(AE3_MaxTerminalBufferLines isEqualTo "-1")) then
		{
			private _maxLines = parseNumber AE3_MaxTerminalBufferLines;
			private _terminalBuffer = _terminal get "AE3_terminalBuffer";
			private _terminalBufferCount = count _terminalBuffer;
			if (_terminalBufferCount <= _maxLines) then { _maxLines = _terminalBufferCount; };
			_terminalBuffer = _terminalBuffer select [(count _terminalBuffer) - _maxLines, _maxLines];
			_terminal set ["AE3_terminalBuffer", _terminalBuffer];
		};

		// adjust cursor line and position
		_terminal set ["AE3_terminalCursorLine", (count _terminalBuffer) - 1];
		_terminal set ["AE3_terminalCursorPosition", 0];

		// clear/reset variables, that are automatically recreated in next terminal init
		_terminal set ["AE3_terminalBufferVisible", []];
		_terminal set ["AE3_terminalRenderedBuffer", []];
		_terminal set ["AE3_terminalDesigns", []];
		_terminal set ["AE3_terminalOutput", nil];
		_terminal set ["AE3_terminalProcess", nil];

		// Updates variables on server
		_computer setVariable ["AE3_terminal", _terminal, 2];
		_computer setVariable ["AE3_filepointer", _filepointer, 2];

		[_computer, "inUse", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
	}
]

/* ================================================================================ */