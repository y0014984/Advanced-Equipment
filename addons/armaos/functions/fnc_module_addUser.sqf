params['_logic', '_units', '_activated'];

if(!isServer) exitWith {};

[_logic, _units] spawn {
	params['_logic', '_units'];

	waitUntil { !isNil "BIS_fnc_init" };

	//--- Extract the user defined module arguments
	_user = _logic getVariable "AE3_ModuleUserlist_User";
	if(isNil "_user") exitWith {};

	_pwd = _logic getVariable ["AE3_ModuleUserlist_Password", ""];

	//--- Add Users to Computer
	{
		_userlist = _x getVariable ["AE3_Userlist", createHashMap];
		_filesystem = _x getVariable "AE3_filesystem";

		_userlist set [_user, _pwd];

		// Add user directory in /home/
		if(!(_user isEqualTo 'root')) then
		{
			try
			{
				[[], _filesystem, "/home/" + _user, 'root', _user] call AE3_filesystem_fnc_createDir;
			} catch { diag_log format ["AE3 exception: %1", _exception]; };
		};

		_x setVariable ["AE3_filesystem", _filesystem];
		_x setVariable ["AE3_Userlist", _userlist, true];
	} foreach _units;
};

true