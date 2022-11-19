class OsFunction
{
	path = "";
	description = "";
	man = "";
	code = "";
};

// DO NOT USE [] in Strings.

class CfgOsFunctions
{
	class man : OsFunction
	{
		path = "/bin/man";
		description = "Prints usage information about a command.";
		man = "Usage man: 'man [command]' returns usage information for the command.";
		code = "_this call AE3_armaos_fnc_os_man";
	};

	class help : OsFunction
	{
		path = "/bin/help";
		description = "Prints all installed programs.";
		man = "Usage help: 'help' returns a list of available programs. No options needed.";
		code = "_this call AE3_armaos_fnc_os_help";
	};

	class ls : OsFunction
	{
		path = "/bin/ls";
		description = "Display the content of a directory.";
		man = "Usage ls: 'ls [path]' returns a list of filesystem objects found in this path.";
		code = "_this call AE3_armaos_fnc_os_ls";
	};

	class cd : OsFunction
	{
		path = "/bin/cd";
		description = "Change the working directory.";
		man = "Usage cd: 'cd [path]' sets path as the new working directory.";
		code = "_this call AE3_armaos_fnc_os_cd";
	};

	class cat : OsFunction
	{
		path = "/bin/cat";
		description = "Prints the content of a file.";
		man = "Usage cat: 'cat [file]' shows the content of a file.";
		code = "_this call AE3_armaos_fnc_os_cat";
	};

	class date : OsFunction
	{
		path = "/bin/date";
		description = "Prints the date.";
		man = "Usage date: 'date' prints the actual date in format YYYY-MM-DD HH:MM:SS";
		code = "_this call AE3_armaos_fnc_os_date";
	};

	class history : OsFunction
	{
		path = "/bin/history";
		description = "Prints the terminal history.";
		man = "Usage history: 'history' lists last commands since the start of the computer.";
		code = "_this call AE3_armaos_fnc_os_history";
	};

	class clear : OsFunction
	{
		path = "/bin/clear";
		description = "Clears the terminal history.";
		man = "Usage clear: 'clear' deletes most of the displayed text.";
		code = "_this call AE3_armaos_fnc_os_clear";
	};

	class rm : OsFunction
	{
		path = "/bin/rm";
		description = "Removes a file.";
		man = "Usage rm: 'rm [path]' deletes a file at the given path.";
		code = "_this call AE3_armaos_fnc_os_rm";
	};

	class mv : OsFunction
	{
		path = "/bin/mv";
		description = "Moves a file or folder.";
		man = "Usage mv: 'mv [old path] [new path]' moves file to new path or renames the file.";
		code = "_this call AE3_armaos_fnc_os_mv";
	};

	class whoami : OsFunction
	{
		path = "/bin/whoami";
		description = "Retuns the current user.";
		man = "Usage whoami: 'whoami' returns the current user.";
		code = "_this call AE3_armaos_fnc_os_whoami";
	};

	class mkdir : OsFunction
	{
		path = "/bin/mkdir";
		description = "Creates a directory/folder.";
		man = "Usage standby: 'mkdir [path]' creates a new folder/directory.";
		code = "_this call AE3_armaos_fnc_os_mkdir";
	};

	class ping : OsFunction
	{
		path = "/sbin/ping";
		description = "Pings the given address.";
		man = "Usage ping: 'ping' pings the given address.";
		code = "_this call AE3_armaos_fnc_os_ping";
	};

	class ipconfig : OsFunction
	{
		path = "/sbin/ipconfig";
		description = "Returns the current ip configuration.";
		man = "Usage ipconfig: 'ipconfig' returns the current ip configuration.";
		code = "_this call AE3_armaos_fnc_os_ipconfig";
	};

	class exit : OsFunction
	{
		path = "/sbin/exit";
		description = "Log out of the user session.";
		man = "Usage exit: 'exit' brings you back to login screen.";
		code = "_this call AE3_armaos_fnc_os_exit";
	};

	class shutdown : OsFunction
	{
		path = "/sbin/shutdown";
		description = "Shuts down the computer.";
		man = "Usage shutdown: 'shutdown' turns off the computer.";
		code = "_this call AE3_armaos_fnc_os_shutdown";
	};

	class standby : OsFunction
	{
		path = "/sbin/standby";
		description = "Puts the computer in standby mode.";
		man = "Usage standby: 'standby' activates the computers standby mode.";
		code = "_this call AE3_armaos_fnc_os_standby";
	};

	class echo : OsFunction
	{
		path = "/bin/echo";
		description = "Print/output a line of text to stdout.";
		man = "Usage echo: 'echo [text]' prints the given text to stdout.";
		code = "_this call AE3_armaos_fnc_os_echo";
	};

	class crypto : OsFunction
	{
		path = "/bin/crypto";
		description = "Encrypts/decrypts text with a given algorythm and key.";
		man = "Usage echo: 'crypto -a [algorythm] -k [key] -m [mode] [text]' prints the processed text to stdout.";
		code = "_this call AE3_armaos_fnc_os_crypto";
	};
	class crack : OsFunction
	{
		path = "/bin/crack";
		description = "Trys to decrypt text with a given algorythm using multiple methods like bruteforce or statistics.";
		man = "Usage echo: 'crack -a [algorythm] -m [mode] [text]' prints the results to stdout.";
		code = "_this call AE3_armaos_fnc_os_crack";
	};
	class find : OsFunction
	{
		path = "/bin/find";
		description = "Searches in the current directory for a file with the given name.";
		man = "Usage echo: 'find [filename]' prints the results to stdout.";
		code = "_this call AE3_armaos_fnc_os_find";
	};
};