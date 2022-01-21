/**
 * Prints/outputs informatioms about a given shell command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Command <[STRING]>
 *
 * Results:
 * 1: Informations <[STRING]>
 */

params ["_computer", "_options"];

private _availableCommands = [] call AE3_armaos_fnc_shell_getAvailableCommands;

private _result = [];

if (count _options > 1) exitWith {["   Command: mv - too many options"];};
if (count _options < 1) exitWith {["   Command: rm - too few options"];};

_command = _options select 0;

switch (_command) do
{
	case "help": { _result = ["   Usage help: 'help' returns a list of available commands. No options needed."]; };
	case "man": { _result = ["   Usage man: 'man <command>' returns usage informations for the command."]; };
	case "ls": { _result = ["   Usage ls: 'ls <path>' returns a list of filesystem items found in this path."]; };
	case "cd": { _result = ["   Usage cd: 'cd <path>' sets path as the new working directory."]; };
	case "print": { _result = ["   Usage print: 'print <file>' shows the content of a file."]; };
	case "date": { _result = ["   Usage date: 'date' prints the actual date in format YYYY-MM-DD HH:MM:SS"]; };
	case "ipconfig": { _result = ["   Usage ipconfig: 'ipconfig' prints the actual ip address in format XXX.XXX.XXX.XXX"]; };
	case "shutdown": { _result = ["   Usage shutdown: 'shutdown' turns off the computer."]; };
	case "standby": { _result = ["   Usage standby: 'standby' activates the computers standby mode."]; };
	case "history": { _result = ["   Usage history: 'history' lists last commands since the start of the computer."]; };
	case "logout": { _result = ["   Usage logout: 'logout' brings you back to login screen."]; };
	case "ping": { _result = ["   Usage ping: 'ping <ip address ###.###.###.###>' tries to reach another computer."]; };
	case "chat": { _result = ["   Usage chat: 'chat <ip address ###.###.###.###> <pseudonym>' to establish chat connection with another computer."]; };
	case "clear": { _result = ["   Usage clear: 'clear deletes most of the displayed text."]; };
	case "rm": { _result = ["   Usage rm: 'rm <path>' deletes a file at the given path."]; };
	case "mv": { _result = ["   Usage mv: 'mv <old path> <new path>' moves file to new path or renames the file."]; };
	default { _result = [format ["   Command '%1' not found.", _command]]; };
};

_result;