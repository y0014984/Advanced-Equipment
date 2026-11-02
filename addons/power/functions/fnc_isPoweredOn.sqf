#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Whether a device is switched on (AE3_power_powerState 1). Off, standby, unknown and null count as
 * not on. Any machine.
 *
 * Arguments:
 * 0: _device <OBJECT> - The device
 *
 * Return Value:
 * Powered on <BOOL>
 *
 * Example:
 * if ([_laptop] call AE3_power_fnc_isPoweredOn) then { hint "on"; };
 *
 * Public: Yes
 */

params [["_device", objNull, [objNull]]];

!isNull _device && {(_device getVariable ["AE3_power_powerState", 0]) == 1}
