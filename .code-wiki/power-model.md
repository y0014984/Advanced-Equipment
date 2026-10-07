---
topic: power-model
status: verified
last-verified: 2026-07-08
confidence_score: 1.0
priority: core
rank: 6
tokens: ~470
code-paths:
  - addons/power/
  - addons/armaos/functions/fnc_computer_*.sqf
  - addons/power/Cfg3DEN.hpp
related-topics: [network-routing-and-ssh, interaction-equipment, eden-zeus-tooling, multiplayer-locality-and-sync, main-runtime-infrastructure]
related-docs:
  - wiki/Systems/Power.md
  - wiki/Reference/Power-API.md
---

# Power Model

## overview

The power component models devices, providers, consumers, batteries, generators, solar panels, power connections, power state, power draw, capacity checks, and crash/standby behavior.

## current behavior

- Power devices store wrapper functions and state on object variables such as `AE3_power_fnc_turnOnWrapper`, `AE3_power_fnc_turnOffWrapper`, `AE3_power_fnc_standbyWrapper`, and `AE3_power_powerState`.
- Power state values are numeric: `0` off, `1` on, `2` standby, `3` crashed.
- `AE3_power_fnc_initDevice` installs ACE actions on clients and initializes authoritative power state on the server.
- Power providers track connected devices and capacity; `AE3_power_fnc_updatePower` sums connected device draw and turns the provider off when draw exceeds capacity.
- Batteries and generators use periodic calculations for capacity, fuel, and output. Solar panels use sun position/orientation helpers.
- **A generator's fuel level is not engine fuel.** The generator classes are prop-based (see [[eden-zeus-tooling]] for why), and `fuel`/`setFuel` only work on `AllVehicles`, so the level lives in litres in the ACE refuel cargo store and is reached through `ace_refuel_fnc_getFuel`/`setFuel`. Only `AE3_power_fnc_getFuelLevel` and `AE3_power_fnc_setFuelLevel` touch that store; `fnc_fuelConsumption`, `fnc_turnOnGeneratorAction`, `fnc_initGenerator` and the Zeus/Eden attribute paths all go through those two or through ACE directly. Using ACE's own store is what keeps a nozzle able to refuel a generator, and `fnc_initGenerator` writes `ace_refuel_capacity` itself rather than relying on the class's `ace_refuel_fuelCargo`, so an arbitrary object passed to that public function can still hold fuel. Side effect: a generator is ACE fuel cargo, so a nozzle can draw fuel out of one as well as put it in. `AE3_main_fnc_replace` still copies engine fuel only and will not carry a generator's level (it has no callers).
- **Scripted power-on/off must be silent.** `AE3_power_fnc_turnOnDevice`/`turnOffDevice` pass `[true]` through the wrapper (`fnc_initDevice.sqf:32-35` forwards extra args to the configured action), because a generator's turn-on and turn-off actions otherwise open a 5 s `ace_common_fnc_progressBar` that nothing drives on a scripted call - it fails, plays the stop sound and leaves the device as it was. The ACE interaction calls `AE3_power_fnc_turnOnWrapper` directly (`fnc_initDevice.sqf:165`, `interaction/fnc_initInteraction.sqf:161`) and so keeps its progress bar. This is what broke the Eden *Powered On At Start* attribute and the Zeus panel for generators.
- **A generator's running sound is script-driven.** `class Sounds >> Engine` has `volume = "engineOn * camPos"` and a prop-based generator has no engine simulation, so that config entry never sounds. `AE3_power_fnc_playGeneratorRunningSound` registers a 1 s per-frame handler per generator **per client** from `fnc_initGenerator` (so a JIP player hears a generator that is already running) and plays the same config sound through `playSound3D` with the trailing `local` and `loop` flags both set. `playSound3D` has *global* effect locality, so the local flag is what stops every client broadcasting its own copy; looping requires it. The loop is gated on the public `AE3_power_engineSoundOn` flag, raised by `fnc_playGeneratorStartSound` once the startup sound ends and cleared by `fnc_playGeneratorStopSound`, which is exactly the stretch `engineOn` used to cover. A looping sound is pinned to the position it started at, so the handler restarts it if the generator is dragged more than 2 m. `engineOn` is still called for a generator registered on a vehicle-based object.
- **Generator start/stop sounds run with the ACE progress bar.** `fnc_turnOnGeneratorAction`/`fnc_turnOffGeneratorAction` spawn `fnc_playGeneratorStartSound`/`StopSound` when the bar opens and keep the script handle in the bar's args; on success the turn-on/off func is called with `_soundStarted = true` so it does not spawn a second copy, on cancel the handle is `terminate`d (the start script dies in its `sleep 6`, before it raises `AE3_power_engineSoundOn`/`engineOn`) and the opposite sound is spawned. The silent path (Zeus/scripted) spawns the sound from the func itself. The already-playing `playSound3D` clip is not stopped on cancel - its id is per machine. Both sounds pass `getPosASL` as the sound position (`playSound3D` expects ASL).
- Eden power connections are declared in `addons/main/Cfg3DEN.hpp` and call `AE3_power_fnc_createPowerConnection`.
- Zeus can create power connections through the Add Connection module after class validation.
- Power sync can be disabled through `AE3_Power_EnableStateSync`; sync reduction is controlled separately by `AE3_Power_ChangeThreshold`.

## decisions

- Turn-on/off/standby behavior is stored as object-specific wrapper functions, so different devices can use the same power state interface while running different animations, sounds, filesystem updates, or startup sequences.
- Providers are responsible for overload detection, keeping capacity logic near the power source rather than spreading it across consumers.
- Eden connections are custom 3DEN connection types instead of synchronized modules, making connection lines easier for mission makers to inspect and resolve on mission start.
- Power state sync is configurable: `AE3_Power_EnableStateSync` gates whether state sync happens, while `AE3_Power_ChangeThreshold` reduces noisy battery/generator updates for multiplayer performance.

## gotchas

- `initDevice` has duplicate-action protection through `AE3_power_actionsAdded`; new ACE actions should respect that pattern.
- Starting powered-on depends on `AE3_power_startOn` being set before init completes. The `AE3_POWER_STARTON_ATTRIBUTE` macro (top of `addons/power/CfgVehicles.hpp`) supplies the Eden "Powered On At Start" checkbox on every power device and cannot rely on that ordering, so its expression both sets the variable and, when ticked, waits for `AE3_power_initDone` + `AE3_power_fnc_turnOnWrapper` and calls `turnOnDevice` itself - same shape as `AE3_LaptopStartOn` in `addons/armaos/CfgVehicles.hpp`.
- The Zeus asset panel carries the same toggle as a "Powered On" checkbox (IDC 1014 label / 1322 checkbox, `addons/main/CfgUserInterfaceZeus.hpp`), shown for anything with an `AE3_Device` config class. `fnc_zeus_updateAttributes` applies it only when it differs from `AE3_power_powerState`, and through `remoteExecCall` to the server, because the state and its mutex are shared.
- Overload turns the provider off asynchronously through the stored wrapper.
- Some power interactions are nested under the shared equipment parent action when available.

## re-verify when

- Power provider/consumer config classes, power connection creation, state sync, or device init callbacks change.
- New equipment types consume or provide power.

## references

- `addons/power/functions/fnc_initDevice.sqf`
- `addons/power/functions/fnc_updatePower.sqf`
- `addons/power/functions/fnc_batteryCalculation.sqf`
- `addons/power/functions/fnc_createPowerConnection.sqf`
- `addons/main/Cfg3DEN.hpp`

