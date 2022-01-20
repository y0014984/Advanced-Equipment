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

params ["_terminalCtrl", "_languageButtonCtrl"];

/* ---------------------------------------- */

private _result = _terminalCtrl ctrlAddEventHandler
[
	"KeyDown", 
	{
		params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

		private _computer = _displayorcontrol getVariable "AE3_computer";
		private _terminal = _computer getVariable "AE3_terminal";
		private _terminalApplication = _terminal get "AE3_terminalApplication";
		private _terminalAllowedKeys = _terminal get "AE3_terminalAllowedKeys";

		private _keyCombination = format ["%1-%2-%3-%4", _key, _shift, _ctrl, _alt];

		if (_keyCombination in _terminalAllowedKeys) then
		{
			private _keyChar = _terminalAllowedKeys get _keyCombination;

			switch (_terminalApplication) do
			{
				case "LOGIN":
					{
						[_computer, _keyChar] call AE3_armaos_fnc_terminal_addChar;
					};
				case "PASSWORD":
					{
						[_computer, "*"] call AE3_armaos_fnc_terminal_addChar;
						[_computer, _keyChar] call AE3_armaos_fnc_terminal_addCharToPassword;
					};
				case "SHELL":
					{
						[_computer, _keyChar] call AE3_armaos_fnc_terminal_addChar;
					};
			};
		};

		if (_key isEqualTo DIK_BACKSPACE) then
		{
			switch (_terminalApplication) do
			{
				case "LOGIN":
					{
						[_computer] call AE3_armaos_fnc_terminal_removeChar;
					};
				case "PASSWORD":
					{
						[_computer] call AE3_armaos_fnc_terminal_removeChar;
						[_computer] call AE3_armaos_fnc_terminal_removeCharFromPassword;
					};
				case "SHELL":
					{
						[_computer] call AE3_armaos_fnc_terminal_removeChar;
					};
			};
		};


		if ((_key isEqualTo DIK_RETURN) || (_key isEqualTo DIK_NUMPADENTER)) then	
		{
			private _terminalBuffer = _terminal get "AE3_terminalBuffer";
			private _terminalPrompt = _terminal get "AE3_terminalPrompt";

			private _lastBufferLineIndex = (count _terminalBuffer) - 1;
			private _lastBufferLine = _terminalBuffer # (_lastBufferLineIndex);

			private _input = _lastBufferLine select [(count _terminalPrompt), (count _lastBufferLine)];

			switch (_terminalApplication) do
			{
				case "LOGIN":
					{
						[_computer, _input] call AE3_armaos_fnc_shell_findLoginUser;
					};
				case "PASSWORD":
					{
						[_computer] call AE3_armaos_fnc_shell_validatePassword;
					};
				case "SHELL":
					{
						[_computer, _input] call AE3_armaos_fnc_shell_process;
					};
			};
		};

		[_computer, _displayorcontrol] call AE3_armaos_fnc_terminal_updateOutput;

		true // Intercepts the default action, eg. pressing escape won't close the dialog.
	}
];

/* ---------------------------------------- */

_languageButtonCtrl buttonSetAction
	"
		private _consoleDialog = findDisplay 15984;
		private _consoleOutput = _consoleDialog displayCtrl 1100;
		private _languageButton = _consoleDialog displayCtrl 1310;

		private _computer = _consoleOutput getVariable 'AE3_computer';

		[_computer, _languageButton, _consoleOutput] call AE3_armaos_fnc_terminal_switchKeyboardLayout;
	";

/* ---------------------------------------- */