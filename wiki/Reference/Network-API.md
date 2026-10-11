# Network API

The Network component models routers, device uplinks, DHCP leases, static IPs, subnet routing, ping/resolve behavior, SSH reachability, and router external-access policy.

Use this API when scripts need to connect devices to routers, configure routers, assign static IPs, or test reachability.

## Concepts

| Concept | Meaning |
| --- | --- |
| Device | Laptop or other network-capable object. |
| Router | Object initialized as an AE3 router. Owns a gateway/subnet and DHCP leases. |
| Uplink | A device-to-router or router-to-router connection. |
| Gateway | Router IP, usually a `/24` base such as `10.0.0.1`. |
| DHCP lease | Automatically assigned IP inside the connected router subnet. |
| Static IP | Laptop-specific IP override for the current router. |
| External access | Router policy allowing devices from other gateways to reach this router's subnet. |

Most mission scripts only need `createNetworkConnection`, `applyRouterConfig`, and optionally `setStaticIp`.

## Connecting Devices

### `AE3_network_fnc_createNetworkConnection`

Creates a network connection from one object to another.

```sqf
[_from, _to] call AE3_network_fnc_createNetworkConnection;
```

Arguments:

| Index | Type | Meaning |
| --- | --- | --- |
| `0` | Object | Device or router being connected. |
| `1` | Object | Router or router target. |

Examples:

```sqf
[_laptop, _router] call AE3_network_fnc_createNetworkConnection;
[_routerA, _routerB] call AE3_network_fnc_createNetworkConnection;
```

The same behavior is exposed in Eden through `AE3: connect device to network router`.

### `AE3_network_fnc_removeNetworkConnection`

Removes the uplink for a network consumer.

```sqf
[_networkConsumer] call AE3_network_fnc_removeNetworkConnection;
```

Use this when you want to disconnect a laptop or router and update its interaction state.

### `AE3_network_fnc_disconnect`

Disconnects a device from its parent router.

```sqf
[_entity] call AE3_network_fnc_disconnect;
```

This is the simpler script call when you do not care about lower-level uplink details.

## Router Configuration

### `AE3_network_fnc_applyRouterConfig`

Applies router wireless/network configuration and broadcasts it.

```sqf
[_router, _name, _range, _password, _gateway, _allowExternal, _externalAllow] call AE3_network_fnc_applyRouterConfig;
```

Arguments:

| Index | Type | Default | Meaning |
| --- | --- | --- | --- |
| `0` | Object | Required | Router object. |
| `1` | String | Required | Network name/SSID. Blank keeps existing value. |
| `2` | Number | Required | Wireless range in metres. `<= 0` keeps existing value. |
| `3` | String | Required | Router password. Empty string means open network. |
| `4` | String or Array | Required | Gateway IP as `"a.b.c.d"` or `[a,b,c,d]`. Blank/invalid keeps existing value. |
| `5` | Bool | `false` | Allow ping/SSH from other gateways. |
| `6` | String | `""` | Comma/space separated allow list. Blank means any external gateway/source. |

Example: private local network.

```sqf
[_router, "Depot Net", 100, "depot-pass", "10.0.0.1", false, ""] call AE3_network_fnc_applyRouterConfig;
```

Example: allow selected external sources.

```sqf
[_router, "HQ Net", 150, "hq-pass", "10.10.0.1", true, "10\\.0\\.0\\..*,192\\.168\\.1\\.15"] call AE3_network_fnc_applyRouterConfig;
```

External allow entries may be gateway IPs, specific host IPs, or regex patterns matched against source IP/gateway strings.

## Static IPs

### `AE3_network_fnc_setStaticIp`

Applies or clears a laptop static IP after validating format and duplicate use.

```sqf
private _result = [_device, _ipStr] call AE3_network_fnc_setStaticIp;
```

Arguments:

| Index | Type | Meaning |
| --- | --- | --- |
| `0` | Object | Laptop/device. |
| `1` | String | Static IP. Empty string clears static lease for current network. |

Return value: HashMap describing success or failure.

Example:

```sqf
private _result = [_laptop, "10.0.0.42"] call AE3_network_fnc_setStaticIp;
if !(_result getOrDefault ["ok", false]) then {
    systemChat (_result getOrDefault ["error", "Failed to set static IP"]);
};
```

Static leases are stored per connected router. If a laptop moves to another router, it falls back to DHCP unless that router also has a static lease for the device.

## Transfer Speed

Simulated network transfers (desktop SSH app upload/download, Cyber Warfare downloads of sized files) use the mission setting `AE3_TransferSpeedNetwork` unless overridden. Priority: user account on the computer > computer > its router (then parent routers) > mission setting. For SSH transfers the operator's side sets the speed; the remote end only slows it if it has an override itself.

### `AE3_network_fnc_setTransferSpeed`

```sqf
[_device, _speedKBs, _user] call AE3_network_fnc_setTransferSpeed;
```

| Index | Type | Default | Meaning |
| --- | --- | --- | --- |
| `0` | Object | Required | Router, laptop or server. |
| `1` | Number | Required | Speed in KB/s. `0` or less removes the override. |
| `2` | String | `""` | Account name on a computer; `""` = whole device. |

Callable from any machine (routed to the server). Stored as `AE3_network_transferSpeed` and `AE3_network_userTransferSpeeds` (`[[user, KB/s], ...]`).

```sqf
[_router, 128] call AE3_network_fnc_setTransferSpeed;              // slow wifi
[_laptop, 4096, "operator"] call AE3_network_fnc_setTransferSpeed; // fast account
[_laptop, 0, "operator"] call AE3_network_fnc_setTransferSpeed;    // back to default
```

### `AE3_network_fnc_getTransferSpeed`

```sqf
private _kbps = [_computer, _user, _explicitOnly] call AE3_network_fnc_getTransferSpeed;
```

Returns the effective speed in KB/s. With `_explicitOnly = true` the mission setting is ignored and `-1` is returned when nothing is configured.

Also available: the Eden *Transfer speed (KB/s)* attribute on routers, laptops and servers, and the **AE3: Network Speed** module (Eden and Zeus).

## Routing and Reachability

### `AE3_network_fnc_ping`

Finds a target by IP through the physical network route.

```sqf
private _result = [_entity, _targetIp] call AE3_network_fnc_ping;
_result params ["_targetObject", "_routeLength"];
```

Arguments:

| Index | Type | Meaning |
| --- | --- | --- |
| `0` | Object | Source device. |
| `1` | Array | Target IP as `[a,b,c,d]`. |
| `2` | Object | Internal last hop. Optional. |
| `3` | Array | Internal visited devices. Optional. |

Return value:

| Index | Type | Meaning |
| --- | --- | --- |
| `0` | Object | Target object, or `objNull` if not reachable. |
| `1` | Number | Route length/hop cost. |

Example:

```sqf
private _targetIp = ["10.0.0.12"] call AE3_network_fnc_str2ip;
private _route = [_laptop, _targetIp] call AE3_network_fnc_ping;
_route params ["_target", "_length"];

if (isNull _target) then {
    systemChat "No route";
} else {
    systemChat format ["Route length: %1", _length];
};
```

### `AE3_network_fnc_resolve`

Resolves a target IP anywhere in the mission and enforces external gateway policy.

```sqf
private _result = [_source, _targetIp] call AE3_network_fnc_resolve;
```

Use `resolve` for higher-level operations such as SSH/message behavior, where cross-gateway policy matters.

Rules:

- Targets on the source device's own gateway are reachable if the route exists.
- Targets on a different gateway require the target router to allow external access.
- If the target router defines an external allow list, the source IP/gateway must match at least one entry.
- The target owning router is found through the global router registry by subnet.

Return shape is the same as `ping`: `[targetObject, routeLength]`, with `objNull` for blocked/unreachable.

## IP Helpers

### `AE3_network_fnc_str2ip`

Converts an IP string into an integer array.

```sqf
private _ip = ["10.0.0.12"] call AE3_network_fnc_str2ip;
```

Returns `[]` when the string is not four numeric octets.

### `AE3_network_fnc_ip2str`

Converts an IP array to a string.

```sqf
private _text = [[10, 0, 0, 12]] call AE3_network_fnc_ip2str;
```

## DHCP and Duplicate Checks

### `AE3_network_fnc_dhcp_get`

Hands out a lease from a router subnet.

```sqf
private _ip = [_router] call AE3_network_fnc_dhcp_get;
```

This is mostly used internally when devices turn on or connect.

### `AE3_network_fnc_ipInUse`

Checks whether another initialized laptop already owns an IP address.

```sqf
private _used = [_device, [10, 0, 0, 42]] call AE3_network_fnc_ipInUse;
```

Use this before custom static-IP tooling.

## Complete Network Setup Example

```sqf
if (isServer) then {
    [_router, "Depot Net", 100, "depot-pass", "10.0.0.1", false, ""] call AE3_network_fnc_applyRouterConfig;
    [_laptopA, _router] call AE3_network_fnc_createNetworkConnection;
    [_laptopB, _router] call AE3_network_fnc_createNetworkConnection;

    [_laptopA, "10.0.0.20"] call AE3_network_fnc_setStaticIp;
    [_laptopB, "10.0.0.21"] call AE3_network_fnc_setStaticIp;
};
```

## Debugging

When AE3 debug or network debug is enabled, route functions write hop-by-hop detail to the RPT. Use this to identify:

- Powered-off routers.
- Cyclic connections.
- Devices on a different gateway.
- Blocked external access.
- Duplicate or invalid static IPs.
- Missing parent router connections.

## Related Pages

- [Power API](Power-API.md)
- [Terminal Commands](Terminal-Commands.md)
- [Networking System](../Systems/Networking.md)
- [Locality and Multiplayer](../Developer/Locality-and-Multiplayer.md)
