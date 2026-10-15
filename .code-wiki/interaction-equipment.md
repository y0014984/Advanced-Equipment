---
topic: interaction-equipment
status: verified
last-verified: 2026-07-08
confidence_score: 1.0
priority: support
tokens: ~370
code-paths:
  - addons/interaction/
  - addons/interaction/CfgVehicles.hpp
related-topics: [power-model, armaos-terminal, flashdrive-usb, main-runtime-infrastructure]
related-docs:
  - wiki/Systems/Interactions.md
---

# Interaction Equipment

## overview

The interaction component compiles AE3 equipment config, initializes ACE interactions, manages open/close states, and provides actions for lamps, laptops, desks, solar panels, carrying, dragging, and cargo.

## current behavior

- `XEH_preInit.sqf` registers a CBA class event handler so all objects run AE3 interaction compilation/init logic.
- Equipment config supplies ACE dragging, carrying, cargo, animation, and condition settings.
- `AE3_interaction_fnc_initAce3Interactions` runs on the server, stores ACE settings in `AE3_SettingsACE3`, and calls `manageAce3Interactions` to apply the initial state.
- Laptop and desk open/close functions are separate from power functions, but power action conditions check `AE3_interaction_closeState`.
- Other components call into interaction helpers to nest their actions under the common equipment parent action when it exists.
- **`ensureEquipmentParent` always ends with the parent present**, so `AE3_interaction_hasEquipmentAction` is `true` for every AE3 device and `["ACE_MainActions", "AE3_EquipmentAction"]` is the only node anything hangs actions from. The `AE3_DeviceAction` fallback node the init functions used to branch to was therefore never created, and anything registered under it never rendered - that is how the generators lost *Check Fuel Level* and *Check Power Output*. `AE3_power_fnc_initDevice` now publishes the path it used as the local object variable `AE3_power_actionPath`, and the per-type init functions read it instead of guessing. The function's return value reports whether it *created* the parent, not whether one exists - do not branch on it.
- **A class built on a vanilla prop needs its own `ACE_Actions >> ACE_MainActions`.** With no config entry ACE synthesises the base action at the model origin with a 2 m reach (`ace_interact_menu_fnc_addMainAction.sqf:27-30`, `fnc_createAction.sqf:38-39`) and `fnc_renderBaseMenu.sqf:47-50` hides the *entire* menu beyond it, so a large static simply has no interaction at all. Vehicle bases hid this: `StaticWeapon` ships `selection = "gunnerview"; distance = 4`. The generator master declares `distance = 4` and the two large statics (`Land_MobileRadar_01_generator_F_AE3`, `Land_PowerGenerator_F_AE3`) widen it to 6. Small props (batteries, portable solar) are inside the 2 m default and need nothing.
- Class-name matching in the `ensureEquipmentParent` label switch is done on `toLowerANSI` of the type, because `find` on a string is case sensitive and AE3/vanilla class names are not consistently capitalised. The desk branch matches `desk` only - `table` is a substring of `portable`.

## decisions

- A shared equipment parent action is used as a coordination point for power, network, laptop, and equipment-specific interactions, preventing multiple top-level ACE actions from accumulating on the same object.
- Interaction state is stored on object variables rather than recomputed from animation phase every time, giving ACE action visibility and multiplayer state a simple synchronized source.
- ACE dragging/carrying/cargo settings are compiled from config into a hashmap, so runtime code can work against one normalized shape regardless of how each vehicle class is configured.

## gotchas

- The "use laptop from inventory" stand-in model (`_useFromInventory` in `armaos/XEH_preInit.sqf` -> `AE3_armaos_fnc_inventoryProp_spawn`/`_remove`, server-side) is a networked `createVehicle` of the laptop's **non-AE3 base class** (`configName (inheritsFrom (configOf _laptop))`, e.g. `Land_Laptop_03_black_F`). That base has the same model but none of the AE3 init EHs, so it is a plain prop, not a second functional laptop - creating the `_AE3` class directly would fire `compileEquipment`/`initDevice` and duplicate the laptop. Simulation is disabled, it is attached to the operator, stored on the laptop (`AE3_armaos_invProp`), and JIP is automatic (real networked object). Removed when the session ends, the player dies, or the laptop is gone.
- Duplicate action prevention is spread across components with component-specific flags.
- Interaction initialization differs between server authority and client ACE menu creation.
- Closing/opening state can block power operations.

## re-verify when

- ACE menu paths, equipment config classes, laptop/desk open-close functions, or action-added flags change.
- An AE3 class is rebased onto a different parent, especially from a vehicle base onto a prop: re-check its `ACE_Actions` reach.

## references

- `addons/interaction/functions/fnc_initAce3Interactions.sqf`
- `addons/interaction/functions/fnc_initInteraction.sqf`
- `addons/interaction/functions/fnc_manageAce3Interactions.sqf`
- `addons/interaction/functions/fnc_laptop_open.sqf`
- `addons/interaction/functions/fnc_laptop_close.sqf`

