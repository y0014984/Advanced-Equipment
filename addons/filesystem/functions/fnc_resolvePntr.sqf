/**
 * Resolves an absolute path of a pointer to the corresponding dir or file.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem [<HASHMAP>, <STRING>]
 *
 * Results:
 * Directory Object [<HASHMAP>, <STRING>]
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