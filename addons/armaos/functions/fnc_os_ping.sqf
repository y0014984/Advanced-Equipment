params ["_options", "_consoleInput"];

_ip = _consoleInput getVariable "ip";

_optionsCount = count _options;

_ipPing = "";
if (_optionsCount > 0) then 
{
	_ipPing = _options select 0;
};

_result = [];

scopeName "main";

switch (true) do
{
	case (_optionsCount > 1):
	{
		_result = ["   Command: ping - too many options"];
		_result breakOut "main";
	};
	case (_optionsCount == 0):
	{
		_result = ["   Command: ping - too few options"];
		_result breakOut "main";
	};
	case (_optionsCount == 1):
	{
		switch (true) do 
		{
			case (_ipPing isEqualTo _ip):
			{
				_result = [ format ["   Command: ping %1 - 0 ms / packet loss 0%2", _ipPing, "%"] ];
				_result breakOut "main";
			};
			case (_ip isEqualTo "127.0.0.1"):
			{
				_result = ["   Command: ping - missing network connection"];
				_result breakOut "main";
			};
			default
			{
				_computer = _consoleInput getVariable ["computer", nil];
				if (!isNil "_computer") then
				{
					_router = _computer getVariable ["AE3_networkCableDevice", nil];
					if (!isNil "_router") then
					{
						_connectedDevices = _router getVariable ["AE3_power_connectedDevices", []];
						_matchingComputerIndex = _connectedDevices findIf { (_x getVariable ["AE3_ipAddress", "127.0.0.1"]) isEqualTo _ipPing };

						if (_matchingComputerIndex != -1) then 
						{
							_matchingComputer = _connectedDevices select _matchingComputerIndex;
							
							if (_matchingComputer getVariable ["AE3_power_powerState", 0] == 1) then
							{
								_result = [ format ["   Command: ping %1 - 5 ms / packet loss 0%2", _ipPing, "%"] ];
								_result breakOut "main";
							}
							else 
							{
								_result = [ format ["   Command: ping %1 - no answer / packet loss 100%2", _ipPing, "%"] ];
								_result breakOut "main";
							};
						}
						else 
						{
							_result = [ format ["   Command: ping %1 - no route to host", _ipPing] ];
							_result breakOut "main";
						};
					};
				};
			};
		};
	};
};

_result;