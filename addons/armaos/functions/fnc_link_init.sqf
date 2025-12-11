/*
 * Author: Root
 * Description: Initializes command links from config for a computer, loading all available commands.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _configFile <STRING> - TODO: Add description
 * 2: _commandList <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _configFile, _commandList] call AE3_armaos_fnc_link_init;
 *
 * Public: No
 */

params["_computer", ["_configFile", "CfgOsFunctions"], ["_commandList", ["all"]]];

if(!isServer) exitWith {};

// Clear existing links to prevent "Link already exists" errors on re-initialization
_computer setVariable ["AE3_Links", createHashMap, true];

private _filesystem = _computer getVariable "AE3_filesystem";

private _config = configFile >> _configFile;

private _functions = ("inheritsFrom _x == (configFile >> 'OsFunction')" configClasses _config);

{
	private _commandName = configName _x;

	if ((_commandList isEqualTo ["all"]) || (_commandName in _commandList)) then
	{
		try
		{
			[[], _filesystem, (getText (_x >> "path")), (compile getText (_x >> "code")), "root", "root",
			[[true, true, true], [true, false, false]]] call AE3_filesystem_fnc_createFile;
		}catch {};

		[_computer, _commandName, getText (_x >> "path"), getText (_x >> "description"), getText (_x >> "man")] call AE3_armaos_fnc_link_add;
	};

} forEach _functions;

_computer setVariable ["AE3_filesystem", _filesystem];
