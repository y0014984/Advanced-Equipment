// File: fnc_sysInfo.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Collects laptop status (power, battery, network, host, uptime) for the web desktop
 * Settings/System panel. Reuses the same object variables the native System Monitor read.
 * Pure read, client-local.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The bound laptop
 * 1: _user <STRING> (Optional, default: "") - The logged-in session user (for the home path)
 *
 * Return Value:
 * Info <HASHMAP> - keys: hostname, ip, gateway, power, battery, uptime, wallpaper, home
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]], ["_user", "", [""]]];

// Per-user home + Desktop: root lives in /root, every other user in /home/<user>.
private _home = ["/home/" + _user, "/root"] select (_user isEqualTo "root" || _user isEqualTo "");
private _info = createHashMapFromArray [
    ["hostname", "armaOS"], ["ip", "-"], ["gateway", "-"], ["power", "-"], ["battery", -1], ["uptime", "-"],
    ["home", _home], ["user", _user]
];
if (isNull _computer) exitWith { _info };

private _powerState = _computer getVariable ["AE3_power_powerState", 0];
_info set ["power", (["OFF", "ON", "STANDBY", "CRASHED"] param [_powerState, "UNKNOWN"])];

private _battery = _computer getVariable ["AE3_power_internal", objNull];
if (!isNull _battery) then {
    private _level = _battery getVariable ["AE3_power_batteryLevel", -1];
    private _capacity = _battery getVariable ["AE3_power_batteryCapacity", -1];
    if (_level >= 0 && _capacity > 0) then { _info set ["battery", floor ((_level / _capacity) * 100)]; };
};

_info set ["ip", ([_computer getVariable ["AE3_network_address", [127, 0, 0, 1]]] call AE3_network_fnc_ip2str)];

private _gateway = _computer getVariable ["AE3_network_parent", objNull];
if (!isNull _gateway) then {
    _info set ["gateway", ([_gateway getVariable ["AE3_network_address", [127, 0, 0, 1]]] call AE3_network_fnc_ip2str)];
};

_info set ["hostname", ([_computer] call AE3_armaos_fnc_computer_getHostname)];
_info set ["uptime", ([CBA_missionTime, "HH:MM:SS"] call BIS_fnc_secondsToString)];
private _d = date;
private _months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
_info set ["missionDate", format ["%1 %2", _d select 2, _months param [(_d select 1) - 1, ""]]];
_info set ["missionTime", [dayTime, "HH:MM"] call BIS_fnc_timeToString];
// Per-user-per-laptop wallpaper (CSS background string or image path); falls back to the laptop-wide
// legacy var, then the theme default ("").
private _wallpapers = _computer getVariable ["AE3_desktop_wallpapers", createHashMap];
private _userWp = _wallpapers getOrDefault [_user, ""];
if (_userWp isEqualTo "") then { _userWp = _computer getVariable ["AE3_desktop_wallpaper", ""]; };
_info set ["wallpaper", _userWp];
// SSH access toggle: whether this device accepts incoming SSH connections.
_info set ["sshEnabled", _computer getVariable ["AE3_ssh_enabled", true]];

_info
