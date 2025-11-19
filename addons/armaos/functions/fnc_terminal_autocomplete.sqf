/*
 * Author: Root
 * Description: Attempts to autocomplete the current command based on available commands and file paths.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_terminal_autocomplete;
 *
 * Public: No
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

	// Normalize path separators (convert backslashes to forward slashes)
	_lastPart = _lastPart regexReplace ["\\", "/"];

	// Calculate prefix (everything before the last part)
	// Use length calculation instead of find to get the LAST occurrence position
	private _lastPartStart = (count _input) - (count (_parts select -1));
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
	// First, try to match files/directories
	try
	{
		// Parse the path to determine directory and filename prefix
		private _pathToComplete = _lastPart;
		private _dirToSearch = "";
		private _filePrefix = _lastPart;

		// Check if the path contains a directory separator
		if (_pathToComplete find "/" >= 0) then
		{
			// Split into directory and filename parts
			private _lastSlashPos = -1;
			private _pathChars = _pathToComplete splitString "";

			// Find the last '/' position
			{
				if (_x isEqualTo "/") then { _lastSlashPos = _forEachIndex; };
			} forEach _pathChars;

			if (_lastSlashPos >= 0) then
			{
				// Extract directory path and filename prefix
				_dirToSearch = _pathToComplete select [0, _lastSlashPos + 1]; // Include the trailing /
				_filePrefix = _pathToComplete select [_lastSlashPos + 1]; // Everything after the last /
			};
		};

		// List directory contents
		private _dir = [_pointer, _filesystem, _dirToSearch, _username, false] call AE3_filesystem_fnc_lsdir;

		{
			// Validate data structure before accessing
			if (_x isEqualType [] && {count _x > 0}) then
			{
				private _entry = _x select 0;

				// Check if entry has the expected structure (1 element = name only, 2 elements = name + color)
				if (_entry isEqualType [] && {count _entry >= 1}) then
				{
					private _fileName = _entry select 0;
					private _fileObject = if (count _entry >= 2) then {_entry select 1} else {nil};

					// Safely check if it's a directory
					private _isDirectory = false;
					if (!isNil "_fileObject" && {_fileObject isEqualType []} && {count _fileObject > 0}) then
					{
						private _content = _fileObject select 0;
						_isDirectory = (!isNil "_content") && {(typeName _content) isEqualTo "HASHMAP"};
					};

					// Check if filename starts with the prefix
					if (_filePrefix isEqualTo "" || {(_fileName select [0, count _filePrefix]) isEqualTo _filePrefix}) then
					{
						// Build the full path for the match
						private _fullMatch = _dirToSearch + _fileName;

						// Add trailing / for directories to indicate they can be navigated into
						if (_isDirectory && {(_fullMatch select [(count _fullMatch) - 1] isNotEqualTo "/")}) then
						{
							_fullMatch = _fullMatch + "/";
						};

						_matches pushBack _fullMatch;
					};
				};
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
		private _isExactCommand = false;

		// First check if _lastPart is already an exact command name
		{
			if ((configName _x) isEqualTo _lastPart) exitWith {
				_isExactCommand = true;
			};
		} forEach _commands;

		// If it's already an exact command, don't try to extend it to other commands
		// Instead, this will fall through and match files in the current directory
		if (!_isExactCommand) then
		{
			{
				private _commandName = configName _x;

				if (_lastPart isEqualTo "" || {(_commandName select [0, count _lastPart]) isEqualTo _lastPart}) then
				{
					_matches pushBack _commandName;
				};
			} forEach _commands;
		};
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
	private _match = _matches select 0;
	private _newInput = _prefix + _match;

	// Add space after non-directory completions for convenience
	// (directories already have trailing /, commands should get a space)
	if ((_match select [(count _match) - 1] isNotEqualTo "/")) then
	{
		_newInput = _newInput + " ";
	};

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
	// Multiple matches - find longest common prefix
	private _commonPrefix = _matches select 0;

	{
		private _match = _x;
		private _newCommon = "";

		// Find common characters between current common prefix and this match
		private _minLen = (count _commonPrefix) min (count _match);

		for "_i" from 0 to (_minLen - 1) do
		{
			if ((_commonPrefix select [_i, 1]) isEqualTo (_match select [_i, 1])) then
			{
				_newCommon = _newCommon + (_commonPrefix select [_i, 1]);
			}
			else
			{
				// Stop at first difference
				break;
			};
		};

		_commonPrefix = _newCommon;
	} forEach _matches;

	// Check if we can complete with the common prefix (if it's longer than what user typed)
	if ((count _commonPrefix) > (count _lastPart)) then
	{
		// Complete to common prefix
		private _newInput = _prefix + _commonPrefix;

		// Clear current input
		_terminal deleteAt "AE3_terminalInputBuffer";

		// Set new input
		private _inputBuffer = ["", ""];
		{
			_inputBuffer set [0, (_inputBuffer select 0) + (toString [_x])];
		} forEach (toArray _newInput);

		_terminal set ["AE3_terminalInputBuffer", _inputBuffer];

		// Store state with the new common prefix as the last input
		_terminal set ["AE3_autocompleteState", [_commonPrefix, _matches, -1]];
	}
	else
	{
		// Common prefix already typed, cycle through matches
		_currentIndex = (_currentIndex + 1) mod (count _matches);
		private _match = _matches select _currentIndex;

		// Store state for next TAB press
		_terminal set ["AE3_autocompleteState", [_match, _matches, _currentIndex]];

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
};
