private ["_logic","_units","_userlistObjects"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then
{
	//--- Extract the user defined module arguments
	_user = _logic getVariable "AE3_ModuleUserlist_User";
	if(isNil "_user") exitWith {};

	_pwd = _logic getVariable ["AE3_ModuleUserlist_Password", ""];

	//--- Add Users to Computer
	{
		_userlist = _x getVariable ["AE3_Userlist", createHashMap];
		
		_userlist set [_user, _pwd];

		_x setVariable ["AE3_Userlist", _userlist, True];
	} foreach _units;
};

true