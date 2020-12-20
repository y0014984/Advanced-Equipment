private ["_logic","_units","_filesystemObjects"];

_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then
{
	//--- Extract the user defined module arguments
	_filesystemObjects = [];
	_filesystemObjects pushBack ([_logic getVariable ["AE3_ModuleFilesystem_FilesystemObject1", ""], _logic getVariable ["AE3_ModuleFilesystem_FilesystemContent1", ""]]);
	_filesystemObjects pushBack ([_logic getVariable ["AE3_ModuleFilesystem_FilesystemObject2", ""], _logic getVariable ["AE3_ModuleFilesystem_FilesystemContent2", ""]]);
	_filesystemObjects pushBack ([_logic getVariable ["AE3_ModuleFilesystem_FilesystemObject3", ""], _logic getVariable ["AE3_ModuleFilesystem_FilesystemContent3", ""]]);
	_filesystemObjects pushBack ([_logic getVariable ["AE3_ModuleFilesystem_FilesystemObject4", ""], _logic getVariable ["AE3_ModuleFilesystem_FilesystemContent4", ""]]);
	_filesystemObjects pushBack ([_logic getVariable ["AE3_ModuleFilesystem_FilesystemObject5", ""], _logic getVariable ["AE3_ModuleFilesystem_FilesystemContent5", ""]]);

	//--- Add FileSystem Objects to Laptop Filesystem
	{
		_filesystem = _x getVariable ["AE3_Filesystem", []];
		{
			_filesystem pushBack _x;
		} forEach _filesystemObjects;
		_x setVariable ["AE3_Filesystem", _filesystem];
	} foreach _units;

};

true