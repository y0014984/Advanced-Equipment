# Power framework
 
## Adding a device via config
 
Example: </br>
```cpp
class Land_PortableLight_single_F;
 
class Land_PortableLight_single_F_AE3: Land_PortableLight_single_F
{
    class AE3_Device
        {
            init = "params['_entity']; [_entity] call AE3_interaction_fnc_initLamp;";
 
            displayName = "Lamp";
            defaultPowerLevel = 0;
 
            turnOnAction = "_this call AE3_interaction_fnc_lamp_turnOn";
            turnOffAction = "_this call AE3_interaction_fnc_lamp_turnOff";
 
            class AE3_PowerInterface
            {
                internal = 0;
            };
 
            class AE3_Consumer
            {
                powerConsumption = 0.03/3600;
            };
        };
};
```
 
### Base (AE3_Device)
Base device class.
<br>
| Config | Type | Description |
| ------ | ------ | ------ |
| displayName | String | Device name (Optional) |
| defaultPowerState | Number | Powerstate (0 = off, 1 = on, 2= standby)(Optional) |
| init | String (Code) | Init function (Optional) |
| turnOnAction | String (Code) | Turn on function (Optional) |
| turnOffAction | String (Code) | Turn off function (Optional) |
| standbyAction | String (Code) | Standby function (Optional) |
 
### Consumer (AE3_Consumer)
Adds power requirement to the on and standby actions.
<br>
| Config | Type | Description |
| ------ | ------ | ------ |
| powerConsumption | Number | Power consumption when on in [kW] |
| standbyConsumption | Number | Power consumption on standby in [kW] (Optional)|
 
### Power interface (AE3_PowerInterface)
Adds the possibility to connect the device to a power source.
<br>
| Config | Type | Description |
| ------ | ------ | ------ |
| connected | [Object] | Default connected devices (Optional) |
| internal | Bool | If the connection action should be unavailable |
 
### Battery (AE3_Battery)
Adds battery functionality to the device
<br>
| Config | Type | Description |
| ------ | ------ | ------ |
| capacity | Number | Battery capacity in [kWh] |
| recharging | Number | Recharging rate in [kW] |
| level | Number | Default charge in [kWh] (Optional)|
| internal | Bool | If the battery is only internal (Optional) |
 
### Generator (AE3_Generator)
Adds generator functionality to the device
<br>
| Config | Type | Description |
| ------ | ------ | ------ |
| fuelCapacity | Number | Fuel capacity in [l] |
| fuelConsumption | Number | Fuel capacity in [l/h] |
| power | Number | Power output in [kW] |
| fuelLevel | Number | Default fuel level (Optional) |

