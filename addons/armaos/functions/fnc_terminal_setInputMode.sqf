params['_computer', '_mode'];

hint "TEST";

private _terminal = _computer getVariable "AE3_terminal";
_terminal set ["AE3_terminalApplication", _mode];
_computer setVariable ["AE3_terminal", _terminal, true];

systemChat (_terminal get "AE3_terminalApplication");