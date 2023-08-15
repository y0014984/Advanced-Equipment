/**
 * PUBLIC - Execution on server only
 *
 * This function clones filesystem, links (commands) and the userlist from computer1 to computer2.
 *
 * Arguments:
 * 0: Computer 1 <OBJECT>
 * 0: Computer 2 <OBJECT>
 *
 * Results:
 * None
 *
*/

params ["_computer1", "_computer2"];

if (!isServer) exitWith { false; };

// read variables from source computer
private _filesystem = _computer1 getVariable ["AE3_filesystem", []];
private _links = _computer1 getVariable ["AE3_links", createHashMap];
private _userlist = _computer1 getVariable ["AE3_userlist", createHashMap];

// write variables to destination computer
_computer2 setVariable ["AE3_filesystem", _filesystem];
_computer2 setVariable ["AE3_links", _links];
_computer2 setVariable ["AE3_userlist", _userlist, true];

true;