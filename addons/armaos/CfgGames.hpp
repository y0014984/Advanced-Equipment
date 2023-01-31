class OsFunction;

// DO NOT USE [] in Strings.

class CfgGames
{
	class snake : OsFunction
	{
		path = "/games/snake";
		description = "$STR_AE3_ArmaOS_Config_CommandSnakeDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandSnakeMan";
		code = "_this call AE3_armaos_fnc_games_snake";
	};
};