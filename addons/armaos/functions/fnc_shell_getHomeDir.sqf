/**
 * Returns file pointer to home directory of the user.
 *
 * Arguments:
 * 1: Username <String>
 *
 * Results:
 * Filepointer [<String>]
 */


params['_username'];

if (_username isEqualTo "root") exitWith
{
	["root"];
};

["home", _username];
