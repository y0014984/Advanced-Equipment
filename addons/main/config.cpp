#include "script_component.hpp"

class CfgPatches
{
    class ADDON
	{
        name = QUOTE(COMPONENT);
        units[] = {"AE3_Filesystem"};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "ace_main", "acex_main"};
        author = "y0014984";
        VERSION_CONFIG;
    };
};

#include "defines.hpp"
#include "dialog.hpp"

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "CfgFunctions.hpp"
#include "Cfg3DEN.hpp"