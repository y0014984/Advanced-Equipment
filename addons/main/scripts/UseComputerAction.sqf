params ["_target"];

if (!dialog) then
{
	_ok = createDialog "Hacking_Dialog";
	if (!_ok) then {hint "Dialog couldn't be opened!"};
};

_consoleDialog = findDisplay 15984;	
_consoleOutput = _consoleDialog displayCtrl 1100;
_consoleInput = _consoleDialog displayCtrl 1200;

_filesystem = _target getVariable [ "AE3_Filesystem", [["/Info.txt", "No Filesystem found!"]] ];

_pointer = "/";

_availableCommands = ["help", "man", "ls", "cd", "print", "date", "ipconfig", "shutdown", "standby", "history"];

_activeApplication = "LOGIN";

_ip = "127.0.0.1";

_history = _target getVariable ["history", []];

_users =
[
	["shebenst", "lala123"],
	["topsykrett", "test123"]
];

_consoleInput setVariable ["filesystem", _filesystem];
_consoleInput setVariable ["pointer", _pointer];
_consoleInput setVariable ["availableCommands", _availableCommands];
_consoleInput setVariable ["activeApplication", _activeApplication];
_consoleInput setVariable ["users", _users];
_consoleInput setVariable ["ip", _ip];
_consoleInput setVariable ["computer", _target];
_consoleInput setVariable ["history", _history];

_outputText = 
"armaOS Terminal v0.1 - © 2020 y0014984|Sebastian" + endl + 
"Get a list of available commands by typing 'help'" + endl + 
"Get detailed command informations by typing 'man <command>'" + endl + 
" " + endl;

switch (_activeApplication) do
{
	case "LOGIN": { _outputText = _outputText + " login: ";};
	case "PASSWORD": { _outputText = _outputText + " password: ";};
	case "SHELL": { _outputText = _outputText + _pointer + "> ";};
};

ctrlSetText [1100, _outputText];
ctrlSetFocus _consoleInput;

_result = _consoleInput ctrlAddEventHandler
[
	"KeyUp", 
	{
		params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

		if ((_key == 28) || (_key == 156)) then	
		{
			_outputText = ctrlText 1100;
			_inputText = ctrlText 1200;
			
			_consoleInput = _displayorcontrol;
			
			_activeApplication = _displayorcontrol getVariable "activeApplication";
			
			switch (_activeApplication) do
			{
				case "LOGIN": { _result = [_consoleInput, _inputText, _outputText] call AE3_fnc_login; };
				case "PASSWORD": { _result = [_consoleInput, _inputText, _outputText] call AE3_fnc_login; };
				case "SHELL": { _result = [_consoleInput, _inputText, _outputText] call AE3_fnc_shell; };
			};
		};
	}
];