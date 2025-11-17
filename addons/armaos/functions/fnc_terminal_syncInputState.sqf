/*
 * Author: Root
 * Description: Synchronizes only the input state (input buffer, cursor position, prompt) to nearby players for real-time typing display.
 *              This is a lightweight alternative to full terminal sync, used when CBA setting > 0 for hybrid mode.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The laptop computer object
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_terminal_syncInputState;
 *
 * Public: No
 */

params ["_computer"];

if (!AE3_UiOnTexture) exitWith {};

private _playerRange = missionNamespace getVariable ["AE3_UiPlayerRange", 3];
private _playersInRange = [_playerRange, _computer] call AE3_main_fnc_getPlayersInRange;

// Exit if no players in range to avoid network overhead
if (count _playersInRange == 0) exitWith {};

private _terminal = _computer getVariable ["AE3_terminal", createHashMap];

// Only sync essential input state - no full buffer
// Input is stored as AE3_terminalInputBuffer = [beforeCursor, afterCursor]
private _terminalInputBuffer = _terminal getOrDefault ["AE3_terminalInputBuffer", ["", ""]];
private _beforeCursor = _terminalInputBuffer select 0;
private _afterCursor = _terminalInputBuffer select 1;
private _input = _beforeCursor + _afterCursor;
private _cursorPosition = count _beforeCursor;
private _prompt = _terminal getOrDefault ["AE3_terminalPrompt", ""];

// Send lightweight input state to nearby players
[
	_computer,
	_input,
	_cursorPosition,
	_prompt
] remoteExec ["AE3_armaos_fnc_terminal_uiOnTex_updateInputOnly", _playersInRange];
