/*
 * Author: Root
 * Description: Renders a line of text as structured text with color formatting for terminal display.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _line <STRING> - TODO: Add description
 * 2: _size <NUMBER> (Optional) - Terminal font size, if not provided will read from terminal
 * 3: _maxColumns <NUMBER> (Optional) - Terminal max columns, if not provided will read from terminal
 *
 * Return Value:
 * Array of structured text
 *
 * Example:
 * [_computer, _line] call AE3_armaos_fnc_terminal_renderLine;
 * [_computer, _line, 0.8, 80] call AE3_armaos_fnc_terminal_renderLine;
 *
 * Public: No
 */

params['_computer', '_line', ['_size', nil], ['_maxColumns', nil]];

// If size/maxColumns not provided as parameters, try to read from terminal variable
private _needsTerminal = (isNil "_size" || isNil "_maxColumns");
private _terminal = nil;
if (_needsTerminal) then {
	_terminal = _computer getVariable ["AE3_terminal", nil];
};

// Safety check: if terminal is not initialized and no parameters provided, return empty text to prevent crashes
if (_needsTerminal && isNil "_terminal") exitWith {
	["AE3_armaos_fnc_terminal_renderLine: Terminal not initialized on computer and no parameters provided"] call BIS_fnc_error;
	[text ""];
};

// Read from terminal if parameters not provided
if (_needsTerminal) then {
	if (isNil "_size") then {
		_size = _terminal get "AE3_terminalSize";
	};
	if (isNil "_maxColumns") then {
		_maxColumns = _terminal get "AE3_terminalMaxColumns";
	};
};

private _terminalMaxColumns = _maxColumns * 0.75 / _size;


if (_line isEqualType "") then
{
	_line = [_line];
};


private _croppedOutputLines = [text ""];
private _tmpLine = "";
private _buffer = text "";
private _color = "";
private _counter = 0;
private _c = 0;
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
	if (_color isNotEqualTo "") then {_buffer setAttributes ["color", _color];};
	
	_croppedOutputLines set [count _croppedOutputLines -1, composeText [_croppedOutputLines select -1, _buffer]];
	_c =  _counter + count (_tmpLine select [0, _terminalMaxColumns + 1 - _counter]); // _counter is still used in the line below
	_tmpLine = _tmpLine select [_terminalMaxColumns + 1 - _counter];
	_counter = _c;

	while {(count _tmpLine) >= _terminalMaxColumns} do
	{
		_buffer = text (_tmpLine select [0, _terminalMaxColumns + 1]);
		if (_color isNotEqualTo "") then {_buffer setAttributes ["color", _color];};
		
		_croppedOutputLines pushBack _buffer;
		_tmpLine = _tmpLine select [_terminalMaxColumns + 1];
		_counter = 0;
	};

	if((count _tmpLine) > 0) then 
	{
		_counter = count _tmpLine;
		_buffer = text _tmpLine;
		if (_color isNotEqualTo "") then {_buffer setAttributes ["color", _color];};
		_croppedOutputLines pushBack _buffer;
	};
}forEach _line;

_croppedOutputLines;
