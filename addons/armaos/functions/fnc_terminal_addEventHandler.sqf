/**
 * Adds event handler to the user interface elements of a terminal.
 *
 * Arguments:
 * 1: UI Text Field <CONTROL>
 * 2: Keyboard Layout UI Button <CONTROL>
 *
 * Results:
 * None
 */

#include "\a3\ui_f\hpp\definedikcodes.inc"

params ["_consoleDialog", "_terminalCtrl", "_languageButtonCtrl", "_designButtonCtrl"];

/* ================================================================================ */

private _result = _terminalCtrl ctrlAddEventHandler
[
	"KeyDown", 
	{
		params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

		private _computer = _displayorcontrol getVariable "AE3_computer";
		private _terminal = _computer getVariable "AE3_terminal";
		private _terminalApplication = _terminal get "AE3_terminalApplication";
		private _terminalAllowedKeys = _terminal get "AE3_terminalAllowedKeys";
		private _terminalBuffer = _terminal get "AE3_terminalBuffer";
		private _terminalPrompt = _terminal get "AE3_terminalPrompt";

		private _lastBufferLineIndex = (count _terminalBuffer) - 1;

		_terminal set ["AE3_terminalScrollPosition", 0];

		private _keyCombination = format ["%1-%2-%3-%4", _key, _shift, _ctrl, _alt];

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
		
		if (_keyCombination in _terminalAllowedKeys) then
		{
			private _keyChar = _terminalAllowedKeys get _keyCombination;

			[_computer, _keyChar] call AE3_armaos_fnc_terminal_addCharToInput;
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

		[_computer, _displayorcontrol] call AE3_armaos_fnc_terminal_updateOutput;

		true // Intercepts the default action, eg. pressing escape won't close the dialog.
	}
];

/* ================================================================================ */

private _result = _terminalCtrl ctrlAddEventHandler
[
	"MouseZChanged", 
	{
		params ["_displayOrControl", "_scroll"];

		private _computer = _displayorcontrol getVariable "AE3_computer";
		private _terminal = _computer getVariable "AE3_terminal";
		private _terminalScrollPosition = _terminal get "AE3_terminalScrollPosition";
		private _terminalApplication = _terminal get "AE3_terminalApplication";

		if (_terminalApplication == "SHELL") then
		{
			if (_scroll >= 0) then 
			{
				_terminal set ["AE3_terminalScrollPosition", _terminalScrollPosition - AE3_TerminalScrollSpeed];
			}
			else
			{
				_terminal set ["AE3_terminalScrollPosition", _terminalScrollPosition + AE3_TerminalScrollSpeed];
			};
		};

		[_computer, _displayorcontrol] call AE3_armaos_fnc_terminal_updateOutput;
	}
];

/* ================================================================================ */

_languageButtonCtrl buttonSetAction
	"
		private _consoleDialog = findDisplay 15984;
		private _consoleOutput = _consoleDialog displayCtrl 1100;
		private _languageButton = _consoleDialog displayCtrl 1310;

		private _computer = _consoleOutput getVariable 'AE3_computer';

		[_computer, _languageButton, _consoleOutput] call AE3_armaos_fnc_terminal_switchKeyboardLayout;
	";

/* ================================================================================ */

_designButtonCtrl buttonSetAction
	"
		private _consoleDialog = findDisplay 15984;

		[_consoleDialog] call AE3_armaos_fnc_terminal_switchTerminalDesign;
	";

/* ================================================================================ */

/* Unlocks terminal after it is closed */
private _result = _consoleDialog displayAddEventHandler
[
	"Unload",
	{
		params ["_display", "_exitCode"];

		_computer = _display getVariable "AE3_computer";
		_computer setVariable ["AE3_computer_mutex", objNull, true];

		_handleUpdateBatteryStatus = _display getVariable "AE3_handleUpdateBatteryStatus";
		[_handleUpdateBatteryStatus] call CBA_fnc_removePerFrameHandler;

		// Updates terminal variable for all
		_terminal = _computer getVariable "AE3_terminal";
		_computer setVariable ["AE3_terminal", _terminal, 2];
		_filepointer = _computer getVariable "AE3_filepointer";
		_computer setVariable ["AE3_filepointer", _filepointer, 2];

		[_computer, "inUse", false] call AE3_interaction_fnc_manageAce3Interactions;
	}
]

/* ================================================================================ */