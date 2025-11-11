/*
 * Author: Root
 * Description: Updates battery status on UI-on-Texture displays for nearby players.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _value <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _value] call AE3_armaos_fnc_terminal_uiOnTex_updateBatteryStatus;
 *
 * Public: No
 */

params ["_computer", "_value"];

private _uiOnTexActive = _computer getVariable ["AE3_UiOnTexActive", false]; // local variable on computer object is sufficient

if (!_uiOnTexActive) then { [_computer] spawn AE3_armaos_fnc_terminal_uiOnTex_init; };

waitUntil { !isNull findDisplay "AE3_UiOnTexture" };

private _uiOnTextureDisplay = findDisplay "AE3_UiOnTexture";

private _uiOnTextureBatteryCtrl = _uiOnTextureDisplay displayCtrl 1050; // Battery Control

_uiOnTextureBatteryCtrl ctrlSetText format ["\z\ae3\addons\armaos\images\AE3_battery_%1_percent.paa", _value];

displayUpdate _uiOnTextureDisplay;
