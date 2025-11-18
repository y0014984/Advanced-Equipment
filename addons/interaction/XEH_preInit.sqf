#include "script_component.hpp"
#include "XEH_PREP.hpp"

// Helper function to ensure equipment parent action exists on an object
// Returns true if parent was added, false if it already existed
AE3_interaction_fnc_ensureEquipmentParent = {
    params ["_object", ["_displayName", ""]];

    // Check if parent already exists by checking the flag
    private _hasParent = _object getVariable ["AE3_interaction_hasEquipmentAction", false];

    // DEBUG: Log parent action attempts with timestamp
    diag_log format ["[AE3 DEBUG] [%1] ensureEquipmentParent called on %2 (type: %3) | hasParent: %4", time, _object, typeOf _object, _hasParent];
    diag_log format ["[AE3 DEBUG] [%1] Call stack: %2", time, diag_stacktrace];

    if (!_hasParent) then {
        // Set flag IMMEDIATELY to prevent race conditions between multiple init systems
        // This must happen before any other code to ensure atomicity
        diag_log format ["[AE3 DEBUG] [%1] ensureEquipmentParent: SETTING hasEquipmentAction flag to TRUE for %2", time, _object];
        _object setVariable ["AE3_interaction_hasEquipmentAction", true];
        diag_log format ["[AE3 DEBUG] [%1] Creating parent action for %2 with displayName: %3", time, _object, _displayName];
        // If no display name provided, determine it based on object type
        if (_displayName isEqualTo "") then {
            private _typeOf = typeOf _object;

            // Map specific object types to friendly names
            switch (true) do {
                // Laptops - all variants
                case (_typeOf find "Laptop" >= 0): {
                    _displayName = "Laptop";
                };
                // USB Flash Drives
                case (_typeOf find "USB" >= 0 || _typeOf find "FlashDisk" >= 0): {
                    _displayName = "USB Flash Drive";
                };
                // Generators
                case (_typeOf find "Generator" >= 0 || _typeOf find "PowerGenerator" >= 0): {
                    _displayName = "Generator";
                };
                // Routers
                case (_typeOf find "Router" >= 0): {
                    _displayName = "Router";
                };
                // Lamps/Lights
                case (_typeOf find "Lamp" >= 0 || _typeOf find "Light" >= 0 || _typeOf find "Lantern" >= 0): {
                    _displayName = "Lamp";
                };
                // Solar Panels
                case (_typeOf find "Solar" >= 0): {
                    _displayName = "Solar Panel";
                };
                // Batteries
                case (_typeOf find "Battery" >= 0): {
                    _displayName = "Battery";
                };
                // Desks
                case (_typeOf find "Desk" >= 0 || _typeOf find "Table" >= 0): {
                    _displayName = "Desk";
                };
                // Default: use config display name
                default {
                    _displayName = getText (configOf _object >> "displayName");

                    // Final fallback
                    if (_displayName isEqualTo "") then {
                        _displayName = _typeOf;
                    };
                };
            };
        };

        // Create and add parent action
        private _parentAction = ["AE3_EquipmentAction", _displayName, "", {}, {true}] call ace_interact_menu_fnc_createAction;
        [_object, 0, ["ACE_MainActions"], _parentAction] call ace_interact_menu_fnc_addActionToObject;
        diag_log format ["[AE3 DEBUG] [%1] Parent action added successfully for %2", time, _object];

        // Flag was already set at the beginning of this block to prevent race conditions

        true
    } else {
        diag_log format ["[AE3 DEBUG] [%1] Parent action already exists for %2, skipping", time, _object];
        false
    };
};

["All", "InitPost", {_this call AE3_interaction_fnc_compileEquipment}] call CBA_fnc_addClassEventHandler;
