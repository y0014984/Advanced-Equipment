params ["_consoleInput", "_inputText", "_outputText"];

_users = _consoleInput getVariable "users";
_activeApplication = _consoleInput getVariable "activeApplication";
_activeUser = _consoleInput getVariable ["activeUser", ""];

//hint format ["%1", _users];

/* ---------------------------------------- */

if (_activeApplication isEqualTo "LOGIN") then
{
	_usernameFound = false;

	{
		scopeName "user";

		_username = _x select 0;

		if (_username isEqualTo _inputText) then
		{
			_consoleInput setVariable ["activeUser", _username];
			_consoleInput setVariable ["activeApplication", "PASSWORD"];

			_usernameFound = true; 

			breakOut "user";
		};
	} forEach _users;

	_outputArray = _outputText splitString endl;
	_prompt = _outputArray select ((count _outputArray) - 1);
	_outputArray resize ((count _outputArray) - 1);

	if (_usernameFound) then
	{
		_outputArray append [_prompt + _inputText];
		_outputArray append [" password: "];
	}
	else
	{
		_outputArray append [_prompt + _inputText + " - user not found"];
		_outputArray append [_prompt];
	};
	
	if ((count _outputArray) > 21) then {_outputArray deleteRange [0, (count _outputArray) - 21];};
	
	_outputText = _outputArray joinString endl;
	
	ctrlSetText [1100, _outputText];
	ctrlSetText [1200, ""];
};

/* ---------------------------------------- */

if (_activeApplication isEqualTo "PASSWORD") then
{
	_passwordFound = false;

	{
		scopeName "password";

		_username = _x select 0;
		_password = _x select 1;

		if ((_username isEqualTo _activeUser) && (_password isEqualTo _inputText)) then
		{
			_computer = _consoleInput getVariable "computer";
			
			_computer setVariable ["passwordCorrect", true];
			_computer setVariable ["activeUser", _username];

			_consoleInput setVariable ["activeApplication", "SHELL"];

			_passwordFound = true;

			breakOut "password";
		}
		else
		{
			_consoleInput setVariable ["activeApplication", "LOGIN"];
		};
	} forEach _users;
	
	_outputArray = _outputText splitString endl;
	_prompt = _outputArray select ((count _outputArray) - 1);
	_outputArray resize ((count _outputArray) - 1);

	if (_passwordFound) then
	{
		_outputArray append [_prompt + _inputText];
		_outputArray append ["/> "];
	}
	else
	{
		_outputArray append [_prompt + _inputText + " - password not correct"];
		_outputArray append [" login: "];
	};

	if ((count _outputArray) > 21) then {_outputArray deleteRange [0, (count _outputArray) - 21];};
	
	_outputText = _outputArray joinString endl;

	ctrlSetText [1100, _outputText];
	ctrlSetText [1200, ""];
};

/* ---------------------------------------- */
