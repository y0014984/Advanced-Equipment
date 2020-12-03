#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "ace_common"};
        author = "y0014984";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgEquipment.hpp"
#include "CfgFunctions.hpp"


#include "defines.hpp"
#include "dialog.hpp"