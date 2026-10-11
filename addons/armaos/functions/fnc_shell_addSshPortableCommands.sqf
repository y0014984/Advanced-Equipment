// File: fnc_shell_addSshPortableCommands.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Registers executable names that may run inside an SSH session from the operator's own
 * computer when the target does not have them. The session's target stays the executing computer,
 * so such a tool acts on the remote device ("bring your own tools"). Lookup on the source computer
 * tries the typed path, then each registered search directory, then the directories listed in the
 * source computer's AE3_ssh_toolDirs variable. Registration is per machine; call it on every machine
 * (e.g. from preInit).
 *
 * Arguments:
 * 0: _names <ARRAY> - Executable file names (e.g. ["door", "light"])
 * 1: _searchDirs <ARRAY> (Optional, default: []) - Absolute directories to search on the source computer
 *
 * Return Value:
 * None
 *
 * Example:
 * [["door", "light"], ["/rubberducky/tools"]] call AE3_armaos_fnc_shell_addSshPortableCommands;
 *
 * Public: Yes
 */

params [["_names", [], [[]]], ["_searchDirs", [], [[]]]];

if (isNil "AE3_armaos_sshPortableCommands") then { AE3_armaos_sshPortableCommands = createHashMap; };

{
	private _dirs = AE3_armaos_sshPortableCommands getOrDefault [toLower _x, []];
	{ _dirs pushBackUnique _x; } forEach _searchDirs;
	AE3_armaos_sshPortableCommands set [toLower _x, _dirs];
} forEach _names;
