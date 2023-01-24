/**
 * Shows a splash screen on top of a given retro dialog for given duration.
 *
 * Arguments:
 * 1: Dialog <CONTROL>
 * 2: Image Path <STRING>
 * 3: Duration <NUMBER>
 * 4: Pixel Size <NUMBER> (Optional)
 *
 * Results:
 * None
 */

params ["_dialog", "_imagePath", "_duration", ["_size", 1]];

private _width = _dialog getVariable "AE3_Retro_Width";
private _height = _dialog getVariable "AE3_Retro_Height";

private _pixelWidth = _dialog getVariable "AE3_Retro_PixelWidth";
private _pixelHeight = _dialog getVariable "AE3_Retro_PixelHeight";

private _splashCtrl = _dialog ctrlCreate ["RscPicture", -1];

private _ctrlWidth = pixelW * pixelGrid * _width * _size;
private _ctrlHeight = pixelH * pixelGrid * _height * _size;
private _ctrlX = pixelW * pixelGrid * 0 * _pixelWidth;
private _ctrlY = pixelH * pixelGrid * 0 * _pixelHeight;
_splashCtrl ctrlSetPosition [_ctrlX, _ctrlY, _ctrlWidth, _ctrlHeight];
_splashCtrl ctrlCommit 0;

_splashCtrl ctrlSetText _imagePath;

sleep _duration;

ctrlDelete _splashCtrl;


