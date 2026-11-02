#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Display name of an AE3 object, first match wins: custom name (ace_cargo_customName), the fallback,
 * the generic kind ("Laptop", "Router", "Server", ...) when CBA setting AE3_DeviceNameFallback is "generic", the
 * config displayName, the class name. Any machine.
 *
 * Arguments:
 * 0: _device <OBJECT> - The object
 * 1: _fallback <STRING> - (Optional, default: "") Used when no custom name is set
 *
 * Return Value:
 * Name, "" for objNull <STRING>
 *
 * Example:
 * private _name = [_router] call AE3_main_fnc_getDeviceName;
 *
 * Public: Yes
 */

params [["_device", objNull, [objNull]], ["_fallback", "", [""]]];

if (isNull _device) exitWith { "" };

private _name = _device getVariable ["ace_cargo_customName", ""];
if (_name isNotEqualTo "") exitWith { _name };
if (_fallback isNotEqualTo "") exitWith { _fallback };

if ((missionNamespace getVariable ["AE3_DeviceNameFallback", "generic"]) isEqualTo "generic") then {
    private _type = typeOf _device;
    _name = switch (true) do {
        case (_device getVariable ["AE3_cap_isRouter", false]): { localize "STR_AE3_Main_DeviceName_Router" };
        case ((_type find "Land_PortableServer_01_") == 0): { localize "STR_AE3_Main_DeviceName_Server" };
        case (_device getVariable ["AE3_cap_hasTerminal", false]): { localize "STR_AE3_Main_DeviceName_Laptop" };
        case (_device isKindOf "Land_USB_Dongle_01_F"): { localize "STR_AE3_Main_DeviceName_UsbDrive" };
        case (_device getVariable ["AE3_cap_hasFuelTank", false]): { localize "STR_AE3_Main_DeviceName_Generator" };
        case ("BatteryPack" in _type): { localize "STR_AE3_Main_DeviceName_Battery" };
        case ("SolarPanel" in _type): { localize "STR_AE3_Main_DeviceName_SolarPanel" };
        default { "" };
    };
};
if (_name isNotEqualTo "") exitWith { _name };

_name = getText (configOf _device >> "displayName");
if (_name isNotEqualTo "") exitWith { _name };

typeOf _device
