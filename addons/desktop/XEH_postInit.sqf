// File: XEH_postInit.sqf
#include "script_component.hpp"

// Seed a default Browser homepage (RootNet index) on the server so the in-game browser is never
// empty. Mission makers register additional pages with AE3_desktop_fnc_registerWebpage; those
// appear automatically on home.root alongside this welcome entry.
if (isServer) then
{
	[
		"rootnet.root",
		"RootNet",
		[
			"<t size='1.2'>Welcome to RootNet</t>",
			"",
			"The internal network index. Pages published on this network appear on the home screen.",
			"",
			"Type an address in the bar above, or pick a link below.",
			"",
			"[[home.root|Home]]"
		]
	] call AE3_desktop_fnc_registerWebpage;

	// SSH client ops run on the server (authoritative filesystems + auth). Spawn so the handler runs
	// in scheduled context, letting getRemoteVar block until the remote filesystem transfer completes
	// (otherwise the remote browser would read an empty, not-yet-synced filesystem).
	["ae3_desktop_sshOp", { _this spawn AE3_desktop_fnc_sshOpServer }] call CBA_fnc_addEventHandler;
};

// Web Messenger: server pushes the laptop's IM inbox text here; forward it to the open browser.
if (hasInterface) then
{
	["ae3_desktop_chatData", {
		params ["_threads"];
		// Threads: [[peerIp, [[dir,time,text], ...]], ...] -> structured payload for the Messenger app.
		private _out = [];
		{
			_x params ["_peer", "_msgs", ["_self", ""]];
			private _jmsgs = [];
			{
				_x params ["_dir", "_time", "_text"];
				_jmsgs pushBack createHashMapFromArray [["dir", _dir], ["time", _time], ["text", _text]];
			} forEach _msgs;
			_out pushBack createHashMapFromArray [["peer", _peer], ["messages", _jmsgs], ["self", _self]];
		} forEach _threads;
		["chat_data", createHashMapFromArray [["threads", _out]]] call AE3_desktop_fnc_jsSend;
	}] call CBA_fnc_addEventHandler;

	// Reply to a web request the server handled. The payload arrives JSON-encoded because only plain
	// strings survive a network event reliably; it is decoded here and handed to the browser with the
	// original request id so the JS A3.request promise resolves.
	["ae3_desktop_routeReply", {
		params ["_rid", "_cmd", ["_json", ""]];
		// parseJSON yields nil for malformed input; fall back to an empty payload so the browser still
		// gets an answer instead of the request timing out.
		private _payload = if (_json isEqualTo "") then { [] } else { [_json, 2] call CBA_fnc_parseJSON };
		if (isNil "_payload") then { _payload = []; };
		[_cmd, createHashMapFromArray [["_rid", _rid], ["data", _payload]]] call AE3_desktop_fnc_jsSend;
	}] call CBA_fnc_addEventHandler;

	["ae3_desktop_msgNotify", {
		params ["_peer"];
		["msg_notify", createHashMapFromArray [["peer", _peer]]] call AE3_desktop_fnc_jsSend;
	}] call CBA_fnc_addEventHandler;

	// New mail delivered to the laptop in use (player send or Zeus/Eden intel): nudge the open
	// web Mail app to re-pull its inbox and sent box. No-op when no desktop or Mail app is open.
	["ae3_desktop_mailNotify", {
		params ["_from"];
		["mail_notify", createHashMapFromArray [["from", _from]]] call AE3_desktop_fnc_jsSend;
	}] call CBA_fnc_addEventHandler;

	// Calendar store changed on the server (Zeus/Eden module or in-app add/delete): nudge the open
	// web Calendar to re-pull AE3_calendar_events so module-added events appear without a manual
	// refresh. No-op when no desktop is open or the Calendar app is not subscribed.
	["ae3_desktop_calChanged", {
		["cal_changed", []] call AE3_desktop_fnc_jsSend;
	}] call CBA_fnc_addEventHandler;

	// USB volume change (connect/auto-mount): nudge an open My Computer app to refresh.
	["ae3_desktop_volChanged", {
		["vol_changed", []] call AE3_desktop_fnc_jsSend;
	}] call CBA_fnc_addEventHandler;

	// USB mount failure: forward the reason to the open My Computer app so a failed mount is visible
	// instead of the volume silently staying on "not mounted".
	["ae3_desktop_volError", {
		params ["_msg"];
		["vol_error", createHashMapFromArray [["message", _msg]]] call AE3_desktop_fnc_jsSend;
	}] call CBA_fnc_addEventHandler;

	// Laptop status changed (Zeus/mission-maker battery, wifi, IP, hostname or SSH): nudge the open
	// Settings System panel to re-read sysinfo so the change shows without closing the laptop.
	["ae3_desktop_sysChanged", {
		["sys_changed", []] call AE3_desktop_fnc_jsSend;
	}] call CBA_fnc_addEventHandler;

	// Browser page list changed (intel/webpage registered or removed): nudge the open Browser to
	// re-pull its page list so the new page appears without reopening.
	["ae3_desktop_webChanged", {
		["web_changed", []] call AE3_desktop_fnc_jsSend;
	}] call CBA_fnc_addEventHandler;

	// Wireless connect result: forward the server's verdict (ok + message) to the Network app.
	["ae3_desktop_netResult", {
		params ["_ok", "_msg", ["_ip", ""], ["_gateway", ""]];
		["net_result", createHashMapFromArray [["ok", _ok], ["msg", _msg], ["ip", _ip], ["gateway", _gateway]]] call AE3_desktop_fnc_jsSend;
	}] call CBA_fnc_addEventHandler;
};
