/*
 * Author: Root, y0014984
 * Description: Updates the keyboard layout display on UI-on-Texture for nearby players. Initializes UI-on-Texture if not already active.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _terminalKeyboardLayout <STRING> - Keyboard layout code (US, DE, FR, IT, RU, AR, HE, HU, TR)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, "DE"] call AE3_armaos_fnc_terminal_uiOnTex_setKeyboardLayout;
 *
 * Public: No
 */

params ["_computer", "_terminalKeyboardLayout"];

private _uiOnTexActive = _computer getVariable ["AE3_UiOnTexActive", false]; // local variable on computer object is sufficient

if (!_uiOnTexActive) then {
	_computer setVariable ["AE3_UiOnTexActive", true]; // Set immediately to prevent race condition
	[_computer] spawn AE3_armaos_fnc_terminal_uiOnTex_init;
};

private _displayName = _computer getVariable ["AE3_UiOnTexDisplayName", "AE3_UiOnTexture"];
waitUntil { !isNull findDisplay _displayName };

private _uiOnTextureDisplay = findDisplay _displayName;

private _uiOnTextureLanguageCtrl = _uiOnTextureDisplay displayCtrl 1310; // Language Control

_uiOnTextureLanguageCtrl ctrlSetText _terminalKeyboardLayout;

displayUpdate _uiOnTextureDisplay;
