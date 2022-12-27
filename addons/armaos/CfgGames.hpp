class Game
{
	path = "";
	description = "";
	man = "";
	code = "";
};

// DO NOT USE [] in Strings.

class CfgGames
{
	class snake : Game
	{
		path = "/games/snake";
		description = "Retro Snake Game";
		man = "Retro Snake Game - use option --big for doubled block size";
		code = "_this call AE3_armaos_fnc_games_snake";
	};
};