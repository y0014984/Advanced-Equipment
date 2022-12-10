params ["_optSettings", "_arg"];

private _optVarName = _optSettings select 0;
private _optType = _optSettings select 3;
private _optSelect = [];

if (_optType isEqualTo "bool") exitWith { [_optVarName, true]; };

if ((_optType isEqualTo "string") && !(_arg isEqualTo "")) exitWith { [_optVarName, _arg]; };

if ((_optType isEqualTo "number") && !(_arg isEqualTo "")) exitWith { [_optVarName, parseNumber _arg]; };

if ((_optType isEqualTo "stringSelect") || (_optType isEqualTo "numberSelect")) then { _optSelect = _optSettings select 7; };

if ((_optType isEqualTo "stringSelect") && !(_arg isEqualTo "") && (_arg in _optSelect)) exitWith { [_optVarName, _arg]; };

if ((_optType isEqualTo "numberSelect") && !(_arg isEqualTo "") && ((parseNumber _arg) in _optSelect)) exitWith { [_optVarName, parseNumber _arg]; };

["_unknown", _arg];