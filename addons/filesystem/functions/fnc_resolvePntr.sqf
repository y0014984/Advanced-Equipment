/**
 * Resolves an absolute path of a pointer to the corresponding dir or file.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem <HASHMAP>
 *
 * Results:
 * Directory <HASHMAP>
 */

params ['_pntr', '_filesystem'];

private _current = _filesystem;

{
		_current = _current get _x;
}forEach _pntr;

_current;