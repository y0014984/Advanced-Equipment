class OsFunction;

// DO NOT USE [] in Strings.

class CfgHackingCommands
{
	class crack : OsFunction
	{
		path = "/bin/crack";
		description = "$STR_AE3_ArmaOS_Config_CommandCrackDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandCrackMan";
		code = "_this call AE3_armaos_fnc_os_crack";
	};
};