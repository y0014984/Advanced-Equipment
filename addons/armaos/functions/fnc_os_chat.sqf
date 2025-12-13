/*
 * Author: Root, y0014984, Wasserstoff
 * Description: DEPRECATED - This function is not implemented yet and needs to be rewritten. Was intended for network chat between computers.
 *
 * Arguments:
 * 0: _options <ARRAY> - Command options and arguments
 * 1: _consoleInput <HASHMAP> - Console input data
 *
 * Return Value:
 * Result messages <ARRAY>
 *
 * Example:
 * [["192.168.1.2", "message"], _consoleInput] call AE3_armaos_fnc_os_chat;
 *
 * Public: No
 */

//This function is not implemented yet and needs to be rewritten - y0014984 2022-10-21

params ["_options", "_consoleInput"];

private _ip = _consoleInput getVariable "ip";

private _optionsCount = count _options;

private _ipPing = "";
if (_optionsCount > 0) then
{
	_ipPing = _options select 0;
};

private _result = [];

scopeName "main";

switch (true) do
{
	case (_optionsCount > 2):
	{
		_result = ["   Command: chat - too many options"];
		_result breakOut "main";
	};
	case (_optionsCount <= 1):
	{
		_result = ["   Command: chat - too few options"];
		_result breakOut "main";
	};
	case (_optionsCount == 2):
	{
		switch (true) do 
		{
			case (_ipPing isEqualTo _ip):
			{
				_result = ["   Command: chat - no local connection allowed"];
				_result breakOut "main";
			};
			case (_ip isEqualTo "127.0.0.1"):
			{
				_result = ["   Command: chat - missing network connection"];
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
								if (dialog) then
								{
									_ok = createDialog "AE3_ArmaOS_Waiting_Dialog";
									if (!_ok) then {hint "Dialog couldn't be opened!"};
								};
								
								_waitingTimer = 5;

								while {dialog && _waitingTimer > 0} do 
								{
									_waitingTimer = _waitingTimer - 1;

									sleep 1;
								};

								_result = [ format ["   Command: chat %1 - connection established", _ipPing] ];
								_result breakOut "main";
							}
							else 
							{
								_result = [ format ["   Command: chat %1 - no answer / packet loss 100%2", _ipPing, "%"] ];
								_result breakOut "main";
							};
						}
						else 
						{
							_result = [ format ["   Command: chat - no route to host"] ];
							_result breakOut "main";
						};
					};
				};
			};
		};
	};
};

_result;
