class OsFunction;

// DO NOT USE [] in Strings.

class CfgSecurityCommands
{
	class crypto : OsFunction
	{
		path = "/bin/crypto";
		description = "$STR_AE3_ArmaOS_Config_CommandCryptoDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandCryptoMan";
		code = "_this call AE3_armaos_fnc_os_crypto";
	};
};