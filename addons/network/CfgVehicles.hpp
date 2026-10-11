// Router wireless configuration exposed as 3DEN object attributes (replacing the old Configure
// Router module). Applied at mission start via AE3_network_fnc_attr_router. A blank Network Name or
// Gateway keeps the auto-assigned value, so each placed router still gets its own incrementing
// subnet unless explicitly overridden. Shared by every router variant.
#define AE3_ROUTER_CONFIG_ATTRIBUTES \
	class Attributes \
	{ \
		class AE3_RouterSsid \
		{ \
			displayName = "Network Name (SSID)"; \
			tooltip = "Wireless network name. Leave blank to keep the default object name."; \
			property = "AE3_RouterSsid"; \
			control = "Edit"; \
			expression = "[_this, 'ssid', _value] call AE3_network_fnc_attr_router;"; \
			defaultValue = """"""; \
			typeName = "STRING"; \
			condition = "1"; \
		}; \
		class AE3_RouterGateway \
		{ \
			displayName = "Default Gateway"; \
			tooltip = "Default gateway, e.g. 192.168.0.1. Leave blank to keep the auto-assigned subnet."; \
			property = "AE3_RouterGateway"; \
			control = "Edit"; \
			expression = "[_this, 'gateway', _value] call AE3_network_fnc_attr_router;"; \
			defaultValue = """"""; \
			typeName = "STRING"; \
			condition = "1"; \
		}; \
		class AE3_RouterRange \
		{ \
			displayName = "Wifi Range (m)"; \
			tooltip = "Maximum distance (m) at which laptops can connect to this router."; \
			property = "AE3_RouterRange"; \
			control = "Edit"; \
			expression = "[_this, 'range', _value] call AE3_network_fnc_attr_router;"; \
			defaultValue = "100"; \
			typeName = "NUMBER"; \
			condition = "1"; \
		}; \
		class AE3_RouterPassword \
		{ \
			displayName = "Network Password"; \
			tooltip = "Password required to connect. Leave blank for an open network."; \
			property = "AE3_RouterPassword"; \
			control = "Edit"; \
			expression = "[_this, 'password', _value] call AE3_network_fnc_attr_router;"; \
			defaultValue = """"""; \
			typeName = "STRING"; \
			condition = "1"; \
		}; \
		class AE3_EdenAttribute_PowerLevel \
		{ \
			displayName = "$STR_AE3_Main_EdenAttributes_PowerLevelDisplayName"; \
			tooltip = "$STR_AE3_Main_EdenAttributes_PowerLevelTooltip"; \
			property = "AE3_EdenAttribute_PowerLevel"; \
			control = "Slider"; \
			expression = "_this setVariable ['%s', _value, true];"; \
			defaultValue = "1"; \
			validate = "number"; \
			typeName = "NUMBER"; \
			condition = "1"; \
		}; \
		class AE3_RouterStartOn \
		{ \
			displayName = "Powered On At Start"; \
			tooltip = "Switch the router on automatically when the mission starts."; \
			property = "AE3_RouterStartOn"; \
			control = "Checkbox"; \
			expression = "[_this, 'starton', _value] call AE3_network_fnc_attr_router;"; \
			defaultValue = "false"; \
			typeName = "BOOL"; \
			condition = "1"; \
		}; \
		class AE3_RouterAllowExternalSsh \
		{ \
			displayName = "Allow External SSH"; \
			tooltip = "Allow laptops on other gateways to ping/SSH devices on this router. Leave the allowed ips blank to permit any ip."; \
			property = "AE3_RouterAllowExternalSsh"; \
			control = "Checkbox"; \
			expression = "[_this, 'extssh', _value] call AE3_network_fnc_attr_router;"; \
			defaultValue = "false"; \
			typeName = "BOOL"; \
			condition = "1"; \
		}; \
		class AE3_RouterTransferSpeed 		{ 			displayName = "$STR_AE3_Network_TransferSpeed_Speed"; 			tooltip = "$STR_AE3_Network_TransferSpeed_AttributeTooltip"; 			property = "AE3_RouterTransferSpeed"; 			control = "Edit"; 			expression = "if (isServer && {_value > 0}) then { [_this, round _value] call AE3_network_fnc_setTransferSpeed; };"; 			defaultValue = "0"; 			typeName = "NUMBER"; 			validate = "number"; 			condition = "1"; 		}; 		class AE3_RouterExternalAllow \
		{ \
			displayName = "External Allowed IPs"; \
			tooltip = "Optional comma/space separated regex patterns of source gateways allowed external access. Blank means any gateway."; \
			property = "AE3_RouterExternalAllow"; \
			control = "Edit"; \
			expression = "[_this, 'extallow', _value] call AE3_network_fnc_attr_router;"; \
			defaultValue = """"""; \
			typeName = "STRING"; \
			condition = "1"; \
		}; \
	};

class CfgVehicles
{
	/* ================================================================================ */

	// RUGGED ROUTER OLIVE
	class Land_Router_01_olive_F;
	class Land_Router_01_olive_F_AE3: Land_Router_01_olive_F
	{
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Routers";

		curatorInfoTypeEmpty = "AE3_UserInterface_Zeus_Asset_Details";

		AE3_ROUTER_CONFIG_ATTRIBUTES

		class AE3_Device
		{
			displayName = "$STR_AE3_Network_Config_RouterDisplayName";
			init = "call AE3_network_fnc_initRouter;";

			defaultPowerLevel = 0;

			turnOnAction = "call AE3_network_fnc_dhcp_onTurnOn; true";
			turnOffAction = "call AE3_network_fnc_router_onTurnOff; true";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.01/3600; // consumes 10 Watts
			};
		};

		// Routers ship with a built-in 100 Wh battery so they run without an external supply.
		class AE3_InternalDevice
		{
			displayName = "$STR_AE3_Power_Config_BatteryDisplayName";
			defaultPowerLevel = 1;

			turnOnAction = "_this + [true] call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "";

			class AE3_PowerInterface
			{
				internal = 1;
			};

			class AE3_Battery
			{
				capacity = 0.1; // 100 Watt-hours max. capacity
				recharging = 0.05/3600; // 50 Watts power consumption while recharging
				level = 0.1; // start fully charged
				internal = 1;
			};
		};

		class AE3_Equipment
		{
			class AE3_ace3Interactions
			{
				class AE3_aceCarrying
				{
					// Carrying
					ae3_dragging_canCarry = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 1;  // Cargo space the object takes
				};
			};
		};
	};

	/* ================================================================================ */

	// RUGGED ROUTER BLACK
	class Land_Router_01_black_F;
	class Land_Router_01_black_F_AE3: Land_Router_01_black_F
	{
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Routers";

		curatorInfoTypeEmpty = "AE3_UserInterface_Zeus_Asset_Details";

		AE3_ROUTER_CONFIG_ATTRIBUTES

		class AE3_Device
		{
			displayName = "$STR_AE3_Network_Config_RouterDisplayName";
			init = "call AE3_network_fnc_initRouter;";

			defaultPowerLevel = 0;

			turnOnAction = "call AE3_network_fnc_dhcp_onTurnOn; true";
			turnOffAction = "call AE3_network_fnc_router_onTurnOff; true";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.01/3600; // consumes 10 Watts
			};
		};

		// Routers ship with a built-in 100 Wh battery so they run without an external supply.
		class AE3_InternalDevice
		{
			displayName = "$STR_AE3_Power_Config_BatteryDisplayName";
			defaultPowerLevel = 1;

			turnOnAction = "_this + [true] call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "";

			class AE3_PowerInterface
			{
				internal = 1;
			};

			class AE3_Battery
			{
				capacity = 0.1; // 100 Watt-hours max. capacity
				recharging = 0.05/3600; // 50 Watts power consumption while recharging
				level = 0.1; // start fully charged
				internal = 1;
			};
		};

		class AE3_Equipment
		{
			class AE3_ace3Interactions
			{
				class AE3_aceCarrying
				{
					// Carrying
					ae3_dragging_canCarry = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 1;  // Cargo space the object takes
				};
			};
		};
	};

	/* ================================================================================ */

	// RUGGED ROUTER SAND
	class Land_Router_01_sand_F;
	class Land_Router_01_sand_F_AE3: Land_Router_01_sand_F
	{
		scopeCurator = 2; // Zeus visability; 2 will show it in the menu, 0 will hide it.

		editorCategory = "AE3_Assets";
		editorSubcategory = "AE3_Sub_Routers";

		curatorInfoTypeEmpty = "AE3_UserInterface_Zeus_Asset_Details";

		AE3_ROUTER_CONFIG_ATTRIBUTES

		class AE3_Device
		{
			displayName = "$STR_AE3_Network_Config_RouterDisplayName";
			init = "call AE3_network_fnc_initRouter;";

			defaultPowerLevel = 0;

			turnOnAction = "call AE3_network_fnc_dhcp_onTurnOn; true";
			turnOffAction = "call AE3_network_fnc_router_onTurnOff; true";

			class AE3_PowerInterface
			{
				internal = 0;
			};

			class AE3_Consumer
			{
				powerConsumption = 0.01/3600; // consumes 10 Watts
			};
		};

		// Routers ship with a built-in 100 Wh battery so they run without an external supply.
		class AE3_InternalDevice
		{
			displayName = "$STR_AE3_Power_Config_BatteryDisplayName";
			defaultPowerLevel = 1;

			turnOnAction = "_this + [true] call AE3_power_fnc_turnOnBatteryAction";
			turnOffAction = "";

			class AE3_PowerInterface
			{
				internal = 1;
			};

			class AE3_Battery
			{
				capacity = 0.1; // 100 Watt-hours max. capacity
				recharging = 0.05/3600; // 50 Watts power consumption while recharging
				level = 0.1; // start fully charged
				internal = 1;
			};
		};

		class AE3_Equipment
		{
			class AE3_ace3Interactions
			{
				class AE3_aceCarrying
				{
					// Carrying
					ae3_dragging_canCarry = 1;  // Can be dragged (0-no, 1-yes)
					ae3_dragging_carryPosition[] = {0, 1, 1};  // Offset of the model from the body while dragging (same as attachTo)
					ae3_dragging_carryDirection = 0;  // Model direction while dragging (same as setDir after attachTo)
				};
				class AE3_aceCargo
				{
					ae3_cargo_canLoad = 1;  // Enables the object to be loaded (1-yes, 0-no)
					ae3_cargo_size = 1;  // Cargo space the object takes
				};
			};
		};
	};

	/* ================================================================================ */

};
