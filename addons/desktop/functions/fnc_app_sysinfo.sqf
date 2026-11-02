// File: fnc_app_sysinfo.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Desktop "System Monitor" app: battery, power, network and lock status of the
 * laptop. Refreshes every 2 seconds while the window is open (PFH removed on close).
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

(ctrlPosition _ctrlGroup) params ["", "", "_w", "_h"];

private _infoCtrl = _display ctrlCreate ["RscStructuredText", -1, _ctrlGroup];
_infoCtrl ctrlSetPosition [0.01, 0.045, _w - 0.02, _h - 0.055];
_infoCtrl ctrlCommit 0;

private _update = {
	params ["_infoCtrl", "_computer"];

	private _lines = [];

	private _powerState = _computer getVariable ["AE3_power_powerState", 0];
	private _stateText = ["OFF", "ON", "STANDBY", "CRASHED"] param [_powerState, "UNKNOWN"];
	_lines pushBack format ["<t color='#5da8e8'>Power state:</t> %1", _stateText];

	private _battery = _computer getVariable ["AE3_power_internal", objNull];
	if (!isNull _battery) then
	{
		private _level = _battery getVariable ["AE3_power_batteryLevel", -1];
		private _capacity = _battery getVariable ["AE3_power_batteryCapacity", -1];
		if (_level >= 0 && _capacity > 0) then
		{
			_lines pushBack format ["<t color='#5da8e8'>Battery:</t> %1%2 (%3 / %4 kWh)", floor ((_level / _capacity) * 100), "%", _level toFixed 3, _capacity toFixed 3];
		};
	};

	private _powerCable = _computer getVariable ["AE3_power_powerCableDevice", objNull];
	_lines pushBack format ["<t color='#5da8e8'>External power:</t> %1", ["no", "yes"] select (!isNull _powerCable)];

	private _ip = [_computer getVariable ["AE3_network_address", [127, 0, 0, 1]]] call AE3_network_fnc_ip2str;
	_lines pushBack format ["<t color='#5da8e8'>IP address:</t> %1", _ip];

	private _gateway = _computer getVariable ["AE3_network_parent", objNull];
	if (isNull _gateway) then
	{
		_lines pushBack format ["<t color='#5da8e8'>Gateway:</t> %1", localize "STR_AE3_ArmaOS_Result_NoGateway"];
	}
	else
	{
		_lines pushBack format ["<t color='#5da8e8'>Gateway:</t> %1", [_gateway getVariable ["AE3_network_address", [127, 0, 0, 1]]] call AE3_network_fnc_ip2str];
	};

	private _usb = _computer getVariable ["AE3_USB_Interfaces_occupied", []];
	_lines pushBack format ["<t color='#5da8e8'>USB devices:</t> %1", {!isNull _x} count _usb];

	_lines pushBack format ["<t color='#5da8e8'>Hostname:</t> %1", ([_computer] call AE3_armaos_fnc_computer_getHostname)];
	_lines pushBack format ["<t color='#5da8e8'>Uptime (mission):</t> %1", [CBA_missionTime, "HH:MM:SS"] call BIS_fnc_secondsToString];

	_infoCtrl ctrlSetStructuredText (parseText (_lines joinString "<br/>"));
};

[_infoCtrl, _computer] call _update;

// Single low-frequency PFH while the window is open (removed via the onClose callback)
private _pfhId = [
	{
		(_this select 0) params ["_infoCtrl", "_computer", "_update"];
		if (isNull _infoCtrl) exitWith { [_this select 1] call CBA_fnc_removePerFrameHandler; };
		[_infoCtrl, _computer] call _update;
	},
	2,
	[_infoCtrl, _computer, _update]
] call CBA_fnc_addPerFrameHandler;

uiNamespace setVariable ["AE3_desktop_sysinfoPfh", _pfhId];

createHashMapFromArray [
	["onClose", {
		[uiNamespace getVariable ["AE3_desktop_sysinfoPfh", -1]] call CBA_fnc_removePerFrameHandler;
		uiNamespace setVariable ["AE3_desktop_sysinfoPfh", nil];
	}]
]
