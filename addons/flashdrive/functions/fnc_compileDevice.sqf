/*
 * Author: Root, Wasserstoff
 * Description: Compiles the USB interface configuration from config for an object's class. Analogous to ACE3 menu compilation.
 * Reads the AE3_USB_Interface config section and initializes USB interfaces on the device.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Device object to compile USB interfaces for
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop] call AE3_flashdrive_fnc_compileDevice;
 *
 * Public: No
 */

params['_entity'];

private _class = (typeOf _entity);
private _class_name = _class + "_flashdrive";

if(isNil {missionNamespace getVariable _class_name}) then 
{

	private _deviceCfg = configFile >> "CfgVehicles" >> _class >> "AE3_USB_Interface";

	if (!isClass _deviceCfg) exitWith 
	{
		missionNamespace setVariable [_class_name, ""];
	};

	private _config = [_deviceCfg] call AE3_flashdrive_fnc_compileConfig;
	missionNamespace setVariable [_class_name, _config];
};

private _config = missionNamespace getVariable _class_name;

if(_config isEqualType "") exitWith {};

[_entity,  _config] call AE3_flashdrive_fnc_initInterface;
