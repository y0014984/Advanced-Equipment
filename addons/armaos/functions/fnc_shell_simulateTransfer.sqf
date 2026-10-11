// File: fnc_shell_simulateTransfer.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Simulates a file transfer by blocking the calling (scheduled) command process
 * for a duration derived from the file size and the configured medium speed, while printing
 * progress to the terminal. Cancellable with Ctrl+C (terminates the command process).
 * NOTE: must run in a scheduled environment (OS commands run spawned) - uses sleep by design.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _bytes <NUMBER> - Simulated file size in bytes (see AE3_filesystem_fnc_getFileSize)
 * 2: _medium <STRING> (Optional, default: "local") - "local", "usb" or "network"
 * 3: _user <STRING> (Optional, default: "") - Account on _computer (network speed overrides)
 * 4: _peer <OBJECT> (Optional, default: objNull) - Remote end (network)
 * 5: _peerUser <STRING> (Optional, default: "") - Account on _peer (network)
 *
 * Return Value:
 * Duration of the simulated transfer in seconds <NUMBER>
 *
 * Example:
 * [_computer, 1024 * 512, "usb"] call AE3_armaos_fnc_shell_simulateTransfer;
 *
 * Public: Yes
 */

params ["_computer", "_bytes", ["_medium", "local"], ["_user", ""], ["_peer", objNull], ["_peerUser", ""]];

([_bytes, _medium, _computer, _user, _peer, _peerUser] call AE3_armaos_fnc_shell_transferDuration) params ["_duration", "_speed"];

if (_duration <= 0) exitWith { 0 };

private _start = CBA_missionTime;

[_computer, format [localize "STR_AE3_ArmaOS_Transfer_Started", [_bytes] call AE3_filesystem_fnc_formatSize, _speed]] call AE3_armaos_fnc_shell_stdout;

while { (CBA_missionTime - _start) < _duration } do
{
	private _percent = (((CBA_missionTime - _start) / _duration) * 100) min 100;
	[_computer, format ["  %1%2", floor _percent, "%"]] call AE3_armaos_fnc_shell_stdout;

	sleep (1 max (_duration / 10));
};

[_computer, localize "STR_AE3_ArmaOS_Transfer_Done"] call AE3_armaos_fnc_shell_stdout;

_duration
