/**
 * Adds a file, configured via addFile module, to the filesystem of every synced object.
 *
 * Arguments:
 * 0: Module <OBJECT>
 * 1: Synced Units [<OBJECT>]
 *
 * Results:
 * None
 */

params ["_module", "_syncedUnits"];

if (!isServer) exitWith {};

private _syncedObjects = synchronizedObjects _module;

private _path = _module getVariable "AE3_Module_AddFile_Path";
private _content = _module getVariable "AE3_Module_AddFile_Content";
private _isFunction = _module getVariable "AE3_Module_AddFile_IsFunction";
private _owner = _module getVariable "AE3_Module_AddFile_Owner";
private _permissions =
[
	[
		_module getVariable "AE3_Module_AddFile_OwnerExecute",
		_module getVariable "AE3_Module_AddFile_OwnerRead",
		_module getVariable "AE3_Module_AddFile_OwnerWrite"
	],
	[
		_module getVariable "AE3_Module_AddFile_EveryoneExecute",
		_module getVariable "AE3_Module_AddFile_EveryoneRead",
		_module getVariable "AE3_Module_AddFile_EveryoneWrite"
	]
];

private _isEncrypted = _module getVariable "AE3_Module_AddFile_IsEncrypted";
private _encryptionAlgorithm = _module getVariable "AE3_Module_AddFile_EncryptionAlgorithm";
private _encryptionKey = _module getVariable "AE3_Module_AddFile_EncryptionKey";

if (_path isEqualTo "") exitWith {};

if (_isFunction) then
{
	_content = compile _content;
};

if (_isEncrypted) then 
{
	private _mode = "encrypt";

	if (_encryptionAlgorithm isEqualTo "caesar") then 
	{
		_content = [_encryptionKey, _mode, _content] call AE3_armaos_fnc_encryption_caesar;
	};
};

[_syncedObjects, _path, _content, _owner, _permissions] spawn 
{
	params ["_syncedObjects", "_path", "_content", "_owner", "_permissions"];

	waitUntil { !isNil "BIS_fnc_init" };

	{
		_filesystem = _x getVariable "AE3_filesystem";

		// throws exception if file already exists
		try 
		{
			[
				[],
				_filesystem,
				_path,
				_content,
				"root",
				_owner,
				_permissions
			] call AE3_filesystem_fnc_createFile;
		} 
		catch
		{
			private _normalizedException = _exception regexReplace ["'(.+)'", "'%1'"];
			if (_normalizedException isEqualTo (localize "STR_AE3_Filesystem_Exception_AlreadyExists")) then
			{
				diag_log format ["AE3 exception: %1", _exception];
			}
			else
			{
				throw _exception;
			};
		};

		_x setVariable ["AE3_filesystem", _filesystem];
	} forEach _syncedObjects;
};