class CfgSounds
{
	sounds[] = {};
	class SplashScreen
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "SplashScreen";

		// filename, volume, pitch, distance (optional)
		sound[] = { "\z\ae3\addons\armaos\sounds\SplashScreen.ogg", 1, 1, 100 };

		// subtitle delay in seconds, subtitle text
		titles[] = {};
	};
	class Blip
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Blip";

		// filename, volume, pitch, distance (optional)
		sound[] = { "\z\ae3\addons\armaos\sounds\Blip.ogg", 1, 1, 100 };

		// subtitle delay in seconds, subtitle text
		titles[] = {};
	};
	class GameOver
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "GameOver";

		// filename, volume, pitch, distance (optional)
		sound[] = { "\z\ae3\addons\armaos\sounds\GameOver.ogg", 1, 1, 100 };

		// subtitle delay in seconds, subtitle text
		titles[] = {};
	};
};