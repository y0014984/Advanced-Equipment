#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns every initialised router, including dead and powered-off ones. Null entries are skipped.
 * Any machine.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Routers <ARRAY> of <OBJECT>
 *
 * Example:
 * private _routers = call AE3_network_fnc_getRouters;
 *
 * Public: Yes
 */

(missionNamespace getVariable ["AE3_network_routers", []]) select {!isNull _x}
