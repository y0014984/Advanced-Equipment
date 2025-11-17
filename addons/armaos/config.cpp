#include "script_component.hpp"

class CfgPatches
{
    class ADDON
	{
        name = QUOTE(COMPONENT);
        units[] =
            {
                "Land_Laptop_03_black_F_AE3",
                "Land_Laptop_03_olive_F_AE3",
                "Land_Laptop_03_sand_F_AE3",
                "AE3_AddUser",
                "AE3_AddSecurityCommands",
                "AE3_AddGames"
            };
        weapons[] = {"Item_Laptop_AE3"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"A3_Modules_F", "cba_main", "ace_main", "acex_main", "ae3_main", "ae3_network", "ae3_filesystem", "ae3_interaction"};
        author = "y0014984|Wasserstoff";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
#include "Cfg3DEN.hpp"

#include "CfgOsFunctions.hpp"
#include "CfgSecurityCommands.hpp"

#include "CfgGames.hpp"

#include "CfgSounds.hpp"

// Grid Macros and Styles
#include "defines.inc"

// Advanced Equipment Dialog Definitions
#include "dialog.hpp"
