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
        deleteVehicle _module;
    };

    // get values from UI
    private _pathCtrl = _display displayCtrl 1401;
    private _ownerCtrl = _display displayCtrl 1403;
    private _ownerReadCtrl = _display displayCtrl 1302;
    private _ownerWriteCtrl = _display displayCtrl 1303;
    private _ownerExecuteCtrl = _display displayCtrl 1304;
    private _everyoneReadCtrl = _display displayCtrl 1305;
    private _everyoneWriteCtrl = _display displayCtrl 1306;
    private _everyoneExecuteCtrl = _display displayCtrl 1307;
    private _path = ctrlText _pathCtrl;
    private _owner = ctrlText _ownerCtrl;
    private _ownerRead = cbChecked _ownerReadCtrl;
    private _ownerWrite = cbChecked _ownerWriteCtrl;
    private _ownerExecute = cbChecked _ownerExecuteCtrl;
    private _everyoneRead = cbChecked _everyoneReadCtrl;
    private _everyoneWrite = cbChecked _everyoneWriteCtrl;
    private _everyoneExecute = cbChecked _everyoneExecuteCtrl;
    private _permissions = [[_ownerExecute, _ownerRead, _ownerWrite], [_everyoneExecute, _everyoneRead, _everyoneWrite]];

    // check for empty but mandatory input fields
    // module is still there an could be opened and filled in with valid input
    // but currently, this case will be catched by UI logic, defined directly in config
    if(_path isEqualTo "") exitWith { hint "Path missing"; };
    if(_owner isEqualTo "") exitWith { hint "Owner missing"; };

    // add file to computer
    [_computer, _path, _owner, _permissions] call AE3_filesystem_fnc_device_addDir;

    hint format ["Directory added \n ---------- \n\n path: %1 \n owner: %2 \n permissions: %3", _path, _owner, _permissions];

    // delete module if dialog cancelled or computer not linked to module
    deleteVehicle _module;
};

/* ---------------------------------------- */