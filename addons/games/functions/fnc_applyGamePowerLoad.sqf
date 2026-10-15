// File: fnc_applyGamePowerLoad.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Adds a game's power draw to a device, or takes it off again. It rides on the figure
 * the power simulation already works from - AE3_power_powerConsumption, which the device's turn-on
 * and standby wrappers feed to AE3_power_fnc_updateSelfPower - so the load survives the device being
 * switched off and on, drains an internal battery through the normal battery calculation, and counts
 * towards a generator's capacity like any other consumer. No second drain loop and no sync of its
 * own. The device's untouched consumption is remembered the first time a load is raised and restored
 * when it drops to zero, so opening and closing a game repeatedly cannot inflate it. Server only.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device playing the game
 * 1: _draw <NUMBER> - Additional draw, 0 to remove it
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, 0.002] call AE3_games_fnc_applyGamePowerLoad;
 *
 * Public: No
 */

params [["_device", objNull, [objNull]], ["_draw", 0, [0]]];

if (!isServer) exitWith {};
if (isNull _device) exitWith {};

private _base = _device getVariable QGVAR(baseConsumption);

// Nothing was ever added and nothing is being added now
if (isNil "_base" && (_draw <= 0)) exitWith {};

if (isNil "_base") then
{
    _base = _device getVariable ["AE3_power_powerConsumption", 0];
    _device setVariable [QGVAR(baseConsumption), _base, true];
};

private _consumption = _base + (0 max _draw);

if (_draw <= 0) then
{
    _consumption = _base;

    _device setVariable [QGVAR(baseConsumption), nil, true];
    _device setVariable [QGVAR(gameDraw), nil, true];
}
else
{
    _device setVariable [QGVAR(gameDraw), _draw, true];
};

_device setVariable ["AE3_power_powerConsumption", _consumption, true];

// Only a running device actually draws; a switched off one picks the new figure up when it is
// turned on, because its turn-on wrapper reads the same variable
if ((_device getVariable ["AE3_power_powerState", 0]) == 1) then
{
    [_device, _consumption] call AE3_power_fnc_updateSelfPower;
};
