/*
 * Author: Root
 * Description: Updates the terminal display control with the current visible buffer contents. Handles rendering, scrolling, and UI-on-Texture synchronization with network optimization.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _outputControl <CONTROL> - The UI control to update
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _outputControl] call AE3_armaos_fnc_terminal_updateOutput;
 *
 * Public: Yes
 */

 params ["_computer", "_outputControl"];

[_computer] call AE3_armaos_fnc_terminal_updateBufferVisible;

private _terminal = _computer getVariable "AE3_terminal";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalBufferVisible = _terminal get "AE3_terminalBufferVisible";
private _size = _terminal get "AE3_terminalSize";

private _output = [];
// Check if buffer is a valid array with content
if (_terminalBufferVisible isEqualType [] && {count _terminalBufferVisible > 0}) then {
	{
		// Skip nil entries - _x is structured text so we can't use isNull
		if (!isNil "_x") then {
			// Each element should be structured text
			private _buffer = composeText [_x, lineBreak];
			_buffer setAttributes ["size", str _size, "font", "EtelkaMonospacePro"];
			_output pushBack _buffer;
		};
	} forEach _terminalBufferVisible;
};

_outputControl ctrlSetStructuredText (composeText _output);
ctrlSetFocus _outputControl;

_computer setVariable ["AE3_terminal", _terminal];

/* ------------- UI on Texture ------------ */

if (AE3_UiOnTexture) then
{
	// Default 0.3 seconds, configurable via CBA setting (0 = instant/real-time)
	private _updateInterval = missionNamespace getVariable ["AE3_armaos_uiOnTexUpdateInterval", 0.3];

	// If CBA setting is 0, enable real-time synchronization (no throttle)
	if (_updateInterval == 0) exitWith {
		private _playerRange = missionNamespace getVariable ["AE3_UiPlayerRange", 3];
		private _playersInRange = [_playerRange, _computer] call AE3_main_fnc_getPlayersInRange;

		// Send raw buffer data for instant updates
		private _rawBuffer = _terminal get "AE3_terminalBuffer";
		private _scrollPosition = _terminal get "AE3_terminalScrollPosition";
		private _terminalDesign = _terminal getOrDefault ["AE3_terminalDesign", 9];
		private _cursorPosition = _terminal get "AE3_terminalCursorPosition";
		private _terminalMaxColumns = _terminal get "AE3_terminalMaxColumns";

		[_computer, _rawBuffer, _size, _scrollPosition, _terminalDesign, _cursorPosition, _terminalMaxColumns] remoteExec ["AE3_armaos_fnc_terminal_uiOnTex_updateOutput", _playersInRange];

		// Also sync input state for real-time typing visibility
		[_computer] call AE3_armaos_fnc_terminal_syncInputState;
	};

	// Hybrid mode: Use lightweight input sync for immediate feedback
	// Full buffer updates handled by periodic handler
	[_computer] call AE3_armaos_fnc_terminal_syncInputState;
};

/* ---------------------------------------- */
