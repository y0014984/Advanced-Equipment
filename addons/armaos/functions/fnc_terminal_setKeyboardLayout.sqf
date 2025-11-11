/*
 * Author: Root
 * Description: Sets the keyboard layout for the terminal. Supports 9 languages (US, DE, FR, IT, RU, AR, HE, HU, TR). Updates the keyboard key mappings and syncs to CBA settings.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _languageButton <CONTROL> - The language button UI control
 * 2: _consoleOutput <CONTROL> - The console output UI control
 * 3: _terminalKeyboardLayout <STRING> - The keyboard layout code (US, DE, FR, IT, RU, AR, HE, HU, TR)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _langBtn, _output, "DE"] call AE3_armaos_fnc_terminal_setKeyboardLayout;
 *
 * Public: Yes
 */

params ["_computer", "_languageButton", "_consoleOutput", "_terminalKeyboardLayout"];

private _terminal = _computer getVariable "AE3_terminal";

_computer setVariable ["AE3_terminalKeyboardLayout", _terminalKeyboardLayout];

private _terminalAllowedKeys = _terminal get "AE3_terminalAllowedKeys";
if (_terminalKeyboardLayout == "AR") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysAR; };
if (_terminalKeyboardLayout == "DE") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysDE; };
if (_terminalKeyboardLayout == "FR") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysFR; };
if (_terminalKeyboardLayout == "HE") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysHE; };
if (_terminalKeyboardLayout == "HU") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysHU; };
if (_terminalKeyboardLayout == "IT") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysIT; };
if (_terminalKeyboardLayout == "RU") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysRU; };
if (_terminalKeyboardLayout == "TR") then { _terminalAllowedKeys = [] call AE3_armaos_fnc_terminal_getAllowedKeysTR; };
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

/* ------------- UI on Texture ------------ */

if (AE3_UiOnTexture) then
{
	private _playersInRange = [3, _computer] call AE3_main_fnc_getPlayersInRange;

	[_computer, _terminalKeyboardLayout] remoteExec ["AE3_armaos_fnc_terminal_uiOnTex_setKeyboardLayout", _playersInRange];
};

/* ---------------------------------------- */
