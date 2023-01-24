/**
 * Initilizes all hacking commands defined in CfgHackingCommands.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 *
 * Returns:
 * None
 */

params["_computer"];

if(!isServer) exitWith {};

private _filesystem = _computer getVariable "AE3_filesystem";

private _config = configFile >> "CfgHackingCommands";

private _hackingCommands = ("inheritsFrom _x == (configFile >> 'OsFunction')" configClasses _config);

{
	try
	{
		[[], _filesystem, (getText (_x >> "path")), (compile getText (_x >> "code")), 'root', 'root',
		[[true, true, true], [true, false, false]]] call AE3_filesystem_fnc_createFile;
	}catch {};

	[_computer, configName _x , getText (_x >> "path"), getText (_x >> "description"), getText (_x >> "man")] call AE3_armaos_fnc_link_add;

} forEach _hackingCommands;

_computer setVariable ["AE3_filesystem", _filesystem];