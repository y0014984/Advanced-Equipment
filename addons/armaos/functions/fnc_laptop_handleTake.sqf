/*
 * Author: Root
 * Description: Handles when a laptop item is picked up from a container/ground via vanilla inventory.
 *              This is called by CBA when using drag-and-drop inventory management.
 *
 * Arguments:
 * 0: _unit <OBJECT> - The unit that took the item
 * 1: _container <OBJECT> - The container the item was taken from
 * 2: _item <STRING> - The item class that was taken
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, _weaponHolder, "Item_Laptop_AE3_ID_1"] call AE3_armaos_fnc_laptop_handleTake;
 *
 * Public: No
 */

params ["_unit", "_container", "_item"];

// Check if this is a laptop item
if (_item find "Item_Laptop_AE3_ID_" != 0) exitWith {};

// When a laptop item is taken from a container, it's already in inventory
// Just log for debugging
if (AE3_DebugMode) then {
    diag_log format ["AE3: Laptop item %1 was taken by %2 from %3", _item, name _unit, _container];
};
