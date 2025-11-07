/**
 * Handles Tab key auto-completion for terminal input.
 * Prioritizes current directory files over system commands.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";
private _input = [_computer] call AE3_armaos_fnc_terminal_getInput;
private _filesystem = _computer getVariable "AE3_filesystem";
private _pointer = _computer getVariable "AE3_filepointer";
private _username = _terminal get "AE3_terminalLoginUser";

// Parse input to determine what to complete
private _parts = _input splitString " ";
private _lastPart = "";
private _prefix = "";

if (_parts isNotEqualTo []) then
{
	_lastPart = _parts select -1;

	// Calculate prefix (everything before the last part)
	private _lastPartStart = _input find _lastPart;
	if (_lastPartStart > 0) then
	{
		_prefix = _input select [0, _lastPartStart];
	};
};

// Get potential matches
private _matches = [];

// First, try to match files in current directory
try
{
	private _dir = [_pointer, _filesystem, "", _username, false] call AE3_filesystem_fnc_lsdir;

	{
		private _fileName = (_x select 0) select 0;

		// Check if filename starts with the last part
		if (_lastPart isEqualTo "" || {(_fileName select [0, count _lastPart]) isEqualTo _lastPart}) then
		{
			_matches pushBack _fileName;
		};
	} forEach _dir;
}
catch
{
	// If we can't read directory, continue to command matching
};

// If no file matches and we're completing the first word, try system commands
if (_matches isEqualTo [] && count _parts <= 1) then
{
	private _commands = "true" configClasses (configFile >> "CfgOsFunctions");

	{
		private _commandName = configName _x;

		if (_lastPart isEqualTo "" || {(_commandName select [0, count _lastPart]) isEqualTo _lastPart}) then
		{
			_matches pushBack _commandName;
		};
	} forEach _commands;
};

// Apply completion
if (count _matches == 1) then
{
	// Single match - complete it
	private _newInput = _prefix + (_matches select 0);

	// Clear current input
	_terminal deleteAt "AE3_terminalInputBuffer";

	// Set new input
	private _inputBuffer = ["", ""];
	{
		_inputBuffer set [0, (_inputBuffer select 0) + (toString [_x])];
	} forEach (toArray _newInput);

	_terminal set ["AE3_terminalInputBuffer", _inputBuffer];
}
else
{
	if (count _matches > 1) then
	{
		// Multiple matches - find common prefix
		private _commonPrefix = _matches select 0;

		{
			private _match = _x;
			private _newCommon = "";

			for [{private _i = 0}, {_i < (count _commonPrefix) && _i < (count _match)}, {_i = _i + 1}] do
			{
				if ((_commonPrefix select [_i, 1]) isEqualTo (_match select [_i, 1])) then
				{
					_newCommon = _newCommon + (_commonPrefix select [_i, 1]);
				}
				else
				{
					break;
				};
			};

			_commonPrefix = _newCommon;
		} forEach _matches;

		// If we found a longer common prefix, use it
		if ((count _commonPrefix) > (count _lastPart)) then
		{
			private _newInput = _prefix + _commonPrefix;

			// Clear current input
			_terminal deleteAt "AE3_terminalInputBuffer";

			// Set new input
			private _inputBuffer = ["", ""];
			{
				_inputBuffer set [0, (_inputBuffer select 0) + (toString [_x])];
			} forEach (toArray _newInput);

			_terminal set ["AE3_terminalInputBuffer", _inputBuffer];
		}
		else
		{
			// Show all matches
			[_computer, ""] call AE3_armaos_fnc_terminal_appendLine;

			private _matchesText = _matches joinString "  ";
			[_computer, _matchesText] call AE3_armaos_fnc_terminal_appendLine;
		};
	};
};
