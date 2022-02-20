params['_logic', '_units', '_activated'];

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
		
		_userlist set [_user, _pwd];

		// Add user directory in /home/
		if(!(_user isEqualTo 'root')) then
		{
			try
			{
				[[], _x getVariable 'AE3_filesystem', "/home/" + _user, 'root', _user] call AE3_filesystem_fnc_createDir;
			} catch {};
		};

		_x setVariable ["AE3_Userlist", _userlist, True];
	} foreach _units;
};

true