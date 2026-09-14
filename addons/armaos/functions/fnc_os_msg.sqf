// File: fnc_os_msg.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Sends an instant message to another computer over the AE3 network. The message
 * is appended to the target's /var/mail/inbox; an active terminal session on the target shows
 * a notification. Read messages with: cat /var/mail/inbox
 *
 * Arguments:
 * 0: _computer <OBJECT> - The local computer object
 * 1: _options <ARRAY> - Command options and arguments: TARGET-IP MESSAGE...
 * 2: _commandName <STRING> - The name of the command
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, ["192.168.0.5", "hello", "world"], "msg"] call AE3_armaos_fnc_os_msg;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["path", "TARGET-IP", true, false],
			["path", "MESSAGE", true, true]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _ipString = _ae3OptsThings select 0;
private _text = (_ae3OptsThings select [1, (count _ae3OptsThings) - 1]) joinString " ";

private _targetIp = (_ipString splitString ".") apply { parseNumber _x };
if (count _targetIp != 4) exitWith
{
	[_computer, format [localize "STR_AE3_ArmaOS_Ssh_InvalidAddress", _ipString]] call AE3_armaos_fnc_shell_stdout;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};

// Route to the target over the simulated network (honours each router's external access policy)
([_computer, _targetIp] call AE3_network_fnc_resolve) params ["_target", "_routeLength"];

if (isNull _target || _target isEqualTo _computer) exitWith
{
	[_computer, format [localize "STR_AE3_ArmaOS_Ssh_NoRoute", _ipString]] call AE3_armaos_fnc_shell_stdout;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};

private _senderIp = [_computer getVariable ["AE3_network_address", [127, 0, 0, 1]]] call AE3_network_fnc_ip2str;

["ae3_network_imSend", [netId _target, netId _computer, _senderIp, _ipString, _text]] call CBA_fnc_serverEvent;

[_computer, format [localize "STR_AE3_ArmaOS_Msg_Sent", _ipString]] call AE3_armaos_fnc_shell_stdout;
