/**
 * Initilizes all programms defined in CfgOsFunctions. Alternatively, you can choose another config file. Also you can provide
 * a list of commands, that should be imported instead of all commands in the config file.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: Alternative Config File <STRING> (Optional)
 * 2: Command List <ARRAY> (Optional)
 *
 * Returns:
 * None
 */

params["_computer", ["_configFile", "CfgOsFunctions"], ["_commandList", ["all"]]];

if(!isServer) exitWith {};

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