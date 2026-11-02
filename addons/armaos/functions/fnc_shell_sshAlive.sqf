// File: fnc_shell_sshAlive.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Tests whether an open SSH session still has anything on the other end of it, and closes
 * it where it does not. A session is only as good as the conditions it was opened under: the remote
 * machine has to still exist, still be running, still accept SSH, and still be reachable from the local
 * machine over the network as it stands now - a laptop that was shut down, destroyed, packed away, or
 * whose router went off the air is none of those things, and neither is a remote that is still running
 * but no longer on a network this laptop can route to. The same conditions are re-tested rather than
 * trusted from connection time, since every one of them can change while the session sits open. Reports
 * the drop in the local terminal and tears the session down, so a dead session cannot be typed into.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The local computer holding the SSH session
 *
 * Return Value:
 * Alive <BOOL> - true when the session is still good, false when it was closed
 *
 * Example:
 * if (!([_computer] call AE3_armaos_fnc_shell_sshAlive)) exitWith {};
 *
 * Public: No
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";
private _target = _terminal getOrDefault ["AE3_sshTarget", objNull];

// No session to speak of is not a broken one.
if (isNull _target) exitWith {true};

private _targetAddr = _target getVariable ["AE3_network_address", [127, 0, 0, 1]];

private _alive = alive _target
    && {_target getVariable ["AE3_cap_hasTerminal", false]}
    && {([_target] call AE3_power_fnc_isPoweredOn)}
    && {_target getVariable ["AE3_ssh_enabled", true]}
    && {([_computer] call AE3_power_fnc_isPoweredOn)}
    // A machine that has fallen off its network answers on loopback and nothing else, either end.
    && {[_target] call AE3_network_fnc_isOnline}
    && {[_computer] call AE3_network_fnc_isOnline}
    // The route is walked again from where the two machines stand now, so a router that has gone down
    // or an access policy that has since closed drops the session as surely as the remote itself would.
    && {(([_computer, _targetAddr] call AE3_network_fnc_resolve) select 0) isEqualTo _target};

if (_alive) exitWith {true};

[_computer, format [localize "STR_AE3_ArmaOS_Ssh_ConnectionLost", [_targetAddr] call AE3_network_fnc_ip2str]] call AE3_armaos_fnc_shell_stdout;
[_computer] call AE3_armaos_fnc_shell_playErrorSound;
[_computer] call AE3_armaos_fnc_shell_sshEnd;

// The drop can happen while the operator is sitting at a prompt doing nothing, so the terminal is put
// back to its own shell here rather than waiting for the next command to redraw it.
[_computer, "SHELL"] call AE3_armaos_fnc_terminal_setInputMode;
[_computer] call AE3_armaos_fnc_terminal_setPrompt;
[_computer, _terminal get "AE3_terminalOutput"] call AE3_armaos_fnc_terminal_updateOutput;

false
