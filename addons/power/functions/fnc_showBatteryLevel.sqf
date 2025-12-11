/*
 * Author: Root
 * Description: Legacy function that continuously updates terminal title with battery level and power mode. Monitors battery state while terminal dialog is open and updates title text every second. May be deprecated in favor of newer terminal state management.
 *
 * Arguments:
 * 0: _computer <OBJECT> - Computer/laptop object
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop] spawn AE3_power_fnc_showBatteryLevel;
 *
 * Public: No
 */

params ["_computer"];

private _consoleDialog = findDisplay 15984;	

while {_consoleDialog != displayNull} do
{
	_consoleTitle = _consoleDialog displayCtrl 1000;

	_batteryLevel = _computer getVariable ["AE3_power_batteryLevel", 1];

	// 0 = battery; 1 = cable
	_powerConsumptionState = _computer getVariable ["AE3_power_powerConsumptionState", 0];

	_powerConsumptionStateText = "";

	switch (_powerConsumptionState) do
	{
		case 0: { _powerConsumptionStateText = localize "STR_AE3_Power_Terminal_PowerConsumptionModeBattery"; };
		case 1: { _powerConsumptionStateText = localize "STR_AE3_Power_Terminal_PowerConsumptionModePowerAdapter"; };
		default { _powerConsumptionStateText = localize "STR_AE3_Power_Terminal_PowerConsumptionModeUnknown"; };
	};

	_titleText = format [localize "STR_AE3_Power_Terminal_TerminalTitle", ceil _batteryLevel, "%", _powerConsumptionStateText];

	ctrlSetText [1000, _titleText];

	sleep 1;
};
