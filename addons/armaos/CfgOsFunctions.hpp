class OsFunction
{
	path = "";
	description = "";
	man = "";
	code = "";
};

// DO NOT USE [] in Strings.

class CfgOsFunctions
{
	class man : OsFunction
	{
		path = "/bin/man";
		description = "$STR_AE3_ArmaOS_Config_CommandManDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandManMan";
		code = "_this call AE3_armaos_fnc_os_man";
	};

	class help : OsFunction
	{
		path = "/bin/help";
		description = "$STR_AE3_ArmaOS_Config_CommandHelpDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandHelpMan";
		code = "_this call AE3_armaos_fnc_os_help";
	};

	class ls : OsFunction
	{
		path = "/bin/ls";
		description = "$STR_AE3_ArmaOS_Config_CommandLsDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandLsMan";
		code = "_this call AE3_armaos_fnc_os_ls";
	};

	class cd : OsFunction
	{
		path = "/bin/cd";
		description = "$STR_AE3_ArmaOS_Config_CommandCdDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandCdMan";
		code = "_this call AE3_armaos_fnc_os_cd";
	};

	class cat : OsFunction
	{
		path = "/bin/cat";
		description = "$STR_AE3_ArmaOS_Config_CommandCatDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandCatMan";
		code = "_this call AE3_armaos_fnc_os_cat";
	};

	class date : OsFunction
	{
		path = "/bin/date";
		description = "$STR_AE3_ArmaOS_Config_CommandDateDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandDateMan";
		code = "_this call AE3_armaos_fnc_os_date";
	};

	class history : OsFunction
	{
		path = "/bin/history";
		description = "$STR_AE3_ArmaOS_Config_CommandHistoryDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandHistoryMan";
		code = "_this call AE3_armaos_fnc_os_history";
	};

	class clear : OsFunction
	{
		path = "/bin/clear";
		description = "$STR_AE3_ArmaOS_Config_CommandClearDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandClearMan";
		code = "_this call AE3_armaos_fnc_os_clear";
	};

	class rm : OsFunction
	{
		path = "/bin/rm";
		description = "$STR_AE3_ArmaOS_Config_CommandRmDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandRmMan";
		code = "_this call AE3_armaos_fnc_os_rm";
	};

	class mv : OsFunction
	{
		path = "/bin/mv";
		description = "$STR_AE3_ArmaOS_Config_CommandMvDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandMvMan";
		code = "_this call AE3_armaos_fnc_os_mv";
	};

	class whoami : OsFunction
	{
		path = "/bin/whoami";
		description = "$STR_AE3_ArmaOS_Config_CommandWhoamiDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandWhoamiMan";
		code = "_this call AE3_armaos_fnc_os_whoami";
	};

	class mkdir : OsFunction
	{
		path = "/bin/mkdir";
		description = "$STR_AE3_ArmaOS_Config_CommandMkdirDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandMkdirMan";
		code = "_this call AE3_armaos_fnc_os_mkdir";
	};

	class ping : OsFunction
	{
		path = "/sbin/ping";
		description = "$STR_AE3_ArmaOS_Config_CommandPingDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandPingMan";
		code = "_this call AE3_armaos_fnc_os_ping";
	};

	class ipconfig : OsFunction
	{
		path = "/sbin/ipconfig";
		description = "$STR_AE3_ArmaOS_Config_CommandIpconfigDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandIpconfigMan";
		code = "_this call AE3_armaos_fnc_os_ipconfig";
	};

	class exit : OsFunction
	{
		path = "/sbin/exit";
		description = "$STR_AE3_ArmaOS_Config_CommandExitDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandExitMan";
		code = "_this call AE3_armaos_fnc_os_exit";
	};

	class shutdown : OsFunction
	{
		path = "/sbin/shutdown";
		description = "$STR_AE3_ArmaOS_Config_CommandShutdownDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandShutdownMan";
		code = "_this call AE3_armaos_fnc_os_shutdown";
	};

	class standby : OsFunction
	{
		path = "/sbin/standby";
		description = "$STR_AE3_ArmaOS_Config_CommandStandbyDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandStandbyMan";
		code = "_this call AE3_armaos_fnc_os_standby";
	};

	class echo : OsFunction
	{
		path = "/bin/echo";
		description = "$STR_AE3_ArmaOS_Config_CommandEchoDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandEchoMan";
		code = "_this call AE3_armaos_fnc_os_echo";
	};

	class crypto : OsFunction
	{
		path = "/bin/crypto";
		description = "$STR_AE3_ArmaOS_Config_CommandCryptoDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandCryptoMan";
		code = "_this call AE3_armaos_fnc_os_crypto";
	};
	class crack : OsFunction
	{
		path = "/bin/crack";
		description = "$STR_AE3_ArmaOS_Config_CommandCrackDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandCrackMan";
		code = "_this call AE3_armaos_fnc_os_crack";
	};
	class find : OsFunction
	{
		path = "/bin/find";
		description = "$STR_AE3_ArmaOS_Config_CommandFindDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandFindMan";
		code = "_this call AE3_armaos_fnc_os_find";
	};
	class mount : OsFunction
	{
		path = "/bin/mount";
		description = "$STR_AE3_ArmaOS_Config_CommandFindDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandFindMan";
		code = "_this call AE3_armaos_fnc_os_mount";
	};
	class unmount : OsFunction
	{
		path = "/bin/unmount";
		description = "$STR_AE3_ArmaOS_Config_CommandFindDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandFindMan";
		code = "_this call AE3_armaos_fnc_os_unmount";
	};
};