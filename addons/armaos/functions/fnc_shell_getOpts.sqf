// Parse command string and return set command arguments

// option short form:
// 'ls -a' or combining multiple arguments 'ls -alh'
// option long form:
// 'ls --all -l --human-readable'
// option with argument:
// 'ls --width=5'

// defining _commandOpts (HASHMAP)
// _type = Opt or OptWithArg
// _short = single char or "" if not set
// _long = multiple chars or "" if not set

params ["_optsStringElements", "_commandOpts"];

private _result = [];
private _resultOpts = createHashMap;
private _resultThings = [];

// initialize options
{
	private _optSettings = _commandOpts get _x;
	private _optType = _optSettings select 0;
	private _optVarName = _optSettings select 1;
    private _optDefaultValue = _optSettings select 2;
	_resultOpts set [_optVarName, _optDefaultValue];
} forEach _commandOpts;

{
    // if it starts with "-", its an option, short or long
    if ((_x select [0, 1]) isEqualTo "-") then
    {
		// long form; min. count 4, because "--" + 2 chars; otherwise it would be short form
		if ( ((_x select [0, 2]) isEqualTo "--") && ((count _x) >= 4) ) then
		{
			// remove the leading "--"
			private _longOpt = _x select [2, (count _x) - 2];

			// split into option and argument
			private _longOptSegments = _longOpt splitString "=";
			private _longOptWithoutArg = _longOptSegments select 0;
			private _arg = "";

			if ((count _longOptSegments) >= 2) then { _arg = _longOptSegments select 1; };

			if (_longOptWithoutArg in _commandOpts) then
			{
				private _longOptSettings = _commandOpts get _longOptWithoutArg;
				private _longOptType = _longOptSettings select 0;
				private _longOptVarName = _longOptSettings select 1;
                private _longOptIsNumber = _longOptSettings select 3;

				if (_longOptType isEqualTo "bool") then 
				{
					// long bool option
					_resultOpts set [_longOptVarName, true];
				};

				if (_longOptType isEqualTo "arg" && !(_arg isEqualTo "")) then 
				{
					// long arg option
                    if (_longOptIsNumber) then {_arg = parseNumber _arg};
					_resultOpts set [_longOptVarName, _arg];
				};
			};
		}
		else 
		{
            // if it's not long form, perhaps it's short form
			if ( ((_x select [0, 1]) isEqualTo "-") && ((count _x) >= 2) ) then
			{
				// remove the leading "-"
				private _shortOpt = _x select [1, (count _x) - 1];

				// split into option and argument
				private _shortOptSegments = _shortOpt splitString "=";
				private _shortOptWithoutArg = _shortOptSegments select 0;
				private _arg = "";

				if ((count _shortOptSegments) >= 2) then
				{
					// if short options string contains a "=" char, it is a single option in arg mode
                    // technically this would allow shot form versions with more then one character, like ls -wid=4
					_arg = _shortOptSegments select 1;
					if (_shortOptWithoutArg in _commandOpts) then
					{
						private _shortOptSettings = _commandOpts get _shortOptWithoutArg;
						private _shortOptType = _shortOptSettings select 0;
						private _shortOptVarName = _shortOptSettings select 1;
                        private _shortOptIsNumber = _shortOptSettings select 3;

						if (_shortOptType isEqualTo "arg" && !(_arg isEqualTo "")) then 
						{
                            if (_shortOptIsNumber) then {_arg = parseNumber _arg};
							_resultOpts set [_shortOptVarName, _arg];
						};
					};
				}
				else
				{
					// if the short options string is bool type and contains one or more options, like in ls -alh --> 3 options
					private _shortOptsArray = _shortOpt splitString "";
					{
						if (_x in _commandOpts) then
						{
							private _shortOptSettings = _commandOpts get _x;
							private _shortOptType = _shortOptSettings select 0;
							private _shortOptVarName = _shortOptSettings select 1;

							if (_shortOptType isEqualTo "bool") then { _resultOpts set [_shortOptVarName, true]; };
						};
					} forEach _shortOptsArray;
				};
			};
		};
    }
    else
    {
        // if it's not an option/arg, it must be something else, perhaps path/dir/ip/text or other
        _resultThings pushBack _x;
    };
} forEach _optsStringElements;

// add things as the additional reserved var "_ae3OptsThings" to the results
_resultOpts set ["_ae3OptsThings", _resultThings];

_result = _resultOpts toArray false; // Convert HashMap to Array

_result;