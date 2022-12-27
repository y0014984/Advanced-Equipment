/**
 * Creates a pixel based canvas.
 *
 * Arguments:
 * 1: Mode <CONTROL>
 * 2: Background Color <COLOR>
 *
 * Results:
 * 1: Dialog <CONTROL>
 */

params [["_mode", 1], ["_bgColor", [0,0,0,1]]];

//Mode 1 = 80x50px; Mode 2 = 40x25px

private _width = 80;
private _height = 50;
private _pixelWidth = 1;
private _pixelHeight = 1;

if (_mode == 2) then
{
    _width = 40;
    _height = 25;
    _pixelWidth = 2;
    _pixelHeight = 2;
};

private _dialog = createDialog ["AE3_ArmaOS_Retro_Dialog", false];

_dialog setVariable ["AE3_Retro_Width", _width];
_dialog setVariable ["AE3_Retro_Height", _height];

_dialog setVariable ["AE3_Retro_PixelWidth", _pixelWidth];
_dialog setVariable ["AE3_Retro_PixelHeight", _pixelHeight];

_dialog setVariable ["AE3_Retro_Bitmap", createHashMap];

private _backgroundCtrl = _dialog displayCtrl 2000;

private _ctrlWidth = pixelW * pixelGrid * _width * _pixelWidth;
private _ctrlHeight = pixelH * pixelGrid * _height * _pixelHeight;

_backgroundCtrl ctrlSetPosition [0, 0, _ctrlWidth, _ctrlHeight];
_backgroundCtrl ctrlCommit 0;

_backgroundCtrl ctrlSetBackgroundColor _bgColor;

_dialog setVariable ["AE3_Retro_Background", _backgroundCtrl];

_backgroundCtrl setVariable ["AE3_Retro_Dialog", _dialog];

_dialog;