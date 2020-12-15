params ["_target"];

if (!dialog) then
{
	_ok = createDialog "Hacking_Dialog";
	if (!_ok) then {hint "Dialog couldn't be opened!"};
};

_consoleDialog = findDisplay 15984;	
_consoleOutput = _consoleDialog displayCtrl 1100;
_consoleInput = _consoleDialog displayCtrl 1200;

_filesystem =
[
	["/Documents/Orders/Directive-345.txt", ["Directive 345", "-----", "Vorwärts immer, rückwärts nimmer!"]],
	["/Documents/Orders/Directive-25.txt", ["Directive-25", "-----", "Es gibt nichts gutes, außer man tut es!"]],
	["/Documents/Orders/Directive-666.txt", ["Directive-666", "-----", "Lieber ein Spatz in der Hand, als eine Taube auf dem Dach."]],
	["/Files/Notes/Cameras.txt", ["Camera List", "----", "Camera 1 124-235-5", "Camera 2 434-121-1", "Camera 3 323-123-4"]],
	["/Files/Notes/Fence.txt", ["Fence.txt"]],
	["/Files/Reports/Hill-245.txt", ["Hill-245.txt"]],
	["/Files/Reports/Top-Secret/Vanilla.txt", ["Vanilla.txt"]],
	["/Files/Reports/Phantomas.txt", ["Phantomas.txt"]],
	["/Users/Miller/Passwords.txt", ["Passwords.txt"]]
];

_pointer = "/";

_availableCommands = ["help", "man", "ls", "cd", "print"];

_activeApplication = "SHELL";

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

_outputText = 
"armaOS Terminal v0.1 - © 2020 y0014984|Sebastian" + endl + 
"Get a list of available commands by typing 'help'" + endl + 
"Get detailed informations by typing 'man <command>'" + endl + 
" " + endl;

switch (_activeApplication) do
{
	case "LOGIN": { _outputText = _outputText + " login> ";};
	case "SHELL": { _outputText = _outputText + " " + _pointer + "> ";};
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
				case "SHELL": { _result = [_consoleInput, _inputText, _outputText] call AE3_fnc_shell; };
			};
		};
	}
];