params ["_options", "_consoleInput"];

_ip = _consoleInput getVariable "ip";
_computer = _consoleInput getVariable "computer";
_router = _consoleInput getVariable ["AE3_networkCableDevice", nil];

if (!isNil "_router") then 
{
	if (_router getVariable ["AE3_power_powerConsumptionState", 0] == 0) then { _ip = "127.0.0.1" };
};


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