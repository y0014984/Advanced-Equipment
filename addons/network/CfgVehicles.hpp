class CfgVehicles 
{
	// ROUTER
	class Land_Router_01_sand_F;
	class Land_Router_01_sand_F_AE3: Land_Router_01_sand_F
	{
        // Carrying
        ace_dragging_canCarry = 1;  // Can be carried (0-no, 1-yes)
        ace_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
        ace_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)

		// Cargo
        ace_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
        ace_cargo_size = 1;  // Cargo space the object takes

		// Event Handlers
		class EventHandlers
		{
			init = "params ['_entity']; call compile preprocessFileLineNumbers '\z\ae3\addons\main\init\initRouter.sqf';";
		};


		ae3_power_hasBattery = 0;
		ae3_power_powerConsumptionOn = 5;

		ae3_network_internet_ipaddress = "42.24.11.78";
		ae3_network_local_ipaddress = "10.42.42.1";
		ae3_network_local_subnetmask = "255.255.255.0";
		ae3_network_local_dhcpBase = "10.42.42.";
		ae3_network_local_dhcpStart = 100;
		ae3_network_local_dhcpCount = 50;

        class ACE_Actions 
		{
			class ACE_MainActions
			{
				displayName = "Interaktionen";
				condition = "true";
				distance = 2;
				class AE3_Router_Group
				{
					displayName = "Router";
					condition = "true";
					class AE3_ConnectToGenerator
					{
						displayName = "Connect To Generator";
						condition = "(alive _target) and (count (nearestObjects [_target, ['Land_PortableGenerator_01_sand_F_AE3'], 10]) > 0) and (_target getVariable 'AE3_powerConsumptionState' == 0)";
						statement = "";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						insertChildren = "params ['_target', '_player', '_params']; _generators = nearestObjects [_target, ['Land_PortableGenerator_01_sand_F_AE3'], 10]; private _actions = []; { private _childStatement = { params ['_target', '_player', '_generator']; _handle = [_target, _generator] spawn AE3_power_fnc_connectToGeneratorAction; }; private _action = [typeOf _x, typeOf _x, '', _childStatement, {true}, {}, _x] call ace_interact_menu_fnc_createAction; _actions pushBack [_action, [], _target]; } forEach (_generators); _actions";
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
					class AE3_DisconnectFromGenerator
					{
						displayName = "Disconnect From Generator";
						condition = "(alive _target) and (_target getVariable 'AE3_powerConsumptionState' == 1)";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_power_fnc_disconnectFromGeneratorAction;";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						//insertChildren
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
					class AE3_PowerState
					{
						displayName = "Check Power State";
						condition = "alive _target";
						statement = "params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_power_fnc_getPowerStateAction;";
						//icon = "\z\dance.paa";
						exceptions[] = {};
						//insertChildren
						//modifierFunction
						//runOnHover
						//distance
						//position
						//selection
						priority = -1;
						showDisabled = 0;
					};
				};
			};
		};
	};

};