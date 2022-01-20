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

		hint format ["TERMINAL: %1", _terminal];

		private _localGameLanguage = language;

		// we can determine the language of arma 3 but not the language of the keyboard layout
		// if the language is german, it's obvious, that the keyboard layout is also german (this is not the case, if game language is english)
		// perhaps we need to provide a CBA setting for changing keyboard layout or allow to change the layout directly in the terminal window
		private _allowedKeys = createHashMap;
		/*
		if (_localGameLanguage == "German") then
		{
			_allowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysGerman;
		};
		*/
		private _terminalKeyboardLayout = _terminal get "AE3_terminalKeyboardLayout";
		if (_terminalKeyboardLayout == "DE") then { _allowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysDE; };
		if (_terminalKeyboardLayout == "US") then { _allowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysUS; };

		private _keyCombination = format ["%1-%2-%3-%4", _key, _shift, _ctrl, _alt];

		if (_keyCombination in _allowedKeys) then
		{
			private _keyChar = _allowedKeys get _keyCombination;
			[_computer, _keyChar] call AE3_armaos_fnc_terminal_addChar;
		};

		if (_key isEqualTo DIK_BACKSPACE) then
		{
			[_computer] call AE3_armaos_fnc_terminal_removeChar;
		};


		if ((_key isEqualTo DIK_RETURN) || (_key isEqualTo DIK_NUMPADENTER)) then	
		{
			switch (_terminalApplication) do
			{
				case "LOGIN": { /*_result = [_consoleInput, _inputText, _outputText] call AE3_armaos_fnc_login;*/ };
				case "PASSWORD": { /*_result = [_consoleInput, _inputText, _outputText] call AE3_armaos_fnc_login;*/ };
				case "SHELL":
					{
						private _terminalBuffer = _terminal get "AE3_terminalBuffer";
						private _terminalPrompt = _terminal get "AE3_terminalPrompt";

						private _lastBufferLineIndex = (count _terminalBuffer) - 1;
						private _lastBufferLine = _terminalBuffer # (_lastBufferLineIndex);

						private _commandString = _lastBufferLine select [(count _terminalPrompt), (count _lastBufferLine)];

						private _result = [_computer, _commandString] call AE3_armaos_fnc_shell_process;
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