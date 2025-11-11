/*
 * Author: Root
 * Description: Updates the UI-on-Texture output display with raw buffer data. Receives raw string data and renders locally to avoid TEXT serialization warnings. This is a network-optimized approach.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _rawBuffer <ARRAY> - Raw terminal buffer (STRING/ARRAY types only, not pre-rendered TEXT)
 * 2: _size <NUMBER> - Terminal font size
 * 3: _scrollPosition <NUMBER> - Current scroll position
 * 4: _terminalDesign <STRING> - Terminal design name
 * 5: _cursorPosition <NUMBER> - Current cursor position
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _rawBuffer, 0.8, 0, "ArmaOS", 10] call AE3_armaos_fnc_terminal_uiOnTex_updateOutput;
 *
 * Public: No
 */

params ["_computer", "_rawBuffer", "_size", "_scrollPosition", "_terminalDesign", "_cursorPosition"];

private _uiOnTexActive = _computer getVariable ["AE3_UiOnTexActive", false]; // local variable on computer object is sufficient

if (!_uiOnTexActive) then { [_computer] spawn AE3_armaos_fnc_terminal_uiOnTex_init; };

waitUntil { !isNull findDisplay "AE3_UiOnTexture" };

private _uiOnTextureDisplay = findDisplay "AE3_UiOnTexture";

private _uiOnTextureOutputCtrl = _uiOnTextureDisplay displayCtrl 1100; // Console Output Control

// Render raw buffer to structured text locally (avoids TEXT serialization over network)
private _renderedBuffer = [];
if (!isNil "_rawBuffer" && {count _rawBuffer > 0}) then {
	{
		if (!isNil "_x") then {
			// Use fnc_terminal_renderLine to convert raw line to structured text with proper formatting
			private _renderedLine = [_computer, _x] call AE3_armaos_fnc_terminal_renderLine;
			_renderedBuffer append _renderedLine;
		};
	} forEach _rawBuffer;
};

// Calculate visible buffer based on scroll position
// Get terminal rows from computer (need to determine visible area)
private _terminal = _computer getVariable ["AE3_terminal", createHashMap];
private _terminalRows = _terminal getOrDefault ["AE3_terminalRows", 24];

private _visibleBuffer = [];
private _startIndex = _scrollPosition max 0;
private _endIndex = (_startIndex + _terminalRows) min (count _renderedBuffer);

for "_i" from _startIndex to (_endIndex - 1) do {
	_visibleBuffer pushBack (_renderedBuffer select _i);
};

// Compose output with proper formatting
private _output = [];
{
	if (!isNil "_x") then {
		private _buffer = composeText [_x, lineBreak];
		_buffer setAttributes ["size", str _size, "font", "EtelkaMonospacePro"];
		_output pushBack _buffer;
	};
} forEach _visibleBuffer;

_uiOnTextureOutputCtrl ctrlSetStructuredText (composeText _output);

displayUpdate _uiOnTextureDisplay;
