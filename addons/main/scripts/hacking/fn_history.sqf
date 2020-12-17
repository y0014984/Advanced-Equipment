params ["_options", "_consoleInput"];

_history = _consoleInput getVariable "history";
_computer = _consoleInput getVariable "computer";

_result = [];

_optionsCount = count _options;

scopeName "main";

switch (true) do
{
	case (_optionsCount >= 1):
	{
		//hint "Case 1";
		
		_result = ["   Command: history has no options"];
		_result breakOut "main";
	};
	case (_optionsCount == 0):
	{
		//hint "Case 2";

		_computer setVariable ["history", _history, true];

		_numberedHistory = [];
		{
			_numberedHistory pushBack (format ["%1: %2", (_forEachIndex + 1), _x]);
		} forEach _history;

		_result = ["   Command: history "] + [" "] + _numberedHistory;
	};
};

_result;