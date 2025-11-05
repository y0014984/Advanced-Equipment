/**
 * Creates an ARRAY of options, that is easy to search through by 'find' command
 *
 * Arguments:
 * 1: Command Options <[ARRAY]>
 * 2: Form Type <STRING>
 *
 * Results:
 * 1: Results <[STRING]>
 *
 */

params ["_commandOpts", "_formType"];

private _result = [];

{
    if (_formType isEqualTo "short") then { _result pushBack (_x select 1); };
    if (_formType isEqualTo "long") then { _result pushBack (_x select 2); };
} forEach _commandOpts;

_result;
