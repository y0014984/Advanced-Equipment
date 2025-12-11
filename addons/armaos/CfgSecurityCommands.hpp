
// DO NOT USE [] in Strings.

class CfgSecurityCommands
{
	class crypto : OsFunction
	{
		path = "/bin/crypto";
		description = "$STR_AE3_ArmaOS_Config_CommandCryptoDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandCryptoMan";
		code = "call AE3_armaos_fnc_os_crypto";
	};

	class crack : OsFunction
	{
		path = "/bin/crack";
		description = "$STR_AE3_ArmaOS_Config_CommandCrackDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandCrackMan";
		code = "call AE3_armaos_fnc_os_crack";
	};
};
