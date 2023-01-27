#include "script_component.hpp"

class CfgPatches
{
    class ADDON
	{
        name = QUOTE(COMPONENT);
        units[] = {"AE3_Filesystem"};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"A3_Modules_F", "cba_main", "ace_main", "acex_main", "ae3_main", "ae3_network", "ae3_filesystem", "ae3_interaction"};
        author = "y0014984|Wasserstoff";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgVehicles.hpp"
#include "Cfg3DEN.hpp"

#include "CfgOsFunctions.hpp"
#include "CfgSecurityCommands.hpp"

// Grid Macros and Styles
#include "defines.inc"

// Advanced Equipment 3 Dialog Definitions
#include "dialog.hpp"