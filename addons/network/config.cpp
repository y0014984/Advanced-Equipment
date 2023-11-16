#include "script_component.hpp"

class CfgPatches
{
    class ADDON
	{
        name = QUOTE(COMPONENT);
        units[] = 
        {
            "Land_Router_01_olive_F_AE3",
            "Land_Router_01_black_F_AE3",
            "Land_Router_01_sand_F_AE3"
        };
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