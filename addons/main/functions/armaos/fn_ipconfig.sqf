params ["_options", "_consoleInput"];

_ip = _consoleInput getVariable "ip";

_result = [];

_optionsCount = count _options;

scopeName "main";

switch (true) do
{
	case (_optionsCount >= 1):
	{
		//hint "Case 1";
		
		_result = ["   Command: ipconfig has no options"];
		_result breakOut "main";
	};
	case (_optionsCount == 0):
	{
		//hint "Case 2";

		_result = ["   Command: ipconfig "] + [" "] + [_ip];
	};
};

_result;