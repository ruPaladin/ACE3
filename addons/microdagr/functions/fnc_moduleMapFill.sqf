/*
 * Author: PabstMirror
 * Function for the module (handles the map fill level)
 *
 * Arguments:
 * 0: logic <OBJECT>
 * 1: synced units-not used <ARRAY>
 * 2: Module Activated <BOOL>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [module, [], true] call ace_microdagr_fnc_moduleMapFill
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_logic","_syncedUnits","_activated"];

if (!_activated) exitWith {WARNING("Module Placed but not active");};

if (isServer) then {
  [_logic, QGVAR(MapDataAvailable), "MapDataAvailable"] call EFUNC(common,readSettingFromModule);
};
