/*
 * Author: Root
 * Description: Adds an event handler to update UI-on-Texture when terminal state changes.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _consoleDialog <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _consoleDialog] call AE3_armaos_fnc_terminal_uiOnTex_addUpdateAllEventHandler;
 *
 * Public: No
 */

params ["_computer", "_consoleDialog"];

private _updateInterval = missionNamespace getVariable ["AE3_armaos_uiOnTexUpdateInterval", 1.0];

// Initialize previous state storage for change detection
private _previousState = createHashMap;

_handle =
    [
        {
            (_this select 0) params ["_computer", "_consoleDialog", "_previousState"];

            if (AE3_UiOnTexture) then
            {
                // Skip if laptop is not actively in use
                private _settingsAce3 = _computer getVariable ["AE3_SettingsACE3", createHashMap];
                private _inUse = _settingsAce3 getOrDefault ["inUse", false, true];
                if (!_inUse) exitWith {};

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

                // No viewers in range -> no network traffic
                if ((count _playersInRange) isEqualTo 0) exitWith {};

                private _languageButtonCtrl = _consoleDialog displayCtrl 1310;
                private _batteryButtonCtrl = _consoleDialog displayCtrl 1050;
                private _headerBackgroundCtrl = _consoleDialog displayCtrl 900;
                private _consoleBackgroundCtrl = _consoleDialog displayCtrl 910;
                private _headerCtrl = _consoleDialog displayCtrl 1000;
                private _consoleCtrl = _consoleDialog displayCtrl 1100;

                private _output = ctrlText _consoleCtrl;
                private _terminalKeyboardLayout = ctrlText _languageButtonCtrl;
                private _value = ctrlText _batteryButtonCtrl;
                private _bgColorHeader = ctrlBackgroundColor _headerBackgroundCtrl;
                private _bgColorConsole = ctrlBackgroundColor _consoleBackgroundCtrl;
                private _fontColorHeader = ctrlTextColor _headerCtrl;
                private _fontColorConsole = ctrlTextColor _consoleCtrl;

                private _terminal = _computer getVariable "AE3_terminal";
                private _terminalRows = _terminal getOrDefault ["AE3_terminalRows", 24];

                // Send raw buffer data instead of pre-rendered structured text to avoid TEXT serialization warnings
                private _rawBufferFull = _terminal get "AE3_terminalBuffer";
                private _scrollPosition = _terminal get "AE3_terminalScrollPosition";
                private _terminalDesign = _terminal getOrDefault ["AE3_terminalDesign", 9];
                private _cursorPosition = _terminal get "AE3_terminalCursorPosition";
                private _prompt = _terminal get "AE3_terminalPrompt";
                private _input = _terminal get "AE3_terminalInput";
                private _application = _terminal get "AE3_terminalApplication";
                private _size = _terminal get "AE3_terminalSize";
                private _terminalMaxColumns = _terminal get "AE3_terminalMaxColumns";

                // Trim payload to the viewport to avoid sending the entire history
                private _maxTransmitLines = missionNamespace getVariable ["AE3_UiMaxTransmitLines", 120];
                private _uiPayload = [_rawBufferFull, _terminalRows, _scrollPosition, _maxTransmitLines] call AE3_armaos_fnc_terminal_buildUiPayload;
                _uiPayload params ["_rawBuffer", "_visibleStartOffset"];

                // Change detection - only send if state changed
                private _enableChangeDetection = missionNamespace getVariable ["AE3_UiEnableChangeDetection", true];
                private _shouldUpdate = true;

                if (_enableChangeDetection) then
                {
                    // Create hash of current state for comparison
                    private _currentStateHash = str [
                        _rawBuffer,
                        _visibleStartOffset,
                        _scrollPosition,
                        _terminalDesign,
                        _cursorPosition,
                        _prompt,
                        _input,
                        _application,
                        _size,
                        _terminalMaxColumns,
                        _value
                    ];

                    private _previousHash = _previousState getOrDefault ["hash", ""];

                    if (_currentStateHash == _previousHash) then
                    {
                        _shouldUpdate = false;
                    } else {
                        _previousState set ["hash", _currentStateHash];
                    };
                };

                if (_shouldUpdate) then
                {
                    [
                        _computer,
                        _rawBuffer,
                        _size,
                        _scrollPosition,
                        _terminalDesign,
                        _cursorPosition,
                        _prompt,
                        _input,
                        _application,
                        _terminalKeyboardLayout,
                        _bgColorHeader,
                        _bgColorConsole,
                        _fontColorHeader,
                        _fontColorConsole,
                        _value,
                        _terminalMaxColumns,
                        _visibleStartOffset
                    ] remoteExec ["AE3_armaos_fnc_terminal_uiOnTex_updateAll", _playersInRange];
                };
            };
        },
        _updateInterval,
        [_computer, _consoleDialog, _previousState]
    ] call CBA_fnc_addPerFrameHandler;

_handle;
