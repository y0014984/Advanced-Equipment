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
		_obj = (_current get _x);
		_current = _obj select 0;
}forEach _pntr;

_obj;