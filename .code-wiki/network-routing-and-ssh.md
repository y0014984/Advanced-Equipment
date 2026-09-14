---
topic: network-routing-and-ssh
status: verified
last-verified: 2026-07-08
confidence_score: 1.0
priority: core
rank: 3
tokens: ~560
code-paths:
  - addons/network/
  - addons/armaos/functions/fnc_os_ssh.sqf
  - addons/desktop/functions/fnc_sshOpServer.sqf
related-topics: [armaos-terminal, desktop-gui-and-browser, power-model, eden-zeus-tooling, multiplayer-locality-and-sync, main-runtime-infrastructure]
related-docs:
  - wiki/Systems/Networking.md
  - wiki/Reference/Network-API.md
---

# Network Routing And SSH

## overview

The network component manages routers, laptop/router network connections, DHCP/static addressing, wireless range and passwords, route resolution, ping, and the routing policy used by CLI and desktop SSH.

## current behavior

- Routers are initialized with gateway addresses, wireless range/password state, parent/child links, DHCP address tracking, and a global router registry in `AE3_network_routers`.
- Any router initialized with the default gateway address and no valid preset can receive the next sequential `/24` gateway: `192.168.0.1`, `192.168.1.1`, and so on. The code explicitly applies this to cascaded child routers too.
- Laptops connect to routers through Eden connections, Zeus object attributes, ACE interactions, desktop network app commands, or network API calls.
- `AE3_network_fnc_resolve` maps a target IP to the owning router by subnet, then calls `AE3_network_fnc_ping` from that router to find the device.
- Same-subnet targets still require the target device to enable SSH, similar to the router `AE3_network_allowExternalSsh` policy used for external access. Cross-gateway reachability depends on the target router's `AE3_network_allowExternalSsh` and optional `AE3_network_externalAllow` allow list.
- External allow-list entries can be gateway IPs, host IPs, or regex patterns matched against the source IP or source gateway prefix.
- CLI SSH is handled by terminal commands and changes the shell's execution target. Desktop SSH uses web commands, server-side operations, and asynchronous browser replies.
- Network debug output is controlled by global debug mode or `AE3_NetworkDebugEnabled`.

## decisions

- Cross-gateway routing uses a global router registry instead of requiring physical router-to-router links. This lets scenario authors model separated subnets while still allowing controlled intel/SSH routes.
- Router external access is enforced on the destination router, so the owner of the protected subnet decides whether external laptops may reach it.
- Desktop SSH runs sensitive operations on the server, keeping remote filesystem and user auth authoritative instead of trusting browser/client state.
- Wireless range and passwords are router object variables rather than global settings, allowing missions to mix open/locked networks with different ranges.

## addressing is server-authoritative

Every function that hands out or changes an address runs on the server, because duplicate detection
needs the full device registry and only the server holds it. `connect_device2router`,
`connect_router2router`, `removeNetworkConnection`, `dhcp_refresh` and `dhcp_onTurnOn` each begin with
an `if (!isServer) exitWith { ... CBA_fnc_serverEvent }` hand-off (`ae3_network_connectDevice`,
`ae3_network_connectRouter`, `ae3_network_disconnectDevice`, `ae3_network_dhcpRefresh`,
`ae3_network_dhcpTurnOn`, registered in `addons/network/XEH_preInit.sqf`); payloads are netId strings
only. `dhcp_get` and `setStaticIp` return values and so cannot route themselves - they carry a hard
`isServer` exit plus a `WARNING_1` that fires if a new client-side allocation path is ever added.

This matters because the ACE interaction menu (`fnc_promptConnect`, `fnc_connectSubmitPassword`,
`fnc_disconnect`) calls these functions on the clicking client. Before the hand-off, that client ran
`ipInUse` against `ae3_desktop_computers`, which existed only on the server, so the duplicate check
always returned `false` and every ACE-menu connect on a dedicated server handed out a colliding
address. SP/hosted never showed it because there the player's machine is the server.

`ipInUse` now also treats a router's own gateway address as taken, and `ae3_desktop_computers` is
broadcast (`addons/desktop/XEH_preInit.sqf`) so client-side reads see the real device set.

## gotchas

- `AE3_network_externalAllow` accepts regex, so invalid patterns are caught and ignored per entry.
- The global router registry can contain dead/null routers; lookup code skips them, but future registry iteration must do the same.
- `resolve` only gets callers to the target router. `ping` can still return `objNull` when the target device is dead or powered off.
- Desktop SSH payloads avoid HashMaps across network events; operation arguments are serialized as arrays/plain strings.
- A preset static IP/gateway must be a four-number array to be honored by router init.
- Zeus applies terminal/router attributes through named functions (`AE3_armaos_fnc_computer_setHostname`, `AE3_network_fnc_setSshEnabled`, `AE3_network_fnc_setStaticIpZeus`), not `remoteExecCall ["setVariable", 2]`. `setStaticIpZeus` exists purely so the curator gets the server's real verdict (`ae3_network_zeusIpResult` -> `BIS_fnc_curatorHint`); the attribute dialog used to report success even for a rejected address.
- The Zeus attribute panel bounds its wait on `AE3_power_initDone` and merges `AE3_network_routers` into its `nearestObjects` router picker, so a slow-replicating flag or a long-range router no longer leaves the panel unusable.

## static IP is subnet-gated per gateway

When a device joins a router (`fnc_connect_device2router`) or a router refreshes leases (`fnc_dhcp_refresh`), the static address is resolved in order: per-router lease (`AE3_network_staticIpByRouter`, keyed by `netId` of the router — trusted as-is) → the 3DEN default `AE3_network_staticIpDefault`. The default is only honored when it sits in the **new gateway's /24** (`AE3_network_fnc_ipInSubnet`, compares first 3 octets against `_parent`/`_entity`'s own `AE3_network_address`); otherwise the device drops to a DHCP lease. This stops a static from a previous network carrying across when switching WiFi. `fnc_ipInUse` only checks duplicates, not subnet, so the subnet gate is what prevents out-of-subnet statics.

## re-verify when

- Router initialization, DHCP, static IP, route resolution, ping, SSH, or Zeus/Eden network connection behavior changes.
- New network policy variables or CBA settings are added.

## references

- `addons/network/functions/fnc_initRouter.sqf`
- `addons/network/functions/fnc_resolve.sqf`
- `addons/network/functions/fnc_ping.sqf`
- `addons/network/functions/fnc_createNetworkConnection.sqf`
- `addons/armaos/functions/fnc_os_ssh.sqf`
- `addons/desktop/functions/fnc_sshOpServer.sqf`
- `addons/network/XEH_preInit.sqf`
- `addons/network/functions/fnc_ipInUse.sqf`
- `addons/network/functions/fnc_setStaticIpZeus.sqf`
- `addons/network/functions/fnc_setSshEnabled.sqf`

