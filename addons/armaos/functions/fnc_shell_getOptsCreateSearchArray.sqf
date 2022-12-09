params ["_commandOpts", "_formType"];

private _result = [];

{
    if (_formType isEqualTo "short") then { _result pushBack (_x select 1); };
    if (_formType isEqualTo "long") then { _result pushBack (_x select 2); };
} forEach _commandOpts;

_result;