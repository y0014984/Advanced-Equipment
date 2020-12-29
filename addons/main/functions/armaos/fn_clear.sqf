params ["_options", "_consoleInput"];

_result = [];

_optionsCount = count _options;

scopeName "main";

switch (true) do
{
	case (_optionsCount >= 1):
	{
		//hint "Case 1";
		
		_result = ["   Command: clear has no options"];
		_result breakOut "main";
	};
	case (_optionsCount == 0):
	{
		//hint "Case 2";

		_outputText = [] call AE3_fnc_headerText;
		_pointer = _consoleInput getVariable "pointer";
		_outputText = _outputText + _pointer + "> ";

		ctrlSetText [1100, _outputText];

		_result = [" "];
	};
};

_result;