/*
 * Author: Root
 * Description: Updates only the input line on UI-on-Texture displays for nearby players.
 *              This provides real-time typing feedback without syncing the full terminal buffer.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The laptop computer object
 * 1: _input <STRING> - Current input buffer
 * 2: _cursorPosition <NUMBER> - Cursor position in input buffer
 * 3: _prompt <STRING> - Current prompt string
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, "ls -la", 6, "root@armaos:~#"] call AE3_armaos_fnc_terminal_uiOnTex_updateInputOnly;
 *
 * Public: No
 */

params ["_computer", ["_input", "", [""]], ["_cursorPosition", 0, [0]], ["_prompt", "", [""]]];

// Store input state in computer variable for hybrid rendering
private _inputState = createHashMap;
_inputState set ["input", _input];
_inputState set ["cursorPosition", _cursorPosition];
_inputState set ["prompt", _prompt];
_inputState set ["timestamp", time];

_computer setVariable ["AE3_terminalInputState", _inputState];

// Note: The actual UI update will be handled by fnc_terminal_uiOnTex_updateAll
// which will check for this variable and overlay the input state on the periodic buffer
