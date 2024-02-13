/**
 * Prints the filesystem tree with the current working directory as root to stadout.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 * 3: Command Name <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_options", "_commandName"];

/* ================================================================================ */

private _fnc_tree_recursive =
{
    params ["_pointer", "_filesystem", "_user", "_level", ["_missingPermissions", 0]];

    private _content = _filesystem select 0; // HASHMAP
    private _owner = _filesystem select 1; // STRING
    private _permissions = _filesystem select 2; // ARRAY

    private _totalResults = [];

    private _permissionNeeded = 1; // (0: Execute, 1: Read, 2: Write)

    try
    {
        // function does not return a bool but throws an exception if permissions insufficient
        [_filesystem, _user, _permissionNeeded] call AE3_filesystem_fnc_hasPermission;

        {
            // Hashmap forEach variables: KEY = _x && VALUE = _y

            private _treeString = "";
            
            for "_i" from 0 to (_level - 1) do  
            {  
                _treeString = _treeString + "|  ";  
            };  
            _treeString = _treeString + "|--";

            _totalResults pushBack (_treeString + _x);
            
            if ((typeName (_y select 0)) isEqualTo "HASHMAP") then
            {
                private _currentPointer = +_pointer;
                _currentPointer pushBack _x;

                private _result = [_currentPointer, _y, _user, _level + 1, _missingPermissions] call _fnc_tree_recursive;

                private _subResults = _result select 0;
                _missingPermissions = _result select 1;

                _totalResults append _subResults;
            };
        } forEach _content;

    } catch { _missingPermissions = _missingPermissions + 1; };

    [_totalResults, _missingPermissions];
};

/* ================================================================================ */

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _current = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;

private _terminal = _computer getVariable "AE3_terminal";
private _user = _terminal get "AE3_terminalLoginUser";

private _level = 0;

private _result = [_pointer, _current, _user, _level] call _fnc_tree_recursive;

private _totalResults = _result select 0;
private _missingPermissions = _result select 1;

if (_missingPermissions > 0) then
{
	_totalResults append [format [localize "STR_AE3_ArmaOS_Exception_CantScanFolderMissionPermissions", _missingPermissions]];
};

[_computer, "."] call AE3_armaos_fnc_shell_stdout;

[_computer, _totalResults] call AE3_armaos_fnc_shell_stdout;