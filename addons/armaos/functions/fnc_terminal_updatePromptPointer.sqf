params ["_computer"];

private _pointer = _computer getVariable "AE3_filepointer";
private _terminal = _computer getVariable "AE3_terminal";

_terminal set ["AE3_terminalPrompt", "/" + (_pointer joinString "/") + ">"];

_computer setVariable ["AE3_terminal", _terminal];