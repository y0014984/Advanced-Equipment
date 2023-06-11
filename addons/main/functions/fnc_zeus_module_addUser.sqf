params ["_display", "_exitCode", "_event"];

private _logic = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _logic) exitWith {};

/* ---------------------------------------- */

if (_event isEqualTo "onLoad") then
{
    private _mouseOver = missionNamespace getVariable ["BIS_fnc_curatorObjectPlaced_mouseOver", [""]];
    _mouseOver params ["_mouseOverType", "_mouseOverUnit"];

    // check if module was placed on top of another object
    if (_mouseOverType != "OBJECT") exitWith
    {
        _display setVariable ["AE3_linkedComputer", objNull];

        hint "No computer. Place module on computer.";

        // close display
        _display closeDisplay 2; // 2 = cancel
    };

    // check if filesystem exists, which means that _mouseOverUnit is a computer
    // ??? Is this also true for a USB Stick?
    // TODO: Add a simple identifier to distinguish between device classes
    private _computer = _mouseOverUnit;
    private _filesystem = _computer getVariable ["AE3_filesystem", []];
    if (_filesystem isEqualTo []) exitWith
    {
        _display setVariable ["AE3_linkedComputer", objNull];

        hint "No computer. Place module on computer.";

        // close display
        _display closeDisplay 2; // 2 = cancel
    };

    // add computer variable to display namespace
    _display setVariable ["AE3_linkedComputer", _mouseOverUnit];
};

/* ---------------------------------------- */

if (_event isEqualTo "onUnload") then
{
    private _computer = _display getVariable ["AE3_linkedComputer", objNull];
    if ((isNull _computer) || (_exitCode == 2)) exitWith
    {
        // delete module if dialog cancelled or computer not linked to module
        deleteVehicle _logic;
    };

    // get username and password from UI
    private _usernameCtrl = _display displayCtrl 1401;
    private _passwordCtrl = _display displayCtrl 1402;
    private _username = ctrlText _usernameCtrl;
    private _password = ctrlText _passwordCtrl;

    // check for empty but mandatory input fields
    // module is still there an could be opened and filled in with valid input
    // but currently, this case will be catched by UI logic, defined directly in config
    if(_username isEqualTo "") exitWith { hint "Username missing"; };
    if(_password isEqualTo "") exitWith { hint "Password missing"; };

    // add user to computer
    [_computer, _username, _password] call AE3_armaos_fnc_computer_addUser;

    // delete module if dialog cancelled or computer not linked to module
    deleteVehicle _logic;
};

/* ---------------------------------------- */