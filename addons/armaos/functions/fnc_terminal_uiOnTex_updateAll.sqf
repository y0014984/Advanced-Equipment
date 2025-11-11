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
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _rawBuffer, _size] call AE3_armaos_fnc_terminal_uiOnTex_updateAll;
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
	"_value"
];

private _uiOnTexActive = _computer getVariable ["AE3_UiOnTexActive", false]; // local variable on computer object is sufficient

if (!_uiOnTexActive) then { [_computer] spawn AE3_armaos_fnc_terminal_uiOnTex_init; };

waitUntil { !isNull findDisplay "AE3_UiOnTexture" };

private _uiOnTextureDisplay = findDisplay "AE3_UiOnTexture";

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
			private _renderedLine = [_computer, _x] call AE3_armaos_fnc_terminal_renderLine;
			_renderedBuffer append _renderedLine;
		};
	} forEach _rawBuffer;
};

// Calculate visible buffer based on scroll position
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


/* ---------------------------------------- */

private _uiOnTextureLanguageCtrl = _uiOnTextureDisplay displayCtrl 1310; // Language Control

_uiOnTextureLanguageCtrl ctrlSetText _terminalKeyboardLayout;

/* ---------------------------------------- */

displayUpdate _uiOnTextureDisplay;
