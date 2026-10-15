// One checkbox per game on the Add Games module: ticked keeps the game, unticked takes it away. The
// property name is read back off the module logic by AE3_games_fnc_module_addGames.
#define AE3_ADDGAMES_CHECKBOX(NAME,LABEL,TIP) \
	class AE3_AddGames_##NAME: Checkbox \
	{ \
		property = QUOTE(AE3_AddGames_##NAME); \
		displayName = LABEL; \
		tooltip = TIP; \
		typeName = "BOOL"; \
		defaultValue = "true"; \
		condition = "1"; \
	}

// One games setting per combo on the Games module. A combo rather than a checkbox so a setting can be
// left to the mission; the property name is read back off the module logic by AE3_games_fnc_module_games.
#define AE3_GAMESETTING_COMBO(NAME,LABEL,TIP) \
	class AE3_Module_Games_##NAME: Combo \
	{ \
		property = QUOTE(AE3_Module_Games_##NAME); \
		displayName = LABEL; \
		tooltip = TIP; \
		typeName = "STRING"; \
		defaultValue = """default"""; \
		condition = "1"; \
		class Values \
		{ \
			class NAME##Default { name = "$STR_AE3_Games_EdenAttributes_UseSetting"; value = "default"; }; \
			class NAME##Yes { name = "$STR_AE3_Games_EdenAttributes_Yes"; value = "yes"; }; \
			class NAME##No { name = "$STR_AE3_Games_EdenAttributes_No"; value = "no"; }; \
		}; \
	}

class CfgVehicles
{
	// Declared externally: both come from the base game
	class Module_F;
	class AttributesBase;

	/* ================================================================================ */

	// MODULE ADD GAMES (EDEN + ZEUS)
	// Decides which games the synced computers keep, out of the full set they start with.
	class AE3_AddGames: Module_F
	{
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.
		displayName = "$STR_AE3_Games_Config_ModuleAddGamesDisplayName";
		icon = "\z\ae3\addons\armaos\ui\AE3_Module_Icons_addUser.paa"; // Shared AE3 module icon
		category = "AE3_armaosModules";

		// Name of function triggered once conditions are met
		function = "AE3_games_fnc_module_addGames";
		functionPriority = 1;
		// 1 for global execution, so a curator-placed module also reaches the curator's own machine
		isGlobal = 1;
		// 1 for module waiting until all synced triggers are activated
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		class Attributes: AttributesBase
		{
			// Declared externally: the attribute control base classes come from AttributesBase
			class Checkbox;

			AE3_ADDGAMES_CHECKBOX(Snake,"$STR_AE3_Games_Config_AddGamesSnake","$STR_AE3_Games_Config_AddGamesSnakeTooltip");
			AE3_ADDGAMES_CHECKBOX(Chess,"$STR_AE3_Games_Title_Chess","$STR_AE3_Games_Config_AddGamesNetworkedTooltip");
			AE3_ADDGAMES_CHECKBOX(Checkers,"$STR_AE3_Games_Title_Checkers","$STR_AE3_Games_Config_AddGamesNetworkedTooltip");
			AE3_ADDGAMES_CHECKBOX(Uno,"$STR_AE3_Games_Title_Uno","$STR_AE3_Games_Config_AddGamesNetworkedTooltip");
			AE3_ADDGAMES_CHECKBOX(Ludo,"$STR_AE3_Games_Title_Ludo","$STR_AE3_Games_Config_AddGamesNetworkedTooltip");
			AE3_ADDGAMES_CHECKBOX(SnakesLadders,"$STR_AE3_Games_Title_SnakesLadders","$STR_AE3_Games_Config_AddGamesNetworkedTooltip");
			AE3_ADDGAMES_CHECKBOX(Blackjack,"$STR_AE3_Games_Title_Blackjack","$STR_AE3_Games_Config_AddGamesNetworkedTooltip");
			AE3_ADDGAMES_CHECKBOX(Rps,"$STR_AE3_Games_Title_Rps","$STR_AE3_Games_Config_AddGamesNetworkedTooltip");
			AE3_ADDGAMES_CHECKBOX(Battleship,"$STR_AE3_Games_Title_Battleship","$STR_AE3_Games_Config_AddGamesNetworkedTooltip");
		};
	};

	/* ================================================================================ */

	// MODULE GAMES (EDEN + ZEUS)
	// The games settings. In Eden it writes them onto every synced computer, or mission wide when
	// nothing is synced; in Zeus it opens the roster dialog. Mission setting writes nothing.
	class AE3_Module_Games: Module_F
	{
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.
		displayName = "$STR_AE3_Games_Config_ModuleGamesDisplayName";
		icon = "\z\ae3\addons\armaos\ui\AE3_Module_Icons_addUser.paa"; // Shared AE3 module icon
		category = "AE3_mainModules";

		// Name of function triggered once conditions are met
		function = "AE3_games_fnc_module_games";
		functionPriority = 1;
		// 1 for global execution, so the module logic reaches the curator's own machine where the
		// dialog has to open
		isGlobal = 1;
		// 1 for module waiting until all synced triggers are activated
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		class Attributes: AttributesBase
		{
			// Declared externally: the attribute control base classes come from AttributesBase
			class Combo;
			class Edit;

			AE3_GAMESETTING_COMBO(Enabled,"$STR_AE3_Games_EdenAttributes_EnabledDisplayName","$STR_AE3_Games_EdenAttributes_EnabledTooltip");
			AE3_GAMESETTING_COMBO(AllowHosting,"$STR_AE3_Games_EdenAttributes_AllowHostingDisplayName","$STR_AE3_Games_EdenAttributes_AllowHostingTooltip");
			AE3_GAMESETTING_COMBO(GraphicalUI,"$STR_AE3_Games_EdenAttributes_GraphicalUIDisplayName","$STR_AE3_Games_EdenAttributes_GraphicalUITooltip");
			AE3_GAMESETTING_COMBO(DebugSeats,"$STR_AE3_Games_EdenAttributes_DebugSeatsDisplayName","$STR_AE3_Games_EdenAttributes_DebugSeatsTooltip");

			// Drain while a game is open, in watt hours a second. Empty keeps the mission setting.
			class AE3_Module_Games_PowerDraw: Edit
			{
				property = "AE3_Module_Games_PowerDraw";
				displayName = "$STR_AE3_Games_EdenAttributes_PowerDrawDisplayName";
				tooltip = "$STR_AE3_Games_EdenAttributes_PowerDrawTooltip";
				typeName = "STRING";
				defaultValue = """""";
				condition = "1";
			};
		};
	};
};
