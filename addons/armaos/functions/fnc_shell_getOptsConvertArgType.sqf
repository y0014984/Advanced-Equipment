params ["_optSettings", "_arg"];

private _optType = _optSettings select 3;
private _optVarName = _optSettings select 0;

if (_optType isEqualTo "bool") exitWith { [_optVarName, true]; };

if (_optType isEqualTo "string" && !(_arg isEqualTo "")) exitWith { [_optVarName, _arg]; };

if (_optType isEqualTo "number" && !(_arg isEqualTo "")) exitWith { [_optVarName, parseNumber _arg]; };

["_unknown", _arg];