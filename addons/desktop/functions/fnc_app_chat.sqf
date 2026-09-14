// File: fnc_app_chat.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Desktop "Chat" app: GUI for the instant messaging system. Shows received
 * messages (/var/mail/inbox - same store as the 'msg' CLI command) and sends new ones over
 * the AE3 network.
 *
 * Arguments:
 * 0: _winId <NUMBER>
 * 1: _ctrlGroup <CONTROL>
 * 2: _computer <OBJECT>
 * 3: _args <ANY>
 *
 * Return Value:
 * App callbacks <HASHMAP>
 *
 * Public: No
 */

params ["_winId", "_ctrlGroup", "_computer", "_args"];

private _session = uiNamespace getVariable ["AE3_desktop_session", createHashMap];
private _display = _session getOrDefault ["display", displayNull];
private _theme = _session getOrDefault ["theme", createHashMap];

(ctrlPosition _ctrlGroup) params ["", "", "_w", "_h"];

/* message history */
private _historyCtrl = _display ctrlCreate ["RscStructuredText", -1, _ctrlGroup];
_historyCtrl ctrlSetPosition [0.01, 0.045, _w - 0.02, _h - 0.14];
_historyCtrl ctrlCommit 0;

/* target ip + message + send */
private _toCtrl = _display ctrlCreate ["RscEdit", -1, _ctrlGroup];
_toCtrl ctrlSetPosition [0.01, _h - 0.09, 0.18, 0.035];
_toCtrl ctrlSetText "192.168.0.";
_toCtrl ctrlCommit 0;

private _msgCtrl = _display ctrlCreate ["RscEdit", -1, _ctrlGroup];
_msgCtrl ctrlSetPosition [0.20, _h - 0.09, _w - 0.32, 0.035];
_msgCtrl ctrlCommit 0;

private _sendBtn = _display ctrlCreate ["RscButton", -1, _ctrlGroup];
_sendBtn ctrlSetPosition [_w - 0.11, _h - 0.09, 0.10, 0.035];
_sendBtn ctrlSetText (localize "STR_AE3_Desktop_Mail_Send");
_sendBtn ctrlSetBackgroundColor (_theme getOrDefault ["accent", [0.2,0.5,0.8,1]]);
_sendBtn ctrlSetTextColor (_theme getOrDefault ["text", [1,1,1,1]]);
_sendBtn ctrlCommit 0;

private _refreshBtn = _display ctrlCreate ["RscButton", -1, _ctrlGroup];
_refreshBtn ctrlSetPosition [0.01, _h - 0.05, 0.12, 0.035];
_refreshBtn ctrlSetText (localize "STR_AE3_Desktop_Mail_Refresh");
_refreshBtn ctrlSetBackgroundColor (_theme getOrDefault ["titlebar", [0,0,0,1]]);
_refreshBtn ctrlSetTextColor (_theme getOrDefault ["text", [1,1,1,1]]);
_refreshBtn ctrlCommit 0;

/* ---------------------------------------- */

_historyCtrl setVariable ["AE3_computer", _computer];
_historyCtrl setVariable ["AE3_toCtrl", _toCtrl];

private _refresh = {
	params ["_historyCtrl"];

	private _computer = _historyCtrl getVariable "AE3_computer";
	private _toCtrl2 = _historyCtrl getVariable "AE3_toCtrl";
	private _filesystem = _computer getVariable ["AE3_filesystem", []];
	if (_filesystem isEqualTo []) exitWith {};

	private _peerIp = ctrlText _toCtrl2;
	private _text = "";
	try
	{
		private _content = [[], _filesystem, format ["/var/chat/%1", _peerIp], "root", 0] call AE3_filesystem_fnc_getFile;
		if (_content isEqualType "") then { _text = _content; };
	}
	catch
	{
		_text = localize "STR_AE3_Desktop_Chat_Empty";
	};

	if (_text isEqualTo "") then { _text = localize "STR_AE3_Desktop_Chat_Empty"; };

	_historyCtrl ctrlSetStructuredText (parseText ((_text splitString endl) joinString "<br/>"));
};

_historyCtrl setVariable ["AE3_refresh", _refresh];
[_historyCtrl] call _refresh;

_refreshBtn setVariable ["AE3_historyCtrl", _historyCtrl];
_refreshBtn ctrlAddEventHandler ["ButtonClick", {
	params ["_button"];
	private _historyCtrl = _button getVariable "AE3_historyCtrl";
	[_historyCtrl] call (_historyCtrl getVariable "AE3_refresh");
}];

// Shared send routine, used by both the Send button and the Enter key in the message field.
private _send = {
	params ["_computer", "_toCtrl", "_msgCtrl", "_historyCtrl"];

	private _text = ctrlText _msgCtrl;
	if (_text isEqualTo "") exitWith {};

	private _targetIp = (ctrlText _toCtrl splitString ".") apply { parseNumber _x };
	if (count _targetIp != 4) exitWith { hintSilent (localize "STR_AE3_ArmaOS_Ssh_InvalidAddress"); };

	([_computer, _targetIp] call AE3_network_fnc_resolve) params ["_target"];
	if (isNull _target || _target isEqualTo _computer) exitWith
	{
		hintSilent format [localize "STR_AE3_ArmaOS_Ssh_NoRoute", ctrlText _toCtrl];
	};

	private _senderIp = [_computer getVariable ["AE3_network_address", [127, 0, 0, 1]]] call AE3_network_fnc_ip2str;
	["ae3_network_imSend", [netId _target, netId _computer, _senderIp, ctrlText _toCtrl, _text]] call CBA_fnc_serverEvent;

	_msgCtrl ctrlSetText "";
};

_sendBtn setVariable ["AE3_ctx", [_computer, _toCtrl, _msgCtrl, _historyCtrl]];
_sendBtn setVariable ["AE3_send", _send];
_sendBtn ctrlAddEventHandler ["ButtonClick", {
	params ["_button"];
	(_button getVariable "AE3_ctx") call (_button getVariable "AE3_send");
}];

// Enter in the message field sends (keys 28 = Return, 156 = numpad Enter).
_msgCtrl setVariable ["AE3_ctx", [_computer, _toCtrl, _msgCtrl, _historyCtrl]];
_msgCtrl setVariable ["AE3_send", _send];
_msgCtrl setVariable ["AE3_historyCtrl", _historyCtrl];
_msgCtrl ctrlAddEventHandler ["KeyDown", {
	params ["_ctrl", "_key"];
	if (_key in [28, 156]) exitWith
	{
		(_ctrl getVariable "AE3_ctx") call (_ctrl getVariable "AE3_send");
		private _h = _ctrl getVariable "AE3_historyCtrl";
		[_h] call (_h getVariable "AE3_refresh");
		true
	};
	false
}];

// Auto-refresh incoming messages on a throttled timer (no per-frame cost). The handle is removed
// when the window closes via the onClose callback below.
private _pfh = [
	{ params ["_args"]; _args params ["_historyCtrl"]; [_historyCtrl] call (_historyCtrl getVariable "AE3_refresh"); },
	2,
	[_historyCtrl]
] call CBA_fnc_addPerFrameHandler;

// The window manager removes any returned "pfh" handle automatically on close (see fnc_wm_closeWindow).
createHashMapFromArray [["pfh", _pfh]]
