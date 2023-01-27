/**
 * Returns the client ID of the current computer user.
 * If the computer is unused, the server owns the computer.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 *
 * Returns:
 * Owner of the computer <INT>
*/

params['_computer'];

private _owner = _computer getVariable ["AE3_computer_mutex", objNull];

if (isNull _owner) exitWith {2};

owner _owner;