/**
 * Sets effects on damaged laptop
 *
 * Arguments:
 * 0: Laptop <OBJECT>
 *
 * Returns:
 * true
 */

params["_laptop"];

// if terminal is open, set the broken display overlay
private _consoleDialog = findDisplay 15984;
if (!isNull _consoleDialog) then 
{
    // enable broken display overlay
    private _overlay = _consoleDialog displayCtrl 1500;
    _overlay ctrlSetText "\z\ae3\addons\armaos\textures\AE3_Terminal_broken.paa";
};

true;