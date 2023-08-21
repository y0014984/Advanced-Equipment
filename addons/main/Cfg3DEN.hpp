class Cfg3DEN
{
	/* ================================================================================ */

	class Connections
	{

		// "marker" = Marker
		// "group"
		// "trigger"
		// "waypoint"
		// "logic"
		// "layer"
		// "comment"
		// "object" = all objects, inkl. characters, vehicles and props
		// "objectVehicle" = all vehicles
		// "objectAI" = ???
		// "objectBrain" = characters
		// "objectEmpty" = ???
		// "objectAgent"
		// "objectProps"? does that exist?
		// "" everything but "layer" and "comment"

		class AE3_PowerConnection
		{
			displayName = "AE3: connect device to power source"; // The name that appears in Eden Editor Connect Context Menu
			condition1 = "object"; // condition for the connection menu item to appear
			condition2 = "object"; // condition for the allowed connection; otherwise disconnects
			//property = "AE3_CustomConnection"; // seems not to be necessary
			data = "AE3_PowerConnection"; // _type parameter in "OnConnectionStart/End" Event Handlers
			color[] = {0.835,0.345,0.345,1}; // Color of connection line
			cursor = "3DENConnectSync"; // cursor type; don't know what is available
			expression = "[_entity0, _entity1] call AE3_power_fnc_registerPowerConnection;"; // seems to be executed on mission start
		};

		class AE3_NetworkConnection
		{
			displayName = "AE3: connect device to network router"; // The name that appears in Eden Editor Connect Context Menu
			condition1 = "object"; // condition for the connection menu item to appear
			condition2 = "object"; // condition for the allowed connection; otherwise disconnects
			//property = "AE3_CustomConnection"; // seems not to be necessary
			data = "AE3_NetworkConnection"; // _type parameter in "OnConnectionStart/End" Event Handlers
			color[] = {0.357,0.666,0.671,1}; // Color of connection line
			cursor = "3DENConnectSync"; // cursor type; don't know what is available
			expression = "[_entity0, _entity1] call AE3_network_fnc_createNetworkConnection;"; // seems to be executed on mission start
		};
	};

	/* ================================================================================ */

    class EventHandlers
    {
        class AE3_EventHandlers
        {
            OnConnectionStart = "_this call AE3_main_fnc_3denEventHandlers_onConnectionStart;";
            OnConnectingEnd = "_this call AE3_main_fnc_3denEventHandlers_onConnectionEnd;";
        };
    };

	/* ================================================================================ */
};