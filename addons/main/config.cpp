#include "script_component.hpp"

class CfgPatches
{
    class ADDON
	{
        name = QUOTE(COMPONENT);
        units[] =
        {
                "AE3_AddConnection"
        };
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"A3_Modules_F", "cba_main", "ace_main", "acex_main"};
        author = "y0014984|Wasserstoff";
        //VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "cfgEditorCategories.hpp"
#include "CfgVehicles.hpp"
#include "Cfg3DEN.hpp"

// Grid Macros and Styles
#include "defines.inc"

// Advanced Equipment Zeus User Interface
#include "CfgUserInterfaceZeus.hpp"