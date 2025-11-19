/*
 * Author: Root
 * Description: Handles when a laptop item is placed/dropped on the ground via vanilla inventory.
 *              This ensures the laptop object is properly recreated with all state intact.
 *
 * Arguments:
 * 0: _unit <OBJECT> - The unit that dropped the item
 * 1: _container <OBJECT> - The container the item was placed in (weaponholder or ground)
 * 2: _item <STRING> - The item class that was dropped
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, _weaponHolder, "Item_Laptop_AE3_ID_1"] call AE3_armaos_fnc_laptop_handlePut;
 *
 * Public: No
 */

params ["_unit", "_container", "_item"];

// Check if this is a laptop item
if (_item find "Item_Laptop_AE3_ID_" != 0) exitWith {};

// Check deployment type setting: 0 = Stable, 1 = Experimental
private _deploymentType = missionNamespace getVariable ["AE3_DeploymentType", 0];

if (_deploymentType == 0) then {
	// Stable mode - check if this is a tracked stable item
	private _laptopTracker = missionNamespace getVariable ["AE3_LAPTOP_STABLE_TRACKER", createHashMap];

	if (_item in _laptopTracker) then {
		// This is a stable mode item - don't auto-deploy when dropped
		// The item will stay in the weaponholder/container and players can pick it up normally
		if (AE3_DebugMode) then {
			diag_log format ["AE3: Stable laptop item %1 was dropped into container %2 (not auto-deploying)", _item, _container];
		};
	} else {
		// Not a tracked stable item, treat as normal drop (shouldn't happen in stable mode)
		if (AE3_DebugMode) then {
			diag_log format ["AE3: Warning - Laptop item %1 dropped but not found in stable tracker", _item];
		};
	};
} else {
	// Experimental mode - auto-deploy when dropped on ground
	// Get the position where the item was dropped (weaponholder position)
	private _pos = getPosATL _container;

	// Small delay to ensure the item is removed from inventory first
	[{
		params ["_unit", "_container", "_item", "_pos"];

		// Convert the item back to a laptop object
		private _laptop = [_unit, _item, _pos] call AE3_armaos_fnc_laptop_item2obj;

		// If successful, the laptop object now exists at the drop position
		if (!isNull _laptop) then {
			// The item was already removed from player inventory by Arma
			// The weaponholder will clean itself up since we removed the item programmatically
			if (AE3_DebugMode) then {
				diag_log format ["AE3: Laptop item %1 was dropped and recreated as object %2", _item, _laptop];
			};
		};
	}, [_unit, _container, _item, _pos], 0.1] call CBA_fnc_waitAndExecute;
};
