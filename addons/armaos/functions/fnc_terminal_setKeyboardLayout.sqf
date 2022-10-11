params ["_computer", "_languageButton", "_consoleOutput", "_terminalKeyboardLayout"];

private _terminal = _computer getVariable "AE3_terminal";

_computer setVariable ["AE3_terminalKeyboardLayout", _terminalKeyboardLayout];

private _terminalAllowedKeys = _terminal get "AE3_terminalAllowedKeys";
if (_terminalKeyboardLayout == "DE") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysDE; };
if (_terminalKeyboardLayout == "US") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysUS; };
_terminal set ["AE3_terminalAllowedKeys", _terminalAllowedKeys];

_languageButton ctrlSetText "KEYBOARD " + _terminalKeyboardLayout;
ctrlSetFocus _consoleOutput;

_computer setVariable ["AE3_terminal", _terminal];