# Power

AE3 power makes devices depend on generators, batteries, solar panels, internal batteries, and connection state. A device with no power source, or no power connection, simply won't turn on — this is the most common "why won't my laptop work" mission-testing issue.

## Power Sources

| Source | Notes |
| --- | --- |
| Generator | Usually needs fuel; runs out over time. |
| Battery | Uses stored charge; can be recharged from another source. |
| Solar panel | Output depends on configuration and sun/time-of-day. |
| Internal battery | Built into some devices such as routers or laptops — lets them run briefly with no external source. |

## Power Consumers

- Laptops.
- Routers.
- Lights.
- Batteries being charged (a battery can be both a source and a consumer).
- Headless servers: on **mains power** by default (no source needed, nothing drains). With *Requires external power* they behave like any consumer and need a cable to a powered source.

## Power States

Devices track a numeric power state (`AE3_power_powerState`): `0` off, `1` on, `2` standby, `3` crashed. `AE3_power_fnc_getPowerState` returns a localized string version for UI use.

## Editor Setup

Use `AE3: connect device to power source` (right-click connection in Eden). Scripted equivalent:

```sqf
[_laptop, _generator] call AE3_power_fnc_createPowerConnection;
```

Typical setup:

1. Place a laptop or router.
2. Place a generator, battery, or solar panel.
3. Configure fuel/power level in object attributes (Power Level, Powered On At Start).
4. Connect the consumer to the source.
5. Preview and test turn-on behavior.

## Player Workflow

Players may need to:

- Find a power source.
- Turn on a generator (ACE interaction).
- Check fuel or charge (SysInfo app, or object attribute inspection in testing).
- Connect a device to power (already wired in Eden, or a physical connection mission).
- Turn on the laptop or router.
- Restore power after a device crashes or shuts down (`AE3_power_fnc_crashDevice` reverses via power-cycle — turn the device off then on).

## Good Power Design

- Use power when it creates a meaningful objective (find fuel, repair a generator) — not as an incidental extra step before every laptop.
- Do not hide critical intel behind too many unrelated power steps.
- Make fuel, batteries, or generators discoverable near the device they power.
- Test whether players can physically reach and use the power objects in preview.
- If a laptop starts off, make that clear through mission context (a note, a briefing line) so players don't assume it's broken.

## Related Pages

- [Power API](../Reference/Power-API.md) — `turnOnDevice`, `turnOffDevice`, `standbyDevice`, `crashDevice`, power state details.
- [Configure Power](../Examples/Configure-Power.md) — worked example.
- [Eden Attributes](../Reference/Eden-Attributes.md) — Power Level, Powered On At Start fields.
