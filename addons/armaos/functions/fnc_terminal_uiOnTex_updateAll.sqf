/**
 * Updates all content of the terminal for the "UI on texture" feature. 
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Output <STRUCTURED TEXT>
 * 3: Keyboard Layout <STRING>
 * 4: Background Color Header <COLOR>
 * 5: Background Color Console <COLOR>
 * 6: Font Color Header <COLOR>
 * 7: Font Color Console <COLOR>
 * 8: Battery Symbol Path <STRING>
 *
 * Results:
 * None
 */


params ["_computer", "_output", "_terminalKeyboardLayout", "_bgColorHeader", "_bgColorConsole", "_fontColorHeader", "_fontColorConsole", "_value"];

private _uiOnTexActive = _computer getVariable ["AE3_UiOnTexActive", false]; // local variable on computer object is sufficient

if (!_uiOnTexActive) then { [_computer] spawn AE3_armaos_fnc_terminal_uiOnTex_init; };

waitUntil { !isNull findDisplay "AE3_UiOnTexture" };

private _uiOnTextureDisplay = findDisplay "AE3_UiOnTexture";

/* ---------------------------------------- */

private _uiOnTextureHeaderBackgroundCtrl = _uiOnTextureDisplay displayCtrl 900;
private _uiOnTextureConsoleBackgroundCtrl = _uiOnTextureDisplay displayCtrl 910;

private _uiOnTextureHeaderCtrl = _uiOnTextureDisplay displayCtrl 1000;
private _uiOnTextureConsoleCtrl = _uiOnTextureDisplay displayCtrl 1100;

private _uiOnTextureLanguageButtonCtrl = _uiOnTextureDisplay displayCtrl 1310;
private _uiOnTextureDesignButtonCtrl = _uiOnTextureDisplay displayCtrl 1320;
private _uiOnTextureBatteryButtonCtrl = _uiOnTextureDisplay displayCtrl 1050;
private _uiOnTextureCloseButtonCtrl = _uiOnTextureDisplay displayCtrl 1300;

_uiOnTextureHeaderBackgroundCtrl ctrlSetBackgroundColor _bgColorHeader;
_uiOnTextureConsoleBackgroundCtrl ctrlSetBackgroundColor _bgColorConsole;

_uiOnTextureHeaderCtrl ctrlSetTextColor _fontColorHeader;
_uiOnTextureLanguageButtonCtrl ctrlSetTextColor _fontColorHeader;
_uiOnTextureDesignButtonCtrl ctrlSetTextColor _fontColorHeader;
_uiOnTextureBatteryButtonCtrl ctrlSetTextColor _fontColorHeader;
_uiOnTextureCloseButtonCtrl ctrlSetTextColor _fontColorHeader;

_uiOnTextureConsoleCtrl ctrlSetTextColor _fontColorConsole;

/* ---------------------------------------- */

private _uiOnTextureBatteryCtrl = _uiOnTextureDisplay displayCtrl 1050; // Battery Control

_uiOnTextureBatteryCtrl ctrlSetText _value;

/* ---------------------------------------- */

private _uiOnTextureOutputCtrl = _uiOnTextureDisplay displayCtrl 1100; // Console Output Control

_uiOnTextureOutputCtrl ctrlSetStructuredText _output;

/* ---------------------------------------- */

private _uiOnTextureLanguageCtrl = _uiOnTextureDisplay displayCtrl 1310; // Language Control

_uiOnTextureLanguageCtrl ctrlSetText _terminalKeyboardLayout;

/* ---------------------------------------- */

displayUpdate _uiOnTextureDisplay;