/*
 * Author: Root
 * Description: Updates all UI-on-Texture display elements (output, battery, design) for nearby players.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _rawBuffer <STRING> - TODO: Add description
 * 2: _size <STRING> - TODO: Add description
 * 3: _scrollPosition <STRING> - TODO: Add description
 * 4: _terminalDesign <STRING> - TODO: Add description
 * 5: _cursorPosition <STRING> - TODO: Add description
 * 6: _prompt <STRING> - TODO: Add description
 * 7: _input <STRING> - TODO: Add description
 * 8: _application <STRING> - TODO: Add description
 * 9: _terminalKeyboardLayout <STRING> - TODO: Add description
 * 10: _bgColorHeader <STRING> - TODO: Add description
 * 11: _bgColorConsole <STRING> - TODO: Add description
 * 12: _fontColorHeader <STRING> - TODO: Add description
 * 13: _fontColorConsole <STRING> - TODO: Add description
 * 14: _value <STRING> - TODO: Add description
 * 15: _terminalMaxColumns <NUMBER> - Terminal max columns for rendering
 * 16: _visibleStartOffset <NUMBER> - Optional; start index of the visible viewport within the provided buffer slice (default -1 to auto-calc)
 *
 * Return Value:
 * None
 *
 * Example:
 * Called via remoteExec from laptop terminals; not intended for direct manual invocation.
 *
 * Public: No
 */


params [
	"_computer",
	"_rawBuffer",
	"_size",
	"_scrollPosition",
	"_terminalDesign",
	"_cursorPosition",
	"_prompt",
	"_input",
	"_application",
	"_terminalKeyboardLayout",
	"_bgColorHeader",
	"_bgColorConsole",
	"_fontColorHeader",
	"_fontColorConsole",
	"_value",
	"_terminalMaxColumns",
	["_visibleStartOffset", -1]
];

private _uiOnTexActive = _computer getVariable ["AE3_UiOnTexActive", false]; // local variable on computer object is sufficient

if (!_uiOnTexActive) then {
	_computer setVariable ["AE3_UiOnTexActive", true]; // Set immediately to prevent race condition
	[_computer] spawn AE3_armaos_fnc_terminal_uiOnTex_init;
};

private _displayName = _computer getVariable ["AE3_UiOnTexDisplayName", "AE3_UiOnTexture"];

// Wait for display with timeout to prevent deadlock (e.g., when Arsenal opens during init)
private _timeoutStart = time;
private _maxWaitTime = 5; // 5 seconds timeout
waitUntil {
	sleep 0.01;
	!isNull findDisplay _displayName || (time - _timeoutStart) > _maxWaitTime
};

private _uiOnTextureDisplay = findDisplay _displayName;

// If display not found after timeout, exit gracefully
if (isNull _uiOnTextureDisplay) exitWith {};

/* ---------------------------------------- */

private _uiOnTextureHeaderBackgroundCtrl = _uiOnTextureDisplay displayCtrl 900;
private _uiOnTextureConsoleBackgroundCtrl = _uiOnTextureDisplay displayCtrl 910;

private _uiOnTextureHeaderCtrl = _uiOnTextureDisplay displayCtrl 1000;
private _uiOnTextureConsoleCtrl = _uiOnTextureDisplay displayCtrl 1100;

private _uiOnTextureLanguageButtonCtrl = _uiOnTextureDisplay displayCtrl 1310;
private _uiOnTextureDesignButtonCtrl = _uiOnTextureDisplay displayCtrl 1320;
private _uiOnTextureBatteryButtonCtrl = _uiOnTextureDisplay displayCtrl 1050;
private _uiOnTextureCloseButtonCtrl = _uiOnTextureDisplay displayCtrl 1300;

_uiOnTextureHeaderBackgroundCtrl ctrlSetBackgroundColor _bgColorHeader;
_uiOnTextureConsoleBackgroundCtrl ctrlSetBackgroundColor _bgColorConsole;

_uiOnTextureHeaderCtrl ctrlSetTextColor _fontColorHeader;
_uiOnTextureLanguageButtonCtrl ctrlSetTextColor _fontColorHeader;
_uiOnTextureDesignButtonCtrl ctrlSetTextColor _fontColorHeader;
_uiOnTextureBatteryButtonCtrl ctrlSetTextColor _fontColorHeader;
_uiOnTextureCloseButtonCtrl ctrlSetTextColor _fontColorHeader;

_uiOnTextureConsoleCtrl ctrlSetTextColor _fontColorConsole;

/* ---------------------------------------- */

private _uiOnTextureBatteryCtrl = _uiOnTextureDisplay displayCtrl 1050; // Battery Control

_uiOnTextureBatteryCtrl ctrlSetText _value;

/* ---------------------------------------- */

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
// Match the player dialog logic: subtract scroll position from the end to keep behavior consistent
private _terminal = _computer getVariable ["AE3_terminal", createHashMap];
private _terminalRows = _terminal getOrDefault ["AE3_terminalRows", 24];

private _visibleBuffer = [];
private _renderedBufferLength = count _renderedBuffer;

if (_renderedBufferLength > 0) then {
	private _startIndex = if (_visibleStartOffset >= 0) then {
		_visibleStartOffset min _renderedBufferLength
	} else {
		// Fallback to legacy behavior if no offset is provided
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

// Hybrid mode: Check for real-time input state overlay
private _inputState = _computer getVariable ["AE3_terminalInputState", createHashMap];
private _hasRecentInputState = false;
if (count _inputState > 0) then {
	private _inputStateTime = _inputState getOrDefault ["timestamp", 0];
	// Only use input state if it's recent (within 1 second)
	if (time - _inputStateTime < 1) then {
		_hasRecentInputState = true;
	};
};

{
	if (!isNil "_x") then {
		private _buffer = composeText [_x, lineBreak];
		_buffer setAttributes ["size", str _size, "font", "EtelkaMonospacePro"];
		_output pushBack _buffer;
	};
} forEach _visibleBuffer;

// If we have recent input state, remove the last line (old prompt) and replace with live input
if (_hasRecentInputState) then {
	// Remove the last line which contains the stale prompt from the periodic buffer
	if (_output isNotEqualTo []) then {
		_output deleteAt ((count _output) - 1);
	};

	private _stateInput = _inputState getOrDefault ["input", ""];
	private _statePrompt = _inputState getOrDefault ["prompt", ""];
	private _stateCursor = _inputState getOrDefault ["cursorPosition", 0];

	// Render the current input line with live prompt
	private _inputLine = [_computer, [_statePrompt, _stateInput], _size, _terminalMaxColumns] call AE3_armaos_fnc_terminal_renderLine;
	if (count _inputLine > 0) then {
		{
			if (!isNil "_x") then {
				private _buffer = composeText [_x, lineBreak];
				_buffer setAttributes ["size", str _size, "font", "EtelkaMonospacePro"];
				_output pushBack _buffer;
			};
		} forEach _inputLine;
	};
};

_uiOnTextureOutputCtrl ctrlSetStructuredText (composeText _output);


/* ---------------------------------------- */

private _uiOnTextureLanguageCtrl = _uiOnTextureDisplay displayCtrl 1310; // Language Control

_uiOnTextureLanguageCtrl ctrlSetText _terminalKeyboardLayout;

/* ---------------------------------------- */

displayUpdate _uiOnTextureDisplay;
