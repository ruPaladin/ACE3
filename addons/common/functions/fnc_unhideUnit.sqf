/*
 * Author: SilentSpike (based on unmuteUnit)
 * Globally unhides a unit. Only unhides if the last reason was removed.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Reason to unhide the unit <STRING>
 *
 * Return Value:
 * nil
 *
 * Example:
 * [ACE_Player, "SpectatorMode"] call ace_common_fnc_unhideUnit
 *
 * Public: No
 */

#include "script_component.hpp"

params ["_unit","_reason"];

if (isNull _unit) exitWith {};

private "_setHiddenReasons";
_setHiddenReasons = _unit getVariable [QGVAR(setHiddenReasons), []];

if (_reason in _setHiddenReasons) then {
    _setHiddenReasons deleteAt (_setHiddenReasons find _reason);
    _unit setVariable [QGVAR(setHiddenReasons), _setHiddenReasons, true];
};

if (_setHiddenReasons isEqualTo []) then {
    ["hideObjectGlobal",[_unit,false]] call FUNC(serverEvent);
};
