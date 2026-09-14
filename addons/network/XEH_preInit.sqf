// File: XEH_preInit.sqf
#include "script_component.hpp"
#include "XEH_PREP.hpp"

// Router turn-off requests from clients are routed to the server (see fnc_router_onTurnOff)
if (isServer) then
{
	["ae3_network_routerOff", { _this call AE3_network_fnc_router_onTurnOff }] call CBA_fnc_addEventHandler;

	// Addressing is server-authoritative: only the server knows the full device registry, so only the
	// server can detect a duplicate address. Clients that reach a connect/disconnect/lease function
	// (ACE interaction menu, desktop apps) hand the request over through these events instead of
	// allocating an address from their own partial view. Payloads are netId strings so they serialize
	// reliably in multiplayer.
	["ae3_network_connectDevice", {
		params ["_deviceNetId", "_parentNetId"];
		[objectFromNetId _deviceNetId, objectFromNetId _parentNetId] call AE3_network_fnc_connect_device2router;
	}] call CBA_fnc_addEventHandler;

	["ae3_network_connectRouter", {
		params ["_routerNetId", "_parentNetId"];
		[objectFromNetId _routerNetId, objectFromNetId _parentNetId] call AE3_network_fnc_connect_router2router;
	}] call CBA_fnc_addEventHandler;

	["ae3_network_disconnectDevice", {
		params ["_deviceNetId"];
		[objectFromNetId _deviceNetId] call AE3_network_fnc_removeNetworkConnection;
	}] call CBA_fnc_addEventHandler;

	["ae3_network_dhcpRefresh", {
		params ["_routerNetId"];
		[objectFromNetId _routerNetId] call AE3_network_fnc_dhcp_refresh;
	}] call CBA_fnc_addEventHandler;

	["ae3_network_dhcpTurnOn", {
		params ["_routerNetId"];
		[objectFromNetId _routerNetId] call AE3_network_fnc_dhcp_onTurnOn;
	}] call CBA_fnc_addEventHandler;

	// Wireless range is a condition of staying on a network, not just of joining one, and a carried
	// router moves that range around with it. The connections are therefore re-tested on a timer rather
	// than trusted from the moment they were made.
	[AE3_network_fnc_wirelessSweep, 5] call CBA_fnc_addPerFrameHandler;

	// Instant messaging: record the message on BOTH ends in dedicated per-peer chat threads under
	// /var/chat/<peerIP> (separate from /var/mail so the Messenger and Email apps never cross-feed
    // Each line is "<dir>|HH:MM|<text>" with dir o(ut)/i(n); text newlines are
	// stripped so a message is always exactly one line regardless of content.
	["ae3_network_imSend", {
		params ["_targetNetId", "_senderNetId", "_senderIp", "_targetIp", "_text"];

		private _target = objectFromNetId _targetNetId;
		if (isNull _target) exitWith {};
		private _sender = objectFromNetId _senderNetId;

		private _time = [dayTime, "HH:MM"] call BIS_fnc_timeToString;
		_text = _text regexReplace ["[\r\n]+", " "];

		// Append one message to a laptop's thread file for the given peer IP.
		private _deliver = {
			params ["_device", "_peerIp", "_dir", "_time", "_text"];
			private _filesystem = _device getVariable ["AE3_filesystem", nil];
			if (isNil "_filesystem") exitWith {};
			private _path = "/var/chat/" + _peerIp;
			private _line = format ["%1|%2|%3", _dir, _time, _text];
			try
			{
				[[], _filesystem, "/var/chat", "root", "root", [[true, true, true], [true, false, true]]] call AE3_filesystem_fnc_ensureDir;
				[[], _filesystem, _path, "", "root", "root", [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
				[[], _filesystem, _path, "root", _line + endl, true] call AE3_filesystem_fnc_writeToFile;
				_device setVariable ["AE3_filesystem", _filesystem, 2];
			}
			catch
			{
				WARNING_1("Could not deliver message: %1",_exception);
			};
		};

		// Incoming copy on the target, outgoing copy on the sender.
		[_target, _senderIp, "i", _time, _text] call _deliver;
		if (!isNull _sender) then { [_sender, _targetIp, "o", _time, _text] call _deliver; };

		// Notify whoever is using the target terminal right now
		private _mutexHolder = _target getVariable ["AE3_computer_mutex", objNull];
		if (!isNull _mutexHolder && {_mutexHolder isKindOf "CAManBase"}) then
		{
			["ae3_network_imNotify", [_target, _senderIp], _mutexHolder] call CBA_fnc_targetEvent;
		};
	}] call CBA_fnc_addEventHandler;
};

// Client-side: show a notification in the open terminal when a message arrives
if (hasInterface) then
{
	// Verdict for a static address a curator applied through the asset attributes dialog. The address
	// is validated on the server, so the outcome can only be reported back after the fact.
	["ae3_network_zeusIpResult", {
		params ["_message"];
		["AE3 Asset Attributes", _message, 5] call BIS_fnc_curatorHint;
	}] call CBA_fnc_addEventHandler;


	["ae3_network_imNotify", {
		params ["_target", "_senderIp"];

		// Only show if this client actually has the target's terminal open
		private _display = findDisplay 15984;
		if (isNull _display) exitWith {};
		if ((_display getVariable ["AE3_computer", objNull]) isNotEqualTo _target) exitWith {};

		[_target, [[format [localize "STR_AE3_Network_Msg_Received", _senderIp], "#FFD966"]]] call AE3_armaos_fnc_shell_stdout;
	}] call CBA_fnc_addEventHandler;
};
