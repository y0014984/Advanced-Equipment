params [["_width", 80], ["_height", 50], ["_bgColor", [0,0,0,1]]];

private _dialog = createDialog ["AE3_ArmaOS_Retro_Dialog", false];

if (_width < 0 ) then { _width = 80; };
if (_width > 80 ) then { _width = 80; };
if (_height < 0 ) then { _height = 50; };
if (_height > 50 ) then { _height = 50; };

_dialog setVariable ["AE3_Retro_Width", _width];
_dialog setVariable ["AE3_Retro_Height", _height];

_dialog setVariable ["AE3_Retro_Bitmap", createHashMap];

private _backgroundCtrl = _dialog displayCtrl 2000;

private _ctrlWidth = pixelW * pixelGrid * _width;
private _ctrlHeight = pixelH * pixelGrid * _height;

_backgroundCtrl ctrlSetPosition [0, 0, _ctrlWidth, _ctrlHeight];
_backgroundCtrl ctrlCommit 0;

_backgroundCtrl ctrlSetBackgroundColor _bgColor;

_dialog setVariable ["AE3_Retro_Background", _backgroundCtrl];

_backgroundCtrl setVariable ["AE3_Retro_Dialog", _dialog];

_dialog;