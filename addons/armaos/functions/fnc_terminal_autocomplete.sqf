/**
 * Handles Tab key auto-completion for terminal input.
 * Cycles through matches alphabetically on subsequent TAB presses.
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

// Check if we're continuing a previous autocomplete cycle
private _autocompleteState = _terminal getOrDefault ["AE3_autocompleteState", []];
private _lastInput = if (count _autocompleteState > 0) then {_autocompleteState select 0} else {""};
private _matches = if (count _autocompleteState > 1) then {_autocompleteState select 1} else {[]};
private _currentIndex = if (count _autocompleteState > 2) then {_autocompleteState select 2} else {-1};

// If input changed (not just cycling), reset autocomplete
if (_lastInput != _lastPart) then
{
	_matches = [];
	_currentIndex = -1;

	// Get potential matches
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

	// Sort matches alphabetically
	_matches sort true;
};

// Apply completion
if (count _matches == 0) exitWith {
	// No matches - clear state
	_terminal deleteAt "AE3_autocompleteState";
};

if (count _matches == 1) then
{
	// Single match - complete it and clear state
	private _newInput = _prefix + (_matches select 0);

	// Clear current input
	_terminal deleteAt "AE3_terminalInputBuffer";

	// Set new input
	private _inputBuffer = ["", ""];
	{
		_inputBuffer set [0, (_inputBuffer select 0) + (toString [_x])];
	} forEach (toArray _newInput);

	_terminal set ["AE3_terminalInputBuffer", _inputBuffer];
	_terminal deleteAt "AE3_autocompleteState";
}
else
{
	// Multiple matches - cycle through them
	_currentIndex = (_currentIndex + 1) mod (count _matches);
	private _match = _matches select _currentIndex;

	// Store state for next TAB press
	_terminal set ["AE3_autocompleteState", [_lastPart, _matches, _currentIndex]];

	// Apply the current match
	private _newInput = _prefix + _match;

	// Clear current input
	_terminal deleteAt "AE3_terminalInputBuffer";

	// Set new input
	private _inputBuffer = ["", ""];
	{
		_inputBuffer set [0, (_inputBuffer select 0) + (toString [_x])];
	} forEach (toArray _newInput);

	_terminal set ["AE3_terminalInputBuffer", _inputBuffer];
};
