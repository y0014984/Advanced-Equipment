params ["_options", "_consoleInput"];

_availableCommands = _consoleInput getVariable "availableCommands";

_result = [];

_optionsCount = count _options;

scopeName "main";

switch (true) do
{
	case (_optionsCount > 1):
	{
		//hint "Case 1";
		
		_result = ["   Command: man too many options"];
		_result breakOut "main";
	};
	case (_optionsCount == 1):
	{
		//hint "Case 2";
		
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
			case "shutdown": { _result = ["   Usage shutdown: 'shutdown' turns off the computer"]; };
			case "standby": { _result = ["   Usage standby: 'standby' activates the computers standby mode"]; };
			case "history": { _result = ["   Usage history: 'history' lists last commands since the start of the computer"]; };
			default { _result = [format ["   Command '%1' not found.", _command]]; };
		};
	};
	case (_optionsCount == 0):
	{
		//hint "Case 3";
		
		_result = ["   Command: man too few options"];
		_result breakOut "main";
	};
};

_result;