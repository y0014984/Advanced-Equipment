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
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"A3_Modules_F", "cba_main", "ace_main", "acex_main", "ae3_main", "ae3_network", "ae3_filesystem", "ae3_interaction"};
        author = "y0014984|Wasserstoff";
        VERSION_CONFIG;
    };
};

class CfgFontFamilies
{
    class UbuntuMono
    {
        fonts[] =
            {
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono6",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono7",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono8",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono9",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono10",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono11",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono12",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono13",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono14",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono15",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono16",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono17",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono18",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono19",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono20",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono21",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono22",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono23",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono24",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono25",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono26",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono27",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono28",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono29",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono30",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono31",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono34",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono35",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono37",
                "\z\ae3\addons\armaos\fonts\UbuntuMono\UbuntuMono46"
            };
        spaceWidth = 0.7;
        spacing = 0.13;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "Cfg3DEN.hpp"

#include "CfgOsFunctions.hpp"
#include "CfgSecurityCommands.hpp"

#include "CfgGames.hpp"

#include "CfgSounds.hpp"

// Grid Macros and Styles
#include "defines.inc"

// Advanced Equipment Dialog Definitions
#include "dialog.hpp"