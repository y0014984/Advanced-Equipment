params ["_shortOpt", "_commandOpts"];

private _result = createHashMap;

// remove the leading "-"
_shortOpt = _shortOpt select [1, (count _shortOpt) - 1];

// split into option and argument
([_shortOpt] call AE3_armaos_fnc_shell_getOptsSplitOptionArgument) params ["_shortOptWithoutArg", "_arg"];

private _searchArray = [_commandOpts, "short"] call AE3_armaos_fnc_shell_getOptsCreateSearchArray;

if (((count _shortOptWithoutArg) == 1) && !(_arg isEqualTo "")) then
{
    // if single short opt with arg
    
    private _searchIndex = _searchArray find _shortOptWithoutArg;

    if (_searchIndex != -1) then
    {
        private _shortOptSettings = _commandOpts select _searchIndex;

        _result set ([_shortOptSettings, _arg] call AE3_armaos_fnc_shell_getOptsConvertArgType);
    };
}
else
{
    // else process all chars as single opts without arg, like in ls -alh --> 3 bool options
    
    private _shortOptsArray = _shortOptWithoutArg splitString "";
    {
        private _searchIndex = _searchArray find _x;
        if (_searchIndex != -1) then
        {
            private _shortOptSettings = _commandOpts select _searchIndex;

            if ((count _shortOptsArray) == 1) then
            {
                // a single short opt can have a arg, like in ls -w=5
                _result set ([_shortOptSettings, _arg] call AE3_armaos_fnc_shell_getOptsConvertArgType);
            }
            else
            {
                // multiple opts, like in ls -alh can't have arg like single opts, so value set to 'true'
                _result set ([_shortOptSettings, true] call AE3_armaos_fnc_shell_getOptsConvertArgType);
            };
        };
    } forEach _shortOptsArray;
};

_result;