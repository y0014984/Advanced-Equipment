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

private _updateInterval = 5;

_handle =
    [
        {
            (_this select 0) params ["_computer", "_consoleDialog"];

            if (AE3_UiOnTexture) then
            {
                private _playersInRange = [3, _computer] call AE3_main_fnc_getPlayersInRange;

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

                // Send raw buffer data instead of pre-rendered structured text to avoid TEXT serialization warnings
                private _rawBuffer = _terminal get "AE3_terminalBuffer";
                private _scrollPosition = _terminal get "AE3_terminalScrollPosition";
                private _terminalDesign = _terminal get "AE3_terminalDesign";
                private _cursorPosition = _terminal get "AE3_terminalCursorPosition";
                private _prompt = _terminal get "AE3_terminalPrompt";
                private _input = _terminal get "AE3_terminalInput";
                private _application = _terminal get "AE3_terminalApplication";
                private _size = _terminal get "AE3_terminalSize";

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
                    _value
                ] remoteExec ["AE3_armaos_fnc_terminal_uiOnTex_updateAll", _playersInRange];
            };
        },
        _updateInterval,
        [_computer, _consoleDialog]
    ] call CBA_fnc_addPerFrameHandler;

_handle;
