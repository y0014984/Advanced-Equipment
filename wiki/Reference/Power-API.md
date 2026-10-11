# Power API

The Power component models device power states, generators, batteries, solar panels, internal laptop batteries, provider/consumer links, fuel levels, battery levels, and device crashes.

Use this API when scripts need to turn equipment on/off, connect devices to power providers, seed fuel or battery levels, or simulate a device failure.

## Power States

Power state is stored on devices as `AE3_power_powerState`.

| Numeric value | Meaning |
| --- | --- |
| `0` | Off |
| `1` | On |
| `2` | Standby |
| `3` | Crashed computer state |
| `-1` | Unknown/uninitialized fallback in some read helpers |

`AE3_power_fnc_getPowerState` returns a localized string, not the numeric value. If you need logic, read `AE3_power_powerState` directly or use the control functions' boolean return values.

## Device Control

### `AE3_power_fnc_turnOnDevice`

Turns on a configured power device.

```sqf
private _success = [_device] call AE3_power_fnc_turnOnDevice;
```

Works for laptops, generators, batteries, solar panels, and other configured power devices. The function checks turn-on conditions such as current power state, mutex state, and device-specific conditions.

Example:

```sqf
if ([_generator] call AE3_power_fnc_turnOnDevice) then {
    systemChat "Generator online";
};
```

### `AE3_power_fnc_turnOffDevice`

Turns off a configured power device.

```sqf
private _success = [_device] call AE3_power_fnc_turnOffDevice;
```

Example:

```sqf
[_laptop] call AE3_power_fnc_turnOffDevice;
```

### `AE3_power_fnc_standbyDevice`

Puts a device into standby, when the device supports standby.

```sqf
private _success = [_device] call AE3_power_fnc_standbyDevice;
```

This is primarily relevant for laptops.

### `AE3_power_fnc_crashDevice`

Crashes a running computer until it is power-cycled.

```sqf
private _success = [_computer] call AE3_power_fnc_crashDevice;
```

The function can be called from any machine and routes to the server. It force-closes open terminal sessions, releases the computer mutex, and shows the crash state to users.

Example:

```sqf
[_laptop] call AE3_power_fnc_crashDevice;
```

Return value: `true` if the crash was applied or requested, `false` if the device was not running.

### `AE3_power_fnc_setMainsPowered`

```sqf
[_device, _mains] call AE3_power_fnc_setMainsPowered;
```

Sets whether a consumer runs on mains power (`true`: no provider needed, never drains anything) or needs an external power cable (`false`). Overrides the class default `AE3_Device >> mainsPowered` (servers default to mains). A running device switched to external power without a powered provider is turned off. Callable from any machine.

```sqf
[_server, false] call AE3_power_fnc_setMainsPowered; // must now be cabled to a generator
```

## Reading Power State

### `AE3_power_fnc_getPowerState`

Returns a localized power state string.

```sqf
private _stateText = [_device] call AE3_power_fnc_getPowerState;
hint format ["State: %1", _stateText];
```

For code decisions, prefer:

```sqf
private _state = _device getVariable ["AE3_power_powerState", -1];
if (_state isEqualTo 1) then {
    // Device is on.
};
```

## Power Connections

### `AE3_power_fnc_createPowerConnection`

Connects a consumer device to a power provider.

```sqf
[_consumer, _provider] call AE3_power_fnc_createPowerConnection;
```

Examples:

```sqf
[_laptop, _generator] call AE3_power_fnc_createPowerConnection;
[_battery, _solarPanel] call AE3_power_fnc_createPowerConnection;
```

The function waits for both devices to finish initialization and handles internal batteries automatically.

The same behavior is exposed in Eden through `AE3: connect device to power source`.

### `AE3_power_fnc_removePowerConnection`

Removes the provider link from a consumer.

```sqf
private _success = [_consumer] call AE3_power_fnc_removePowerConnection;
```

The function updates ACE interactions, removes the consumer from the provider's connected-device list, turns off the consumer if needed, and updates provider power state.

## Fuel

### `AE3_power_fnc_getFuelLevel`

Returns generator fuel in liters, percent, and capacity.

```sqf
private _fuelInfo = [_generator] call AE3_power_fnc_getFuelLevel;
_fuelInfo params ["_liters", "_percent", "_capacity"];
```

Return shape:

| Index | Meaning |
| --- | --- |
| `0` | Current fuel in liters. |
| `1` | Fuel percent, `0-100`. |
| `2` | Fuel capacity in liters. |

### `AE3_power_fnc_setFuelLevel`

Sets generator fuel percentage. The value is clamped between `0` and `100`.

```sqf
[_generator, 75] call AE3_power_fnc_setFuelLevel;
```

## Batteries

### `AE3_power_fnc_getBatteryLevel`

Returns battery level in Wh, percent, and capacity. Optionally shows a hint.

```sqf
private _batteryInfo = [_battery, false] call AE3_power_fnc_getBatteryLevel;
_batteryInfo params ["_wh", "_percent", "_capacityWh"];
```

Internal laptop battery example:

```sqf
private _internalBattery = _laptop getVariable ["AE3_power_internal", objNull];
if (!isNull _internalBattery) then {
    private _batteryInfo = [_internalBattery, true] call AE3_power_fnc_getBatteryLevel;
};
```

The function handles scheduled and unscheduled contexts. If called unscheduled with hint output, it spawns the remote variable fetch internally.

### `AE3_power_fnc_setBatteryLevel`

Sets battery level percentage. Must execute on the server.

```sqf
private _success = [_battery, 50] call AE3_power_fnc_setBatteryLevel;
```

Client-safe pattern:

```sqf
[_battery, 50] remoteExecCall ["AE3_power_fnc_setBatteryLevel", 2];
```

Return value: `true` on server success, `false` if called on a non-server machine.

## Output and Provider Calculations

### `AE3_power_fnc_getPowerOutput`

Returns current generator or solar-panel output in Watts. Optionally shows a hint.

```sqf
private _watts = [_generator, false] call AE3_power_fnc_getPowerOutput;
```

### `AE3_power_fnc_updatePower`

Checks whether a provider can supply all connected devices.

```sqf
private _insufficient = [_provider] call AE3_power_fnc_updatePower;
```

Return value is `true` when capacity is exceeded and power is insufficient.

### `AE3_power_fnc_batteryCalculation`

Calculates battery charge/discharge state.

```sqf
private _status = [_battery] call AE3_power_fnc_batteryCalculation;
_status params ["_hasCharge", "_levelKwh"];
```

### `AE3_power_fnc_solarCalculation`

Calculates solar output from sun position, panel orientation, and line-of-sight.

```sqf
private _status = [_solarPanel] call AE3_power_fnc_solarCalculation;
_status params ["_isProducing", "_outputKwh"];
```

These calculation functions are useful for diagnostics and custom provider integrations. Normal mission scripts usually do not call them directly.

## Complete Power Setup Example

```sqf
if (isServer) then {
    [_generator, 100] call AE3_power_fnc_setFuelLevel;
    [_laptop, _generator] call AE3_power_fnc_createPowerConnection;
    [_generator] call AE3_power_fnc_turnOnDevice;
    [_laptop] call AE3_power_fnc_turnOnDevice;
};
```

Battery and solar example:

```sqf
if (isServer) then {
    [_battery, 80] call AE3_power_fnc_setBatteryLevel;
    [_battery, _solarPanel] call AE3_power_fnc_createPowerConnection;
    [_laptop, _battery] call AE3_power_fnc_createPowerConnection;

    [_solarPanel] call AE3_power_fnc_turnOnDevice;
    [_battery] call AE3_power_fnc_turnOnDevice;
    [_laptop] call AE3_power_fnc_turnOnDevice;
};
```

## Common Failure Points

| Symptom | Likely cause |
| --- | --- |
| Device will not turn on | No provider, empty internal battery, insufficient generator output, or device already in use. |
| Laptop loses power when disconnected | Removing a provider can turn off a running consumer. |
| Battery set call returns false | It was called on a client instead of the server. |
| Power state text is hard to compare | `getPowerState` returns localized text. Use `AE3_power_powerState` for logic. |
| Network tests fail after power change | Routers and laptops must be powered for network routes to work. |

## Related Pages

- [Network API](Network-API.md)
- [Interaction API](Interaction-API.md)
- [Power System](../Systems/Power.md)
- [Locality and Multiplayer](../Developer/Locality-and-Multiplayer.md)
