class SecurityCommand
{
	path = "";
	description = "";
	man = "";
	code = "";
};

// DO NOT USE [] in Strings.

class CfgSecurityCommands
{
	class crypto : SecurityCommand
	{
		path = "/bin/crypto";
		description = "$STR_AE3_ArmaOS_Config_CommandCryptoDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandCryptoMan";
		code = "_this call AE3_armaos_fnc_os_crypto";
	};
};