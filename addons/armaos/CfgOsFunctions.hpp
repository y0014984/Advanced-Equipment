class OsFunction
{
	path = "";
	description = "";
	man = "";
	code = "";
};

class CfgOsFunctions
{
	class man : OsFunction
	{
		path = "/bin/man";
		description = "Prints usage information about a command.";
		man = "Usage man: 'man <command>' returns usage informations for the command.";
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
		man = "Usage ls: 'ls <path>' returns a list of filesystem items found in this path.";
		code = "_this call AE3_armaos_fnc_os_ls";
	};

	class cd : OsFunction
	{
		path = "/bin/cd";
		description = "Change the working directory.";
		man = "Usage cd: 'cd <path>' sets path as the new working directory.";
		code = "_this call AE3_armaos_fnc_os_cd";
	};

	class print : OsFunction
	{
		path = "/bin/print";
		description = "Print the content of a file to std out.";
		man = "Usage print: 'print <file>' shows the content of a file.";
		code = "_this call AE3_armaos_fnc_os_print";
	};

	class cat : OsFunction
	{
		path = "/bin/print";
		description = "Print the content of a file to std out.";
		man = "Usage print: 'print <file>' shows the content of a file.";
		code = "_this call AE3_armaos_fnc_os_print";
	};

	class date : OsFunction
	{
		path = "/bin/date";
		description = "Prints the date to std out.";
		man = "Usage date: 'date' prints the actual date in format YYYY-MM-DD HH:MM:SS";
		code = "_this call AE3_armaos_fnc_os_date";
	};

	class history : OsFunction
	{
		path = "/bin/history";
		description = "Prints the terminal history to std. out.";
		man = "Usage history: 'history' lists last commands since the start of the computer.";
		code = "_this call AE3_armaos_fnc_os_history";
	};

	class clear : OsFunction
	{
		path = "/bin/clear";
		description = "Clears the terminal history.";
		man = "Usage clear: 'clear deletes most of the displayed text.";
		code = "_this call AE3_armaos_fnc_os_clear";
	};

	class rm : OsFunction
	{
		path = "/bin/rm";
		description = "Removes a file.";
		man = "Usage rm: 'rm <path>' deletes a file at the given path.";
		code = "_this call AE3_armaos_fnc_os_rm";
	};

	class mv : OsFunction
	{
		path = "/bin/rm";
		description = "Moves a file or folder.";
		man = "Usage mv: 'mv <old path> <new path>' moves file to new path or renames the file.";
		code = "_this call AE3_armaos_fnc_os_mv";
	};


	class logout : OsFunction
	{
		path = "/sbin/logout";
		description = "Log out of the user session.";
		man = "Usage logout: 'logout' brings you back to login screen.";
		code = "_this call AE3_armaos_fnc_os_logout";
	};

	class exit : OsFunction
	{
		path = "/sbin/logout";
		description = "Log out of the user session.";
		man = "Usage logout: 'logout' brings you back to login screen.";
		code = "_this call AE3_armaos_fnc_os_logout";
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
};