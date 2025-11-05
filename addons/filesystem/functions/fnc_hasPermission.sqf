/**
 * Checks if the given user has the permission in the directory.
 *
 * Arguments:
 * 0: File or folder [<HASHMAP>, <STRING>]
 * 1: User <STRING>
 * 2: Permission <NUMBER> (0: Execute, 1: Read, 2: Write)
 *
 * Returns:
 * None
 *
 */

params['_fileObject', '_user', '_permission'];

private _owner = _fileObject select 1;
private _permissions = _fileObject select 2;

if(_owner isEqualTo '' || _user isEqualTo 'root') exitWith {};

if(_permissions select 1 select _permission) exitWith {};

if((_owner isEqualTo _user) && (_permissions select 0 select _permission)) exitWith {};

throw localize "STR_AE3_Filesystem_Exception_MissingPermissions";
