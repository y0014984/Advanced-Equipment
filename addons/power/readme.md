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

## Variables

Name             | Type        | Desciption                                                 | Location
----             | -----       | -----------                                                | -------
mutex            | bool        | if the device is currently changes its power state         | public
powerState       | int         | `1` if turned on, `0` if turned off `2` if on standby      | public
turnOnWrapper    | code        | function, which defines the turn on behavior               | public
turnOnCondition  | code        | function, which defines if the turnOn action is available  | public 
turnOnFunction   | code        | turnOn function for the device                             | public
turnOffWrapper   | code        | function, which defines the turn off behavior              | public
turnOffCondition | code        | function, which defines if the turnOff action is available | public 
turnOffFunction  | code        | turnOff function for the device                            | public
standbyWrapper   | code        | function, which defines the standby behavior               | public
standbyCondition | code        | function, which defines if the standby action is available | public 
standbyFunction  | code        | standby function for the device                            | public

### Consumer

Name               | Type        | Desciption                                                 | Location
----               | -----       | -----------                                                | -------
powerConsumption   | number      | Power consumption in [kW] when on                          | public
standbyConsumption | number      | Power consumption in [kW] when in standby                  | public
powerDraw          | number      | Current power consumption in [kW]                          | public

### Power Interface
Name               | Type        | Desciption                                                 | Location
----               | -----       | -----------                                                | -------
powerCableDevice   | object      | Power suppling device                                      | public

### Generator

Name               | Type        | Desciption                                                 | Location
----               | -----       | -----------                                                | -------
powerMax           | number      | Maximum power ouput in [kW]                                | public
powerCapacity      | number      | Current power capacity in [kW]                             | server
connectedDevices   | [objects]   | Connected devices to the generator                         | public
generatorHandle    | int         | Handler for the generator loop                             | server

#### Diesel Generator

Name               | Type        | Desciption                                                 | Location
----               | -----       | -----------                                                | -------
fuelCapacity       | number      | Fuel capacity in [l]                                       | public 
fuelLevel          | number      | Current fuel level in [l]                                  | server
fuelConsumption    | number      | Fuel consumption in [l/h]                                  | public 

#### Solar Generator
Name               | Type        | Desciption                                                 | Location
----               | -----       | -----------                                                | -------
height             | number      | Height of the solar panels relative to the object coords.  | public
orientationFnc     | code        | returns a list of normal vectors for each solar panel      | public

#### Battery
Name                  | Type        | Desciption                                                 | Location
----                  | -----       | -----------                                                | -------
batteryCapacity       | number      | Battery capacity in [kWh]                                  | public
batteryLevel          | number      | Current battery level in [kWh]                             | server
recharging            | number      | Maximum recharging rate in [kW]                            | public
powerConsumptionState | int         | DEPRICATED                                                 | ------

##### Internal

**Parent Device:**
Name                  | Type        | Desciption                                                 | Location
----                  | -----       | -----------                                                | -------
internalBattery       | bool        | If the device has an internal battery                      | public

**Internal Battery:**
Name                  | Type        | Desciption                                                 | Location
----                  | -----       | -----------                                                | -------
parent                | object      | Parent device to the interanl battery                      | public