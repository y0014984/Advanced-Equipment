/**
 * Converts the line to structured text. Crops the line, if it is to long.
 * 
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: Line to render <STRING> or <[STRING]> or <[[STRING, STRING]]>
 *
 * Results:
 * None
 */

params['_computer', '_line'];

private _terminal = _computer getVariable "AE3_terminal";
private _size = _terminal get "AE3_terminalSize";
private _terminalMaxColumns = (_terminal get "AE3_terminalMaxColumns") * 0.75 / _size;


if (_line isEqualType "") then
{
	_line = [_line];
};


private _croppedOutputLines = [text ""];
private _tmpLine = "";
private _counter = 0;
{
	_color = "";

	if (_x isEqualType []) then
	{
		_tmpLine = _x select 0;
		if (count _x > 1) then
		{
			_color = _x select 1;
		};
	}else 
	{
		_tmpLine = _x;

	};

	_buffer = text (_tmpLine select [0, _terminalMaxColumns + 1 - _counter]);
	if (!(_color isEqualTo "")) then {_buffer setAttributes ["color", _color];};
	
	_croppedOutputLines set [count _croppedOutputLines -1, composeText [(_croppedOutputLines select (count _croppedOutputLines -1)), _buffer]];
	_c =  _counter + count (_tmpLine select [0, _terminalMaxColumns + 1 - _counter]); // _counter is still used in the line below
	_tmpLine = _tmpLine select [_terminalMaxColumns + 1 - _counter];
	_counter = _c;

	while {(count _tmpLine) >= _terminalMaxColumns} do
	{
		_buffer = text (_tmpLine select [0, _terminalMaxColumns + 1]);
		if (!(_color isEqualTo "")) then {_buffer setAttributes ["color", _color];};
		
		_croppedOutputLines pushBack _buffer;
		_tmpLine = _tmpLine select [_terminalMaxColumns + 1];
		_counter = 0;
	};

	if((count _tmpLine) > 0) then 
	{
		_counter = count _tmpLine;
		_buffer = text _tmpLine;
		if (!(_color isEqualTo "")) then {_buffer setAttributes ["color", _color];};
		_croppedOutputLines pushBack _buffer;
	};
}forEach _line;

_croppedOutputLines;