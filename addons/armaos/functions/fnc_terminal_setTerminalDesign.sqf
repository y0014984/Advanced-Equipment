/**
 * Sets the used terminal design.
 *
 * Arguments:
 * 1: Console Dialog <CONTROL>
 * 2: Selected Design <NUMBER>
 *
 * Results:
 * None
 */

params ["_consoleDialog", "_currentDesign"];

private _headerBackgroundCtrl = _consoleDialog displayCtrl 900;
private _consoleBackgroundCtrl = _consoleDialog displayCtrl 910;

private _headerCtrl = _consoleDialog displayCtrl 1000;
private _consoleCtrl = _consoleDialog displayCtrl 1100;

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
_designButtonCtrl ctrlSetTextColor _fontColorHeader;
_batteryButtonCtrl ctrlSetTextColor _fontColorHeader;
_closeButtonCtrl ctrlSetTextColor _fontColorHeader;

_consoleCtrl ctrlSetTextColor _fontColorConsole;

private _consoleInput = _consoleDialog displayCtrl 1150;

// set focus to input field, otherwise focus stays on button and prohibits additional text input
ctrlSetFocus _consoleInput;

/* ------------- UI on Texture ------------ */

if (AE3_UiOnTexture) then
{
   private _computer = _consoleOutput getVariable "AE3_computer";

   private _args = [_computer, _bgColorHeader, _bgColorConsole, _fontColorHeader, _fontColorConsole];

   [3, _computer, "AE3_armaos_fnc_terminal_uiOnTex_setTerminalDesign", _args] call AE3_main_fnc_executeForPlayersInRange;
};

/* ---------------------------------------- */