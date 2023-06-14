params ["_display", "_exitCode", "_event"];

private _module = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _module) exitWith {};

/* ---------------------------------------- */

if (_event isEqualTo "onLoad") then
{
    private _mouseOver = missionNamespace getVariable ["BIS_fnc_curatorObjectPlaced_mouseOver", [""]];
    _mouseOver params ["_mouseOverType", "_mouseOverUnit"];

    // check if module was placed on top of another object
    if (_mouseOverType != "OBJECT") exitWith
    {
        _display setVariable ["AE3_linkedComputer", objNull];

        [objNull, "No computer. Place module on computer."] call BIS_fnc_showCuratorFeedbackMessage;

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

        [objNull, "No computer. Place module on computer."] call BIS_fnc_showCuratorFeedbackMessage;

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
        deleteVehicle _module;
    };

    // get isSnake from UI
    private _isSnakeCtrl = _display displayCtrl 1401;
    private _isSnake = cbChecked _isSnakeCtrl;

    // add security commands to computer
    [_computer, _isSnake] call AE3_armaos_fnc_computer_addGames;

    private _message = format ["snake: %1 ", _isSnake];
    ["AE3 Games added", _message, 5] call BIS_fnc_curatorHint;

    // delete module if dialog cancelled or computer not linked to module
    deleteVehicle _module;
};

/* ---------------------------------------- */