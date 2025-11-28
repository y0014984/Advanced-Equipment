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
 * 6: _terminalMaxColumns <NUMBER> - Terminal max columns for rendering
 * 7: _visibleStartOffset <NUMBER> - Optional; start index of the visible viewport within the provided buffer slice (default -1 to auto-calc)
 *
 * Return Value:
 * None
 *
 * Example:
 * Called via remoteExec from laptop terminals; not intended for direct manual invocation.
 *
 * Public: No
 */

params ["_computer", "_rawBuffer", "_size", "_scrollPosition", "_terminalDesign", "_cursorPosition", "_terminalMaxColumns", ["_visibleStartOffset", -1]];

private _uiOnTexActive = _computer getVariable ["AE3_UiOnTexActive", false]; // local variable on computer object is sufficient

if (!_uiOnTexActive) then {
	_computer setVariable ["AE3_UiOnTexActive", true]; // Set immediately to prevent race condition
	[_computer] spawn AE3_armaos_fnc_terminal_uiOnTex_init;
};

private _displayName = _computer getVariable ["AE3_UiOnTexDisplayName", "AE3_UiOnTexture"];
waitUntil { !isNull findDisplay _displayName };

private _uiOnTextureDisplay = findDisplay _displayName;

private _uiOnTextureOutputCtrl = _uiOnTextureDisplay displayCtrl 1100; // Console Output Control

// Render raw buffer to structured text locally (avoids TEXT serialization over network)
private _renderedBuffer = [];
if (!isNil "_rawBuffer" && {count _rawBuffer > 0}) then {
	{
		if (!isNil "_x") then {
			// Use fnc_terminal_renderLine to convert raw line to structured text with proper formatting
			// Pass size and maxColumns as parameters to avoid needing AE3_terminal variable
			private _renderedLine = [_computer, _x, _size, _terminalMaxColumns] call AE3_armaos_fnc_terminal_renderLine;
			_renderedBuffer append _renderedLine;
		};
	} forEach _rawBuffer;
};

// Calculate visible buffer based on scroll position
// Get terminal rows from computer (need to determine visible area)
private _terminal = _computer getVariable ["AE3_terminal", createHashMap];
private _terminalRows = _terminal getOrDefault ["AE3_terminalRows", 24];

private _visibleBuffer = [];
private _renderedBufferLength = count _renderedBuffer;

if (_renderedBufferLength > 0) then {
	private _startIndex = if (_visibleStartOffset >= 0) then {
		_visibleStartOffset min _renderedBufferLength
	} else {
		private _idx = (_renderedBufferLength - _terminalRows) - _scrollPosition;
		_idx max 0
	};

	private _availableLines = (_renderedBufferLength - _startIndex) min _terminalRows;

	for "_i" from _startIndex to (_startIndex + _availableLines - 1) do {
		_visibleBuffer pushBack (_renderedBuffer select _i);
	};
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
