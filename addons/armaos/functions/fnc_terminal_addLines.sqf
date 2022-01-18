params ["_computer", "_outputLines"];

private _terminal = _computer getVariable "AE3_terminal";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalMaxColumns = _terminal get "AE3_terminalMaxColumns";

_croppedOutputLines = [];
{
	private _tmpLine = _x;
	while {(count _tmpLine) >= _terminalMaxColumns} do
	{
		_croppedOutputLines pushBack (_tmpLine select [0, _terminalMaxColumns + 1]);
		_tmpLine = _tmpLine select [_terminalMaxColumns + 1];
	};
	_croppedOutputLines pushBack _tmpLine;
	
} forEach _outputLines;

_terminalBuffer append _croppedOutputLines;

_terminalCursorLine = (count _terminalBuffer) + (count _outputLines);

_terminalCursorPosition = 0;

_terminal set ["AE3_terminalBuffer", _terminalBuffer];
_terminal set ["AE3_terminalCursorLine", _terminalCursorLine];
_terminal set ["AE3_terminalCursorPosition", _terminalCursorPosition];

_computer setVariable ["AE3_terminal", _terminal];