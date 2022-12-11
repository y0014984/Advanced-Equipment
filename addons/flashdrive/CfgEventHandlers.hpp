class Extended_PreInit_EventHandlers
{
	class ADDON
	{
        // Like the normal preinit above, this one runs on all machines
        init = call compile preprocessFileLineNumbers "\z\ae3\addons\filesystem\XEH_preInit.sqf";

        // This code will be executed once and only on the server
        serverInit = "";

        // This snippet runs once and only on client machines
        clientInit = "";
	};
};

class Extended_PostInit_EventHandlers
{
	class ADDON
	{
        // Like the normal preinit above, this one runs on all machines
        init = "";
		
        // This code will be executed once and only on the server
        serverInit = "";

        // This snippet runs once and only on client machines
        clientInit = "";
	};
};

class Extended_PreStart_EventHandlers
{
	class ADDON
	{
        // Like the normal preinit above, this one runs on all machines
        init = "";
		
        // This code will be executed once and only on the server
        serverInit = "";

        // This snippet runs once and only on client machines
        clientInit = "";
	};
};
