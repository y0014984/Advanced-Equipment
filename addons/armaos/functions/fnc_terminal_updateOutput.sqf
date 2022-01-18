params ["_computer", "_outputControl"];

[_computer] call AE3_armaos_fnc_terminal_updateBufferVisable;

private _terminal = _computer getVariable "AE3_terminal";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalBufferVisable = _terminal get "AE3_terminalBufferVisable";

hint format ["BUFFER: \n ***%1*** \n\n BUFFER VISABLE: \n ***%2***", _terminalBuffer, _terminalBufferVisable];

_outputControl ctrlSetText (_terminalBufferVisable joinString endl);
ctrlSetFocus _outputControl;