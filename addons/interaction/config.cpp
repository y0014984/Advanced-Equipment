#include "script_component.hpp"

class CfgPatches
{
    class ADDON
	{
        name = QUOTE(COMPONENT);
        units[] = 
        {
            "Land_PortableLight_single_F_AE3",
            "Land_PortableLight_double_F_AE3",
            "Land_PortableLight_02_single_yellow_F_AE3",
            "Land_PortableLight_02_single_olive_F_AE3",
            "Land_PortableLight_02_single_black_F_AE3",
            "Land_PortableLight_02_single_sand_F_AE3",
            "Land_PortableLight_02_double_yellow_F_AE3",
            "Land_PortableLight_02_double_olive_F_AE3",
            "Land_PortableLight_02_double_black_F_AE3",
            "Land_PortableLight_02_double_sand_F_AE3",
            "Land_PortableLight_02_quad_yellow_F_AE3",
            "Land_PortableLight_02_quad_olive_F_AE3",
            "Land_PortableLight_02_quad_black_F_AE3",
            "Land_PortableLight_02_quad_sand_F_AE3",
            "Land_PortableDesk_01_olive_F_AE3",
            "Land_PortableDesk_01_black_F_AE3",
            "Land_PortableDesk_01_sand_F_AE3",
            "Land_DeskChair_01_olive_F_AE3",
            "Land_DeskChair_01_black_F_AE3",
            "Land_DeskChair_01_sand_F_AE3"
        };
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"A3_Modules_F", "cba_main", "ace_main", "acex_main", "ae3_main", "ae3_power"};
        author = "y0014984|Wasserstoff";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "Cfg3DEN.hpp"
