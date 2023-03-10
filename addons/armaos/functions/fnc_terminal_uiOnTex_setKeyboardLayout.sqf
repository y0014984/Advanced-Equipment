params ["_computer", "_terminalKeyboardLayout"];

private _uiOnTexActive = _computer getVariable ["AE3_UiOnTexActive", false]; // local variable on computer object is sufficient

if (!_uiOnTexActive) then { [_computer] spawn AE3_armaos_fnc_terminal_uiOnTex_init; };

waitUntil { !isNull findDisplay "AE3_UiOnTexture" };

private _uiOnTextureDisplay = findDisplay "AE3_UiOnTexture";

private _uiOnTextureLanguageCtrl = _uiOnTextureDisplay displayCtrl 1310; // Language Control

_uiOnTextureLanguageCtrl ctrlSetText _terminalKeyboardLayout;

displayUpdate _uiOnTextureDisplay;