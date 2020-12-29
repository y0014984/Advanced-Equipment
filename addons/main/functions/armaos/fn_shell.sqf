params ["_consoleInput", "_inputText", "_outputText"];

_commandElements = _inputText splitString " ";
_command = _commandElements select 0;
_options = _commandElements select [1, (count _commandElements) - 1];

_result = [];

_availableCommands = _consoleInput getVariable "availableCommands";

switch (_command) do
{
	case "help": { _result = [format ["   Available commands: %1", _availableCommands joinString ", "]]; };
	case "man": { _result = [_options, _consoleInput] call AE3_fnc_man; };
	case "ls": { _result = [_options, _consoleInput] call AE3_fnc_ls; };
	case "cd": { _result = [_options, _consoleInput] call AE3_fnc_cd; };
	case "print": { _result = [_options, _consoleInput] call AE3_fnc_print; };
	case "date": { _result = [_options, _consoleInput] call AE3_fnc_date; };
	case "ipconfig": { _result = [_options, _consoleInput] call AE3_fnc_ipconfig; };
	case "shutdown": { _result = [_options, _consoleInput] call AE3_fnc_shutdown; };
	case "standby": { _result = [_options, _consoleInput] call AE3_fnc_standby; };
	case "history": { _result = [_options, _consoleInput] call AE3_fnc_history; };
	case "logout": { _result = [_options, _consoleInput] call AE3_fnc_logout; };
	case "ping": { _result = [_options, _consoleInput] call AE3_fnc_ping; };
	case "clear": { _result = [_options, _consoleInput] call AE3_fnc_clear; };
	case "rm": { _result = [_options, _consoleInput] call AE3_fnc_rm; };
	case "mv": { _result = [_options, _consoleInput] call AE3_fnc_mv; };
	default { _result = [format ["   Command '%1' not found.", _command]]; };
};

_result = [" "] + _result + [" "];
_pointer = _consoleInput getVariable "pointer";

_outputText = ctrlText 1100;
_outputArray = _outputText splitString endl;

_prompt = _outputArray select ((count _outputArray) - 1);
_outputArray resize ((count _outputArray) - 1);
_outputArray append [_prompt + _inputText];

_outputArray append _result;
_outputArray append [_pointer + "> "];

if (_command isEqualTo "clear") then
{
	_outputArray = _outputText splitString endl;
};

if (_command isEqualTo "logout") then
{
	_outputText = [] call AE3_fnc_headerText;
	_result = [" "];

	_outputText = _outputText + " login: ";

	_outputArray = _outputText splitString endl;
};


if ((count _outputArray) > 21) then {_outputArray deleteRange [0, (count _outputArray) - 21];};
_outputText = _outputArray joinString endl;

ctrlSetText [1100, _outputText];
ctrlSetText [1200, ""];

_history = _consoleInput getVariable "history";
_history pushBack _inputText;
_consoleInput setVariable ["history", _history];