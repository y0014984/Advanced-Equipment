params ["_dialog", "_x", "_y", "_color"];

private _width = _dialog getVariable "AE3_Retro_Width";
private _height = _dialog getVariable "AE3_Retro_Height";

private _pixelWidth = _dialog getVariable "AE3_Retro_PixelWidth";
private _pixelHeight = _dialog getVariable "AE3_Retro_PixelHeight";

if ((_x < 0) || (_x >= _width)) exitWith {};
if ((_y < 0) || (_y >= _height)) exitWith {};

private _bitmap = _dialog getVariable "AE3_Retro_Bitmap";
private _backgroundCtrl = _dialog getVariable "AE3_Retro_Background";

private _bgColor = ctrlBackgroundColor _backgroundCtrl;

// example key for position x = 5 and y = 10: "x5y10"
private _key = "x" + (str _x) + "y" + (str _y);

private _pixelCtrl = _bitmap get _key;

if (isNil "_pixelCtrl") then
{
    if (_color isNotEqualTo _bgColor) then
    {
        // if pixel control does not exist and color is not bg color, then create control
        _pixelCtrl = _dialog ctrlCreate ["RscText", -1];

        private _ctrlWidth = pixelW * pixelGrid * _pixelWidth;
        private _ctrlHeight = pixelH * pixelGrid * _pixelHeight;
        private _ctrlX = pixelW * pixelGrid * _x * _pixelWidth;
        private _ctrlY = pixelH * pixelGrid * _y * _pixelHeight;
        _pixelCtrl ctrlSetPosition [_ctrlX, _ctrlY, _ctrlWidth, _ctrlHeight];
        _pixelCtrl ctrlCommit 0;

        _pixelCtrl ctrlSetBackgroundColor _color;

        _bitmap set [_key, _pixelCtrl];
    };
}
else
{
    if (_color isEqualTo _bgColor) then
    {
        // if pixel control exists and new color is bg color, remove the control
        ctrlDelete _pixelCtrl;
        _bitmap deleteAt _key;
    }
    else
    {
        // if pixel control exists and new color is not bg color, change color
        _pixelCtrl ctrlSetBackgroundColor _color;
    };
};

