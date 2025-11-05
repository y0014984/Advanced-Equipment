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
		code = "call AE3_armaos_fnc_os_man";
	};

	class help : OsFunction
	{
		path = "/bin/help";
		description = "$STR_AE3_ArmaOS_Config_CommandHelpDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandHelpMan";
		code = "call AE3_armaos_fnc_os_help";
	};

	class ls : OsFunction
	{
		path = "/bin/ls";
		description = "$STR_AE3_ArmaOS_Config_CommandLsDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandLsMan";
		code = "call AE3_armaos_fnc_os_ls";
	};

	class cd : OsFunction
	{
		path = "/bin/cd";
		description = "$STR_AE3_ArmaOS_Config_CommandCdDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandCdMan";
		code = "call AE3_armaos_fnc_os_cd";
	};

	class cat : OsFunction
	{
		path = "/bin/cat";
		description = "$STR_AE3_ArmaOS_Config_CommandCatDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandCatMan";
		code = "call AE3_armaos_fnc_os_cat";
	};

	class date : OsFunction
	{
		path = "/bin/date";
		description = "$STR_AE3_ArmaOS_Config_CommandDateDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandDateMan";
		code = "call AE3_armaos_fnc_os_date";
	};

	class history : OsFunction
	{
		path = "/bin/history";
		description = "$STR_AE3_ArmaOS_Config_CommandHistoryDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandHistoryMan";
		code = "call AE3_armaos_fnc_os_history";
	};

	class clear : OsFunction
	{
		path = "/bin/clear";
		description = "$STR_AE3_ArmaOS_Config_CommandClearDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandClearMan";
		code = "call AE3_armaos_fnc_os_clear";
	};

	class rm : OsFunction
	{
		path = "/bin/rm";
		description = "$STR_AE3_ArmaOS_Config_CommandRmDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandRmMan";
		code = "call AE3_armaos_fnc_os_rm";
	};

	class mv : OsFunction
	{
		path = "/bin/mv";
		description = "$STR_AE3_ArmaOS_Config_CommandMvDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandMvMan";
		code = "call AE3_armaos_fnc_os_mv";
	};

	class cp : OsFunction
	{
		path = "/bin/cp";
		description = "$STR_AE3_ArmaOS_Config_CommandCpDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandCpMan";
		code = "call AE3_armaos_fnc_os_cp";
	};

	class whoami : OsFunction
	{
		path = "/bin/whoami";
		description = "$STR_AE3_ArmaOS_Config_CommandWhoamiDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandWhoamiMan";
		code = "call AE3_armaos_fnc_os_whoami";
	};

	class mkdir : OsFunction
	{
		path = "/bin/mkdir";
		description = "$STR_AE3_ArmaOS_Config_CommandMkdirDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandMkdirMan";
		code = "call AE3_armaos_fnc_os_mkdir";
	};

	class ping : OsFunction
	{
		path = "/sbin/ping";
		description = "$STR_AE3_ArmaOS_Config_CommandPingDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandPingMan";
		code = "call AE3_armaos_fnc_os_ping";
	};

	class ipconfig : OsFunction
	{
		path = "/sbin/ipconfig";
		description = "$STR_AE3_ArmaOS_Config_CommandIpconfigDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandIpconfigMan";
		code = "call AE3_armaos_fnc_os_ipconfig";
	};

	class exit : OsFunction
	{
		path = "/sbin/exit";
		description = "$STR_AE3_ArmaOS_Config_CommandExitDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandExitMan";
		code = "call AE3_armaos_fnc_os_exit";
	};

	class shutdown : OsFunction
	{
		path = "/sbin/shutdown";
		description = "$STR_AE3_ArmaOS_Config_CommandShutdownDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandShutdownMan";
		code = "call AE3_armaos_fnc_os_shutdown";
	};

	class standby : OsFunction
	{
		path = "/sbin/standby";
		description = "$STR_AE3_ArmaOS_Config_CommandStandbyDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandStandbyMan";
		code = "call AE3_armaos_fnc_os_standby";
	};

	class echo : OsFunction
	{
		path = "/bin/echo";
		description = "$STR_AE3_ArmaOS_Config_CommandEchoDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandEchoMan";
		code = "call AE3_armaos_fnc_os_echo";
	};

	class find : OsFunction
	{
		path = "/bin/find";
		description = "$STR_AE3_ArmaOS_Config_CommandFindDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandFindMan";
		code = "call AE3_armaos_fnc_os_find";
	};
	class mount : OsFunction
	{
		path = "/bin/mount";
		description = "$STR_AE3_ArmaOS_Config_CommandMountDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandMountMan";
		code = "call AE3_armaos_fnc_os_mount";
	};
	class umount : OsFunction
	{
		path = "/bin/umount";
		description = "$STR_AE3_ArmaOS_Config_CommandUmountDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandUmountMan";
		code = "call AE3_armaos_fnc_os_unmount";
	};
	class lsusb : OsFunction
	{
		path = "/bin/lsusb";
		description = "$STR_AE3_ArmaOS_Config_CommandLsusbDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandLsusbMan";
		code = "call AE3_armaos_fnc_os_lsusb";
	};
	class chown : OsFunction
	{
		path = "/bin/chown";
		description = "$STR_AE3_ArmaOS_Config_CommandChownDescr";
		man = "$STR_AE3_ArmaOS_Config_CommandChownMan";
		code = "call AE3_armaos_fnc_os_chown";
	};
};
