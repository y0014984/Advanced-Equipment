#include "script_component.hpp"

class CfgPatches
{
    class ADDON
	{
        name = QUOTE(COMPONENT);
        units[] = 
            {
                "Land_PortableGenerator_01_F_AE3",
                "Land_PortableGenerator_01_black_F_AE3",
                "Land_PortableGenerator_01_sand_F_AE3",
                "Land_MobileRadar_01_generator_F_AE3",
                "Land_DieselGroundPowerUnit_01_F_AE3",
                "Land_PowerGenerator_F_AE3",
                "Land_Portable_generator_F_AE3",
                "Land_BatteryPack_01_open_olive_F_AE3",
                "Land_BatteryPack_01_open_black_F_AE3",
                "Land_BatteryPack_01_open_sand_F_AE3",
                "Land_SolarPanel_04_olive_F_AE3",
                "Land_SolarPanel_04_black_F_AE3",
                "Land_SolarPanel_04_sand_F_AE3",
                "Land_PortableSolarPanel_01_olive_F_AE3",
                "Land_PortableSolarPanel_01_sand_F_AE3"
            };
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"A3_Modules_F", "cba_main", "ace_main", "acex_main", "ae3_main"};
        author = "y0014984|Wasserstoff";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "Cfg3DEN.hpp"
