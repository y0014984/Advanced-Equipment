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

// Do not broadcast when laptop is not actively in use
private _settingsAce3 = _computer getVariable ["AE3_SettingsACE3", createHashMap];
private _inUse = _settingsAce3 getOrDefault ["inUse", false, true];
if (!_inUse) exitWith {};

// Debounce keystroke synchronization based on CBA setting
private _debounceInterval = missionNamespace getVariable ["AE3_UiKeystrokeSyncInterval", 0.1];

// Get last sync time for this computer
private _lastSyncTime = _computer getVariable ["AE3_lastKeystrokeSyncTime", -999];
private _currentTime = CBA_missionTime;

// If debounce interval is 0, always sync (real-time mode)
// Otherwise, only sync if enough time has passed since last sync
if (_debounceInterval > 0 && (_currentTime - _lastSyncTime) < _debounceInterval) exitWith {};

// Update last sync time
_computer setVariable ["AE3_lastKeystrokeSyncTime", _currentTime];

private _playerRange = missionNamespace getVariable ["AE3_UiPlayerRange", 2];
private _playersInRange = [_playerRange, _computer] call AE3_main_fnc_getPlayersInRange;

// Apply viewer limit if configured
private _maxViewers = missionNamespace getVariable ["AE3_UiMaxConcurrentViewers", 3];
if (_maxViewers > 0 && count _playersInRange > _maxViewers) then
{
    // Sort by distance and take only closest N players
    _playersInRange = _playersInRange apply {
        [_x distance _computer, _x]
    };
    _playersInRange sort true; // Sort by distance (ascending)
    _playersInRange = (_playersInRange select [0, _maxViewers]) apply { _x select 1 };
};

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
