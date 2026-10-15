
// DO NOT USE [] in Strings.

// Base class declared by ae3_armaos (CfgOsFunctions.hpp). Every entry below is the terminal front
// end of a networked game: the command only draws the board and reads moves, while the match itself
// lives on the server, so a terminal player and a desktop player can sit at the same table.
class OsFunction;

class CfgGames
{
	class chess : OsFunction
	{
		path = "/games/chess";
		description = "$STR_AE3_Games_Config_CommandChessDescr";
		man = "$STR_AE3_Games_Config_CommandChessMan";
		code = "call AE3_games_fnc_tui_chess";
		sshCompatible = 0; // interactive - cannot run over ssh
	};

	class checkers : OsFunction
	{
		path = "/games/checkers";
		description = "$STR_AE3_Games_Config_CommandCheckersDescr";
		man = "$STR_AE3_Games_Config_CommandCheckersMan";
		code = "call AE3_games_fnc_tui_checkers";
		sshCompatible = 0; // interactive - cannot run over ssh
	};

	class uno : OsFunction
	{
		path = "/games/uno";
		description = "$STR_AE3_Games_Config_CommandUnoDescr";
		man = "$STR_AE3_Games_Config_CommandUnoMan";
		code = "call AE3_games_fnc_tui_uno";
		sshCompatible = 0; // interactive - cannot run over ssh
	};

	class ludo : OsFunction
	{
		path = "/games/ludo";
		description = "$STR_AE3_Games_Config_CommandLudoDescr";
		man = "$STR_AE3_Games_Config_CommandLudoMan";
		code = "call AE3_games_fnc_tui_ludo";
		sshCompatible = 0; // interactive - cannot run over ssh
	};

	class snakesladders : OsFunction
	{
		path = "/games/snakesladders";
		description = "$STR_AE3_Games_Config_CommandSnakesLaddersDescr";
		man = "$STR_AE3_Games_Config_CommandSnakesLaddersMan";
		code = "call AE3_games_fnc_tui_snakesladders";
		sshCompatible = 0; // interactive - cannot run over ssh
	};

	class blackjack : OsFunction
	{
		path = "/games/blackjack";
		description = "$STR_AE3_Games_Config_CommandBlackjackDescr";
		man = "$STR_AE3_Games_Config_CommandBlackjackMan";
		code = "call AE3_games_fnc_tui_blackjack";
		sshCompatible = 0; // interactive - cannot run over ssh
	};

	class rps : OsFunction
	{
		path = "/games/rps";
		description = "$STR_AE3_Games_Config_CommandRpsDescr";
		man = "$STR_AE3_Games_Config_CommandRpsMan";
		code = "call AE3_games_fnc_tui_rps";
		sshCompatible = 0; // interactive - cannot run over ssh
	};

	class battleship : OsFunction
	{
		path = "/games/battleship";
		description = "$STR_AE3_Games_Config_CommandBattleshipDescr";
		man = "$STR_AE3_Games_Config_CommandBattleshipMan";
		code = "call AE3_games_fnc_tui_battleship";
		sshCompatible = 0; // interactive - cannot run over ssh
	};
};
