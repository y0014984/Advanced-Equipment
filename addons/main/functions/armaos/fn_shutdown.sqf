params ["_options", "_consoleInput"];

_computer = _consoleInput getVariable "computer";

_result = [];

_optionsCount = count _options;

scopeName "main";

switch (true) do
{
	case (_optionsCount >= 1):
	{
		//hint "Case 1";
		
		_result = ["   Command: shutdown has no options"];
		_result breakOut "main";
	};
	case (_optionsCount == 0):
	{
		//hint "Case 2";

		_handle = [_computer, false] execVM '\z\ae3\addons\main\scripts\TurnOffComputerAction.sqf';

		_result = ["   Command: shutdown "];
	};
};

_result;