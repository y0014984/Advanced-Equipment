/*
 * Author: Root, Wasserstoff
 * Description: Resolves a directory pointer (array of directory names) to the corresponding filesystem object. Throws exception if any directory in the path doesn't exist.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Directory pointer (array of directory names forming absolute path)
 * 1: _filesystem <ARRAY> - Filesystem object
 *
 * Return Value:
 * Resolved filesystem object [content, owner, permissions] <ARRAY>
 *
 * Example:
 * [[], _filesystem] call AE3_filesystem_fnc_resolvePntr;
 * [["home", "user", "documents"], _filesystem] call AE3_filesystem_fnc_resolvePntr;
 *
 * Public: Yes
 */

params ['_pntr', '_filesystem'];

private _obj = _filesystem;
private _current = _obj select 0;

{
	if (!(_x in _current)) throw (localize "STR_AE3_Filesystem_Exception_InvalidDirectory");
	_obj = (_current get _x);
	_current = _obj select 0;
}forEach _pntr;

_obj;
