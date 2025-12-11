/*
 * Author: Root
 * Description: Sets the terminal visual design/theme (ArmaOS, C64, Apple II, Amber, etc.).
 *
 * Arguments:
 * 0: _consoleDialog <STRING> - TODO: Add description
 * 1: _currentDesign <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_consoleDialog, _currentDesign] call AE3_armaos_fnc_terminal_setTerminalDesign;
 *
 * Public: No
 */

params ["_consoleDialog", "_currentDesign"];

private _headerBackgroundCtrl = _consoleDialog displayCtrl 900;
private _consoleBackgroundCtrl = _consoleDialog displayCtrl 910;

private _headerCtrl = _consoleDialog displayCtrl 1000;
private _consoleCtrl = _consoleDialog displayCtrl 1100;

private _languageButtonCtrl = _consoleDialog displayCtrl 1310;
private _designButtonCtrl = _consoleDialog displayCtrl 1320;
private _batteryButtonCtrl = _consoleDialog displayCtrl 1050;
private _closeButtonCtrl = _consoleDialog displayCtrl 1300;

private _bgColorHeader = _currentDesign select 0;
private _bgColorConsole = _currentDesign select 1;
private _fontColorHeader = _currentDesign select 2;
private _fontColorConsole = _currentDesign select 3;

_headerBackgroundCtrl ctrlSetBackgroundColor _bgColorHeader;
_consoleBackgroundCtrl ctrlSetBackgroundColor _bgColorConsole;

_headerCtrl ctrlSetTextColor _fontColorHeader;
_languageButtonCtrl ctrlSetTextColor _fontColorHeader;
_designButtonCtrl ctrlSetTextColor _fontColorHeader;
_batteryButtonCtrl ctrlSetTextColor _fontColorHeader;
_closeButtonCtrl ctrlSetTextColor _fontColorHeader;

_consoleCtrl ctrlSetTextColor _fontColorConsole;

private _consoleOutput = _consoleDialog displayCtrl 1100;

// set focus to text field, otherwise focus stays on button and prohibits additional text input
ctrlSetFocus _consoleOutput;

/* ------------- UI on Texture ------------ */

if (AE3_UiOnTexture) then
{
   private _computer = _consoleOutput getVariable "AE3_computer";
   private _playerRange = missionNamespace getVariable ["AE3_UiPlayerRange", 3];
   private _playersInRange = [_playerRange, _computer] call AE3_main_fnc_getPlayersInRange;

   [_computer, _bgColorHeader, _bgColorConsole, _fontColorHeader, _fontColorConsole] remoteExec ["AE3_armaos_fnc_terminal_uiOnTex_setTerminalDesign", _playersInRange];
};

/* ---------------------------------------- */
