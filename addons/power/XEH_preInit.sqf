#include "script_component.hpp"
#include "XEH_PREP.hpp"


["All", "init", {_this call AE3_power_fnc_compileDevice}] call CBA_fnc_addClassEventHandler;

["All", "deleted", {_this call AE3_power_fnc_terminateDevice}] call CBA_fnc_addClassEventHandler;