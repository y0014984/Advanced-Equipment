/**
 * Updates terminal output for the "UI on texture" feature.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Terminal buffer visible <ARRAY> - Array of text lines
 * 3: Terminal size <NUMBER> - Font size
 *
 * Results:
 * None
 */

params ["_computer", "_terminalBufferVisible", "_size"];

private _uiOnTexActive = _computer getVariable ["AE3_UiOnTexActive", false]; // local variable on computer object is sufficient

if (!_uiOnTexActive) then { [_computer] spawn AE3_armaos_fnc_terminal_uiOnTex_init; };

waitUntil { !isNull findDisplay "AE3_UiOnTexture" };

private _uiOnTextureDisplay = findDisplay "AE3_UiOnTexture";

private _uiOnTextureOutputCtrl = _uiOnTextureDisplay displayCtrl 1100; // Console Output Control

// Compose text locally to avoid serialization warnings
private _output = [];
{
	private _buffer = composeText [_x, lineBreak];
	_buffer setAttributes ["size", str _size, "font", "EtelkaMonospacePro"];
	_output pushBack _buffer;
} forEach _terminalBufferVisible;

_uiOnTextureOutputCtrl ctrlSetStructuredText (composeText _output);

displayUpdate _uiOnTextureDisplay;
