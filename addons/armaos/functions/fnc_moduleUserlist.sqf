private ["_logic","_units","_userlistObjects"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then
{
	//--- Extract the user defined module arguments
	_userlistObjects = [];
	_userlistObjects pushBack ([_logic getVariable ["AE3_ModuleUserlist_User1", ""], _logic getVariable ["AE3_ModuleUserlist_Password1", ""]]);
	_userlistObjects pushBack ([_logic getVariable ["AE3_ModuleUserlist_User2", ""], _logic getVariable ["AE3_ModuleUserlist_Password2", ""]]);
	_userlistObjects pushBack ([_logic getVariable ["AE3_ModuleUserlist_User3", ""], _logic getVariable ["AE3_ModuleUserlist_Password3", ""]]);
	_userlistObjects pushBack ([_logic getVariable ["AE3_ModuleUserlist_User4", ""], _logic getVariable ["AE3_ModuleUserlist_Password4", ""]]);
	_userlistObjects pushBack ([_logic getVariable ["AE3_ModuleUserlist_User5", ""], _logic getVariable ["AE3_ModuleUserlist_Password5", ""]]);

	//--- Add Users to Laptop
	{
		_userlist = _x getVariable ["AE3_Userlist", []];
		{
			_userlist pushBack _x;
		} forEach _userlistObjects;
		_x setVariable ["AE3_Userlist", _userlist];
	} foreach _units;

};

true