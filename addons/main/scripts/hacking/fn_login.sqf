// [_consoleInput, _inputText, _outputText] call Y00_fnc_login;

params ["_consoleInput", "_inputText", "_outputText"];

_users = _consoleInput getVariable "users";

hint format ["%1", _users];

{
	if ((_x select 0) isEqualTo _inputText) then
	{
		_outputArray = _outputText splitString endl;
		_prompt = _outputArray select ((count _outputArray) - 1);
		_outputArray resize ((count _outputArray) - 1);
		_outputArray append [_prompt + _inputText];
		_outputArray append [" password> "];
		
		if ((count _outputArray) > 21) then {_outputArray deleteRange [0, (count _outputArray) - 21];};
		
		_outputText = _outputArray joinString endl;
		
		ctrlSetText [1100, _outputText];
		ctrlSetText [1200, ""];
	}
	else
	{
		_outputArray = _outputText splitString endl;
		_prompt = _outputArray select ((count _outputArray) - 1);
		_outputArray resize ((count _outputArray) - 1);
		_outputArray append [_prompt + _inputText + " - user not found"];
		_outputArray append [_prompt];
		
		if ((count _outputArray) > 21) then {_outputArray deleteRange [0, (count _outputArray) - 21];};
		
		_outputText = _outputArray joinString endl;
		
		ctrlSetText [1100, _outputText];
		ctrlSetText [1200, ""];
	};
} forEach _users;