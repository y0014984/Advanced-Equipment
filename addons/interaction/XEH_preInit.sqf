#include "script_component.hpp"
#include "XEH_PREP.hpp"

// Helper function to ensure equipment parent action exists on an object
// Returns true if parent was added, false if it already existed
AE3_interaction_fnc_ensureEquipmentParent = {
    params ["_object", ["_displayName", ""]];

    // Check if parent already exists by checking the flag
    private _hasParent = _object getVariable ["AE3_interaction_hasEquipmentAction", false];

    if (!_hasParent) then {
        // If no display name provided, get it from the object's config
        if (_displayName isEqualTo "") then {
            _displayName = getText (configOf _object >> "displayName");

            // Fallback if no display name in config
            if (_displayName isEqualTo "") then {
                _displayName = typeOf _object;
            };
        };

        // Create and add parent action
        private _parentAction = ["AE3_EquipmentAction", _displayName, "", {}, {true}] call ace_interact_menu_fnc_createAction;
        [_object, 0, ["ACE_MainActions"], _parentAction] call ace_interact_menu_fnc_addActionToObject;

        // Set flag so other systems know it exists
        _object setVariable ["AE3_interaction_hasEquipmentAction", true];

        true
    } else {
        false
    };
};

["All", "InitPost", {_this call AE3_interaction_fnc_compileEquipment}] call CBA_fnc_addClassEventHandler;
