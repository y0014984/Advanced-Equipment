/*
 * Author: Root
 * Description: Handles deploying a laptop from inventory to the ground.
 *
 * Arguments:
 * 0: _player <OBJECT> - The player deploying the laptop
 *
 * Return Value:
 * <BOOL> - True if deployment successful, false otherwise
 *
 * Example:
 * [player] call AE3_armaos_fnc_laptop_deploy;
 *
 * Public: No
 */

params ["_player"];

// Find all laptop items in player's inventory with their display names
private _laptopItems = [];
private _laptopNames = [];

// Get the laptop item buffer to retrieve names
[missionNamespace, "AE3_LAPTOP_ITEM"] call AE3_main_fnc_getRemoteVar;
private _buffer = missionNamespace getVariable ["AE3_LAPTOP_ITEM", createHashMap];

{
	if (_x find "Item_Laptop_AE3_ID_" == 0) then {
		_laptopItems pushBack _x;

		// Get the stored laptop name
		private _laptopName = "Laptop";
		if (_x in _buffer) then {
			private _itemData = _buffer get _x;
			_laptopName = _itemData getOrDefault ["AE3_LAPTOP_NAME", format ["Laptop %1", count _laptopItems]];
		};
		_laptopNames pushBack _laptopName;
	};
} forEach (items _player);

if (_laptopItems isEqualTo []) exitWith {
	hint "No laptop in inventory.";
	false
};

// If player has multiple laptops, deploy the first one and show info
private _itemToDeploy = _laptopItems select 0;

if (count _laptopItems > 1) then {
	// Inform player which laptop is being deployed
	hint format ["Deploying: %1\n\n%2 other laptop(s) remain in inventory:\n%3",
		_laptopNames select 0,
		(count _laptopItems) - 1,
		_laptopNames joinString "\n"
	];
};

// Calculate deployment position in front of player
private _deployPos = _player modelToWorld [0, 1.5, 0];
_deployPos set [2, 0]; // Place on ground level

// Deploy the laptop
private _deployedLaptop = [_player, _itemToDeploy, _deployPos] call AE3_armaos_fnc_laptop_item2obj;

if (isNull _deployedLaptop) exitWith {
	false
};

true
