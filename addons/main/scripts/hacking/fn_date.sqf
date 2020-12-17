params ["_options", "_consoleInput"];

_result = [];

_optionsCount = count _options;

scopeName "main";

switch (true) do
{
	case (_optionsCount >= 1):
	{
		//hint "Case 1";
		
		_result = ["   Command: date has no options"];
		_result breakOut "main";
	};
	case (_optionsCount == 0):
	{
		//hint "Case 2";

		_date = date;
		_year = _date select 0;
		_month = _date select 1;
		_day = _date select 2;

		if (_month < 10) then {_month = format["0%1", _month]};
		if (_day < 10) then {_day = format["0%1", _day]};

		_time = [daytime, "HH:MM:SS"] call BIS_fnc_timeToString; // 07:21:12

		_date = format ["Date: %1-%2-%3 %4", _year, _month, _day, _time];

		_result = ["   Command: date "] + [" "] + [_date];
	};
};

_result;