params ["_computer", "_commandString"];

private _terminal = _computer getVariable "AE3_terminal";

private _terminalCommandHistory = _terminal get "AE3_terminalCommandHistory";

_terminalCommandHistory append [_commandString];

_terminal set ["AE3_terminalCommandHistory", _terminalCommandHistory];

_computer setVariable ["AE3_terminal", _terminal];