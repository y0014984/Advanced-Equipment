/**
 * Adds an 5 Sec Per-Frame-Event-Handler for the "UI on texture" feature. This will update all contents regularly.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Console <DIALOG>
 *
 * Results:
 * None
 */

params ["_computer", "_consoleDialog"];

private _updateInterval = 5;

_handle = 
    [
        {
            (_this select 0) params ["_computer", "_consoleDialog"];

            if (_consoleDialog isEqualTo displayNull) exitWith
            {
                // remove this per frame event handler
                private _handle = _this select 1;
                [_handle] call CBA_fnc_removePerFrameHandler;
            };

            if (AE3_UiOnTexture) then
            {
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

                private _terminalBufferVisible = _terminal get "AE3_terminalBufferVisible";
                private _size = _terminal get "AE3_terminalSize";

                private _args = [_computer, _terminalBufferVisible, _size, _terminalKeyboardLayout, _bgColorHeader, _bgColorConsole, _fontColorHeader, _fontColorConsole, _value];

                [3, _computer, "AE3_armaos_fnc_terminal_uiOnTex_updateAll", _args] call AE3_main_fnc_executeForPlayersInRange;
            }
            else
            {
                // if UiOnTexture is disabled apply the default texture, 
                // but only if it isn't already set
                private _textures = getObjectTextures _computer;
                private _imagePath = "z\ae3\addons\armaos\textures\laptop_4_to_3_on.paa";
                private _textureIndex = 1;
                if (!((_textures select _textureIndex) isEqualTo _imagePath)) then
                {
                    _computer setVariable ["AE3_UiOnTexActive", false, true]; // reset var for all clients
                    _computer setObjectTextureGlobal [_textureIndex, _imagePath];
                };
            };
        }, 
        _updateInterval, 
        [_computer, _consoleDialog]
    ] call CBA_fnc_addPerFrameHandler;

_handle;