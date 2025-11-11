/*
 * Author: Root
 * Description: Adds a command link (alias) to a computer, mapping a command name to a filesystem path with optional description and manual text.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _name <STRING> - Command name/alias
 * 2: _path <STRING> - Filesystem path to the command executable
 * 3: _description <STRING> (Optional, default: "") - Short description for help command
 * 4: _man <STRING> (Optional, default: "") - Manual/help text for man command
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, "ls", "/bin/ls", "List directory contents"] call AE3_armaos_fnc_link_add;
 *
 * Public: No
 */

params['_computer', '_name', '_path', ['_description', ''], ['_man', '']];

private _links = _computer getVariable ['AE3_Links', createHashMap];

if(_name in _links) then
{
	throw localize "STR_AE3_ArmaOS_Exception_LinkAlreadyExists";
};

_links set [_name, [_path, _description, _man]];

_computer setVariable ['AE3_Links', _links, True];
