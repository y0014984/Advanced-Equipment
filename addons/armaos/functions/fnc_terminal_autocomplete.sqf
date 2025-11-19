/*
 * Author: Root
 * Description: Attempts to autocomplete the current command based on available commands and file paths.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
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

// Split input into words
private _words = _input splitString " ";

// Determine what we're completing
private _completionWord = "";
private _prefixBeforeWord = "";
private _commandName = "";

// Check if input ends with space - if so, we're starting a new word
private _endsWithSpace = (count _input > 0) && {(_input select [(count _input) - 1]) isEqualTo " "};

if (_endsWithSpace) then
{
	// Starting a new argument
	_prefixBeforeWord = _input;
	_completionWord = "";
	if (_words isNotEqualTo []) then { _commandName = _words select 0; };
}
else
{
	// Completing the last word
	if (_words isNotEqualTo []) then
	{
		_completionWord = _words select -1;
		// Calculate prefix (everything before the word being completed)
		if (count _input > count _completionWord) then
		{
			_prefixBeforeWord = _input select [0, (count _input) - (count _completionWord)];
		};
		if (count _words > 1) then { _commandName = _words select 0; };
	};
};

// Normalize backslashes to forward slashes
private _normalizedWord = "";
{
	if (_x isEqualTo 92) then  // 92 is backslash ASCII code
	{
		_normalizedWord = _normalizedWord + "/";
	}
	else
	{
		_normalizedWord = _normalizedWord + toString [_x];
	};
} forEach (toArray _completionWord);
_completionWord = _normalizedWord;

// Check autocomplete state for cycling
private _state = _terminal getOrDefault ["AE3_autocompleteState", []];
private _prevWord = if (count _state > 0) then {_state select 0} else {""};
private _prevMatches = if (count _state > 1) then {_state select 1} else {[]};
private _prevIndex = if (count _state > 2) then {_state select 2} else {-1};

// If word changed, find new matches
private _matches = [];
if (_prevWord != _completionWord) then
{
	// Determine if we're completing a command or a file/directory
	private _isCompletingCommand = (count _words <= 1) && !_endsWithSpace;

	if (_isCompletingCommand) then
	{
		// Complete command names
		private _commands = "true" configClasses (configFile >> "CfgOsFunctions");
		{
			private _cmdName = configName _x;
			// Match if word is empty OR command starts with word
			if (_completionWord isEqualTo "" || {(_cmdName select [0, count _completionWord]) isEqualTo _completionWord}) then
			{
				_matches pushBack _cmdName;
			};
		} forEach _commands;
	}
	else
	{
		// Complete file/directory paths
		try
		{
			// Parse path: split into directory and filename parts
			private _dirPart = "";
			private _filePart = _completionWord;
			private _usePointer = _pointer;

			// Check if this is an absolute path (starts with /)
			private _isAbsolutePath = (count _completionWord > 0) && {(_completionWord select [0, 1]) isEqualTo "/"};

			// Find last / to split directory from filename
			private _lastSlashIdx = -1;
			{
				if (_x isEqualTo 47) then { _lastSlashIdx = _forEachIndex; };  // 47 is / ASCII code
			} forEach (toArray _completionWord);

			if (_lastSlashIdx >= 0) then
			{
				_dirPart = _completionWord select [0, _lastSlashIdx + 1];  // Include the /
				_filePart = _completionWord select [_lastSlashIdx + 1];    // After the /
			};

			// For absolute paths, ensure we use root pointer if dirPart is just "/"
			if (_isAbsolutePath) then
			{
				_usePointer = [];  // Use root pointer for absolute paths
			};

			// List directory
			private _dirList = [_usePointer, _filesystem, _dirPart, _username, false] call AE3_filesystem_fnc_lsdir;

			{
				if (_x isEqualType [] && {count _x > 0}) then
				{
					private _entry = _x select 0;
					if (_entry isEqualType [] && {count _entry >= 1}) then
					{
						private _name = _entry select 0;
						private _color = if (count _entry >= 2) then {_entry select 1} else {""};

						// Check if it's a directory by color code (lsdir returns color codes, not objects)
						// Directory color is "#008df8"
						private _isDir = _color isEqualTo "#008df8";

						// Filter by command type
						private _include = true;
						if (_commandName isEqualTo "cd" && !_isDir) then
						{
							_include = false;  // cd only completes directories
						};

						// Match filename
						if (_include && {_filePart isEqualTo "" || {(_name select [0, count _filePart]) isEqualTo _filePart}}) then
						{
							private _fullPath = _dirPart + _name;
							if (_isDir) then { _fullPath = _fullPath + "/"; };  // Add / for directories
							_matches pushBack _fullPath;
						};
					};
				};
			} forEach _dirList;
		}
		catch
		{
			// Ignore errors from lsdir
		};
	};

	// Sort matches
	_matches sort true;
}
else
{
	// Word didn't change, use previous matches for cycling
	_matches = _prevMatches;
};

// Apply completion
if (count _matches == 0) exitWith
{
	// No matches - clear state
	_terminal deleteAt "AE3_autocompleteState";
};

private _newInput = "";

if (count _matches == 1) then
{
	// Single match - complete it fully
	private _match = _matches select 0;
	_newInput = _prefixBeforeWord + _match;

	// Add space after non-directory completions for convenience
	private _isDir = (_match select [(count _match) - 1]) isEqualTo "/";
	private _isCmd = (count _words <= 1) && !_endsWithSpace;

	if (!_isDir && _isCmd) then
	{
		_newInput = _newInput + " ";  // Add space after commands
	};

	// Clear state
	_terminal deleteAt "AE3_autocompleteState";
}
else
{
	// Multiple matches - complete to common prefix or cycle
	private _commonPrefix = _matches select 0;

	{
		private _match = _x;
		private _newCommon = "";
		private _minLen = (count _commonPrefix) min (count _match);

		for "_i" from 0 to (_minLen - 1) do
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

	// If common prefix is longer than what user typed, use it
	if ((count _commonPrefix) > (count _completionWord)) then
	{
		_newInput = _prefixBeforeWord + _commonPrefix;
		_terminal set ["AE3_autocompleteState", [_commonPrefix, _matches, -1]];
	}
	else
	{
		// Cycle through matches
		private _idx = (_prevIndex + 1) mod (count _matches);
		private _match = _matches select _idx;

		_newInput = _prefixBeforeWord + _match;
		_terminal set ["AE3_autocompleteState", [_match, _matches, _idx]];
	};
};

// Update terminal input
_terminal deleteAt "AE3_terminalInputBuffer";
private _buffer = ["", ""];
{
	_buffer set [0, (_buffer select 0) + (toString [_x])];
} forEach (toArray _newInput);
_terminal set ["AE3_terminalInputBuffer", _buffer];
