class OsFunction;

// DO NOT USE [] in Strings.

class CfgGames
{
	class snake : OsFunction
	{
		path = "/games/snake";
		description = "Retro Snake Game";
		man = "Retro Snake Game - use option --big for doubled block size";
		code = "_this call AE3_armaos_fnc_games_snake";
	};
};