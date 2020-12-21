params ["_options", "_consoleInput"];

_result = [];

_optionsCount = count _options;

scopeName "main";

switch (true) do
{
	case (_optionsCount >= 1):
	{
		//hint "Case 1";
		
		_result = ["   Command: logout has no options"];
		_result breakOut "main";
	};
	case (_optionsCount == 0):
	{
		//hint "Case 2";

		_computer = _consoleInput getVariable "computer";

		_computer setVariable ["activeUser", nil];
		_consoleInput setVariable ["activeApplication", "LOGIN"];

		_outputArray = _outputText splitString endl;

		_result = ["   Command: logout"];
	};
};

_result;