# Networking

AE3 networking lets laptops and routers communicate. Missions can use it for ping tests, SSH chains, chat, remote laptop access, and network-gated objectives.

## Core Objects

- **Router** — creates a network and assigns addresses (a gateway + DHCP subnet).
- **Laptop** — connects to a router and uses network tools.
- **Parent router** — a router-to-router connection joins two subnets together for multi-network scenarios.

## Router Settings

Configure routers in object attributes:

| Attribute | Meaning |
| --- | --- |
| Network Name (SSID) | Visible network name. |
| Default Gateway | Optional router address, e.g. `10.0.0.1`. Leave blank for AE3 to assign one. |
| Wifi Range (m) | Connection range. |
| Network Password | Required password, or blank for open network. |
| Powered On At Start | Starts the router automatically. |
| Allow External SSH | Allows access from other gateways/subnets. |
| External Allowed IPs | Optional allow-list (comma/space separated gateway, host, or regex) for external routes. |

For simple missions, leave Default Gateway blank and let AE3 assign addresses via DHCP.

## Editor Connections

Use `AE3: connect device to network router` (right-click connection in Eden). Scripted equivalent:

```sqf
[_laptop, _router] call AE3_network_fnc_createNetworkConnection;
[_routerA, _routerB] call AE3_network_fnc_createNetworkConnection;
```

Common setups:

- One laptop to one router.
- Multiple laptops to one router (shared subnet, laptops can `ping`/`msg`/`ssh` each other).
- Router to parent router for multi-network scenarios — set Allow External SSH + External Allowed IPs if players should be able to reach across.

## Player Workflow

When configured, players can:

- Check their network information (`ip`).
- Ping another address (`ping <ip>`).
- Connect to remote systems through SSH (`ssh <ip>`).
- Send messages (`msg <ip> <text>`).
- Use network-aware desktop apps (Chat).

## Good Network Design

- Give players a reason to know or discover an IP address (a note, a config file, a `ping` sweep result) rather than expecting them to guess.
- Avoid too many routers unless routing itself is part of the puzzle.
- If a network password is required, make it discoverable.
- If external access across routers is required, test it on a dedicated server — client-hosted previews can mask locality issues.
- Keep router names and addresses readable and consistent (`HQ-Router` / `10.0.0.1`, not arbitrary strings).

## Transfer Speed

Simulated network transfers (desktop SSH app upload/download, Cyber Warfare downloads of sized files) run at a speed in KB/s. Everyone uses the mission-wide *Transfer speed: network* CBA setting until a mission maker overrides it:

| Level | Set with |
| --- | --- |
| User account on a laptop/server | **Network Speed** module (Eden: sync to the computer, fill *User accounts*; Zeus: drop on the computer) |
| Laptop/server | *Transfer speed (KB/s)* object attribute, or the module with *User accounts* empty |
| Wifi network (router, and routers below it) | *Transfer speed (KB/s)* router attribute, or the module on a router |

The most specific level wins (user > computer > wifi network > mission setting). For SSH transfers the operator's side sets the speed; the remote end only slows it when it has an override of its own. A speed of 0 removes an override.

```sqf
[_router, 128] call AE3_network_fnc_setTransferSpeed;              // slow wifi
[_laptop, 4096, "operator"] call AE3_network_fnc_setTransferSpeed; // fast account
[_laptop, "operator"] call AE3_network_fnc_getTransferSpeed;       // effective KB/s
```

File sizes are set per file: *Virtual file size* on the Add File module (Eden/Zeus), `device_addFile`/`device_writeFile` size argument, or `AE3_filesystem_fnc_device_setFileSize` for an existing file. See [Filesystem API](../Reference/Filesystem-API.md#virtual-file-size).

## Related Pages

- [Network API](../Reference/Network-API.md) — `createNetworkConnection`, `applyRouterConfig`, static IPs, SSH/resolve behavior.
- [Build a Network](../Examples/Build-a-Network.md) — worked multi-laptop/router example.
- [Terminal Commands](../Reference/Terminal-Commands.md) — `ip`, `ping`, `ssh`, `msg`.
