params ["_dialog", "_x", "_y"];

private _width = _dialog getVariable "AE3_Retro_Width";
private _height = _dialog getVariable "AE3_Retro_Height";

if ((_x < 0) || (_x >= _width)) exitWith { [0,0,0,1] };
if ((_y < 0) || (_y >= _height)) exitWith { [0,0,0,1] };

private _bitmap = _dialog getVariable "AE3_Retro_Bitmap";
private _backgroundCtrl = _dialog getVariable "AE3_Retro_Background";

// example key for position x = 5 and y = 10: "x5y10"
private _key = "x" + (str _x) + "y" + (str _y);

private _pixelCtrl = _bitmap getOrDefault [_key, _backgroundCtrl];

private _color = ctrlBackgroundColor _pixelCtrl;

_color;