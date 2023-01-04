params ["_computer", "_languageButton", "_consoleOutput", "_terminalKeyboardLayout"];

private _terminal = _computer getVariable "AE3_terminal";

_computer setVariable ["AE3_terminalKeyboardLayout", _terminalKeyboardLayout];

private _terminalAllowedKeys = _terminal get "AE3_terminalAllowedKeys";
if (_terminalKeyboardLayout == "DE") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysDE; };
if (_terminalKeyboardLayout == "FR") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysFR; };
if (_terminalKeyboardLayout == "US") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysUS; };
_terminal set ["AE3_terminalAllowedKeys", _terminalAllowedKeys];

_languageButton ctrlSetText _terminalKeyboardLayout;
ctrlSetFocus _consoleOutput;

// write/sync changed keyboard layout back to CBA settings
if (!isMultiplayer || (isServer && hasInterface)) then
{
	// In singeplayer or as host in a multiplayer session
	["AE3_KeyboardLayout", _terminalKeyboardLayout, 0, "server", true] call CBA_settings_fnc_set;
}
else
{
	// As client in a multiplayer session
	["AE3_KeyboardLayout", _terminalKeyboardLayout, 0, "client", true] call CBA_settings_fnc_set;
};

_computer setVariable ["AE3_terminal", _terminal];