// File: fnc_crashDevice.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Crashes a computer: the device becomes unusable (terminal inaccessible, blue
 * crash screen) until it is turned off and on again. Any open terminal session is force-closed
 * and the mutex released. Can be called from any machine; execution is routed to the server.
 * Power state values: 0 = off, 1 = on, 2 = standby, 3 = crashed.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to crash
 *
 * Return Value:
 * true if the crash was applied/requested, false if the device was not running <BOOL>
 *
 * Example:
 * [_laptop] call AE3_power_fnc_crashDevice;
 *
 * Public: Yes
 */

params ["_computer"];

if (isNull _computer) exitWith { false };

if (!isServer) exitWith
{
	["ae3_power_crashDevice", [_computer]] call CBA_fnc_serverEvent;
	true
};

// Only a running or standby device can crash
private _powerState = _computer getVariable ["AE3_power_powerState", 0];
if !(_powerState in [1, 2]) exitWith { false };

// Mark the device crashed up front so the interaction/power conditions block any further use and
// the forced UI-close handlers can tell a crash apart from a normal close.
_computer setVariable ["AE3_power_powerState", 3, true];

// Force-close any open session (CLI terminal or web desktop) on the using player's machine and kick
// them out of the interface.
private _mutexHolder = _computer getVariable ["AE3_computer_mutex", objNull];
if (!isNull _mutexHolder) then
{
	["ae3_armaos_forceCloseTerminal", [_computer], _mutexHolder] call CBA_fnc_targetEvent;
	["ae3_desktop_forceCloseDesktop", [_computer], _mutexHolder] call CBA_fnc_targetEvent;
};
_computer setVariable ["AE3_computer_mutex", objNull, true];

// Sever the device from its network: a crashed device can neither be reached nor route traffic.
[_computer] call AE3_network_fnc_disconnect;

// A crashed device draws no power
[_computer, 0] call AE3_power_fnc_updateSelfPower;

// Screenless devices (AE3_Device >> hasScreen = 0, e.g. servers) keep their model textures.
private _hasScreen = !isNumber (configOf _computer >> "AE3_Device" >> "hasScreen") || {getNumber (configOf _computer >> "AE3_Device" >> "hasScreen") == 1};

// Crash screen (procedural blue screen) - setObjectTextureGlobal must run where the object is local.
// Applied now and re-asserted a moment later so it wins over any idle-screen texture a closing
// terminal/desktop unload handler may set on the owning client.
if (_hasScreen) then
{
	private _crashTexture = "#(argb,8,8,3)color(0,0.05,0.4,1,co)";
	[_computer, [1, _crashTexture]] remoteExecCall ["setObjectTextureGlobal", _computer];
	[
		{
			params ["_computer", "_crashTexture"];
			if (isNull _computer) exitWith {};
			if ((_computer getVariable ["AE3_power_powerState", 0]) == 3) then
			{
				[_computer, [1, _crashTexture]] remoteExecCall ["setObjectTextureGlobal", _computer];
			};
		},
		[_computer, _crashTexture],
		0.5
	] call CBA_fnc_waitAndExecute;
};

INFO_1("Device crashed: %1",typeOf _computer);

true
