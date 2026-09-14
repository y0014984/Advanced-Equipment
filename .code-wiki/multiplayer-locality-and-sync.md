---
topic: multiplayer-locality-and-sync
status: verified
last-verified: 2026-07-08
confidence_score: 1.0
priority: core
rank: 8
tokens: ~365
code-paths:
  - addons/main/functions/fnc_getRemoteVar.sqf
  - addons/main/functions/fnc_sendVarToRemote.sqf
  - addons/*/functions/*.sqf
  - addons/*/XEH_preInit.sqf
  - addons/desktop/XEH_postInit.sqf
related-topics: [armaos-terminal, desktop-gui-and-browser, filesystem-model, network-routing-and-ssh, power-model, desktop-intel-and-communications, main-runtime-infrastructure]
related-docs:
  - wiki/Developer/Locality-and-Multiplayer.md
---

# Multiplayer Locality And Sync

## overview

AE3 relies heavily on object variables, CBA events, remote execution, and server-authoritative state for multiplayer correctness across laptops, routers, filesystems, power devices, and browser-backed GUI apps.

## current behavior

- `AE3_main_fnc_getRemoteVar` requests a variable from another machine, waits for a transfer flag, and writes the remote value locally.
- `AE3_main_fnc_sendVarToRemote` is the paired transfer function; it sends both the requested variable and `<variable>_trans` completion flag back to the caller.
- Many mutable object states are server-authoritative and broadcast with `setVariable` target `true`, `2`, or selected client IDs.
- Desktop GUI state is split: authoritative laptop state lives on the object, while active window/session state lives in `uiNamespace` on the operator client.
- Browser-backed desktop apps use a mix of CBA server events and direct `remoteExec`/`remoteExecCall` for actions that need server authority, then receive replies through client CBA events and `jsSend` where asynchronous replies are needed.
- Several subsystems expose CBA settings that intentionally reduce sync volume, including filesystem sync mode, power state sync, and terminal UI-on-texture update intervals.

## decisions

- AE3 uses explicit remote variable pull instead of assuming a client always has current object variables. Laptop filesystems/user lists can be large and may not be present when a UI opens or a module fires.
- Browser operations use request IDs (`rid`) for asynchronous replies because many GUI actions cross client/server boundaries and need to resolve a JavaScript promise after a delayed server response.
- UI-on-texture is configurable and throttled because live terminal mirroring can be network-expensive, so missions need control over update rate and range.

## gotchas

- `getRemoteVar` waits and therefore requires scheduled execution unless it can spawn itself.
- Passing HashMaps through multiplayer events can be unreliable; desktop SSH explicitly serializes operation arguments into arrays/plain strings.
- **Never send a HashMap as a CBA event payload.** In SP/hosted the "remote" machine is the local one and the HashMap survives by reference, so a broken payload only shows on a dedicated server, where the browser request then never resolves. Every server->client web reply now goes through `AE3_desktop_fnc_routeReply`, which `CBA_fnc_encodeJSON`s the payload; the `ae3_desktop_routeReply` handler in `addons/desktop/XEH_postInit.sqf` parses it back with `CBA_fnc_parseJSON` mode 2 and forwards it via `jsSend`. The old `ae3_desktop_sshReply` event was folded into this and no longer exists.
- Object variables are sometimes synced to server only, sometimes all clients, and sometimes a specific owner.
- Client-only session data in `uiNamespace` must not be treated as authoritative mission state.
- A server-only `missionNamespace` variable read by a function that clients can also reach is a silent-failure pattern: the client sees the default and the check it guards passes vacuously. `ae3_desktop_computers` was exactly this (see [[network-routing-and-ssh]]); it is now broadcast.
- Prefer a named addon function over `remoteExecCall ["<raw command>", 2]`. Raw commands need their own BattlEye/`CfgRemoteExec` exclusions and are commonly filtered on dedicated servers, so the write silently never lands.

## re-verify when

- Any function changes `remoteExec`, CBA event payloads, `getRemoteVar`, browser command replies, filesystem sync mode, or UI-on-texture sync.

## references

- `addons/main/functions/fnc_getRemoteVar.sqf`
- `addons/main/functions/fnc_sendVarToRemote.sqf`
- `addons/desktop/functions/fnc_jsRouter.sqf`
- `addons/desktop/XEH_postInit.sqf`
- `addons/armaos/XEH_preInit.sqf`
- `addons/filesystem/XEH_preInit.sqf`
- `addons/power/XEH_preInit.sqf`

