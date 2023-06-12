params ["_entity"];

systemchat format ["Deleted entity (General): %1", _entity];

[_entity] call AE3_power_fnc_turnOffDevice;

/*
_entity addEventHandler
[
    "Deleted",
    {
        params ["_entity"];

        systemchat format ["Deleted entity (General): %1", _entity];
    }
];

private _class = typeOf _entity;
if (_class isEqualTo "ModuleCurator_F") then
{
    _entity addEventHandler ["CuratorObjectDeleted", {
        params ["_curator", "_entity"];

        systemchat format ["Deleted entity (Curator): %1", _entity];
    }];

    _entity addEventHandler ["CuratorObjectEdited", {
        params ["_curator", "_entity"];

        systemchat format ["Edited entity (Curator): %1", _entity];
    }];

    _entity addEventHandler ["CuratorObjectPlaced", {
        params ["_curator", "_entity"];

        systemchat format ["Placed entity (Curator): %1", _entity];
    }];
};
*/