/**
 * Sets effects on destroyed laptop
 *
 * Arguments:
 * 0: Laptop <OBJECT>
 *
 * Returns:
 * true
 */

params["_laptop"];

// if terminal is open, close the terminal and turn off computer
private _consoleDialog = findDisplay 15984;
if (!isNull _consoleDialog) then 
{
    // close terminal
    closeDialog 1;

    // turn off computer
    [_laptop, [true]] call (_computer getVariable "AE3_power_fnc_turnOffWrapper");
};

true;