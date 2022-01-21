#include "script_component.hpp"

class CfgPatches
{
    class ADDON
	{
        name = QUOTE(COMPONENT);
        units[] = {"AE3_Filesystem"};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"A3_Modules_F", "cba_main", "ace_main", "acex_main", "ae3_main", "ae3_network", "ae3_filesystem"};
        author = "y0014984";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "Cfg3DEN.hpp"

// Grid Macros and Styles
#include "defines.inc"

// Advanced Equipment 3 Dialog Definitions
#include "dialog.hpp"