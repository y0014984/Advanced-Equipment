#include "script_component.hpp"

class CfgPatches
{
    class ADDON
	{
        name = QUOTE(COMPONENT);
        units[] = { "AE3_AddFile", "AE3_AddDir" };
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"A3_Modules_F", "cba_main", "ace_main", "acex_main", "ae3_main"};
        author = "y0014984|Wasserstoff";
        //VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "Cfg3DEN.hpp"

#include "CfgFilesystemObjects.hpp"