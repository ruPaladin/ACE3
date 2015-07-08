/*
 * Author: Garth 'L-H' de Wet
 * Whether a unit can perform the defuse action
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Able to defuse <BOOL>
 *
 * Example:
 * if ([player] call ACE_Explosives_fnc_canDefuse) then {hint "Can Defuse";};
 *
 * Public: Yes
 */
#include "script_component.hpp"
private ["_isSpecialist"];
params ["_unit","_target"];
if (isNull(_target getVariable [QGVAR(Explosive),objNull])) exitWith {
    deleteVehicle _target;
    false
};
if (vehicle _unit != _unit || {!("ACE_DefusalKit" in (items _unit))}) exitWith {false};
_isSpecialist = [_unit] call EFUNC(Common,isEOD);

if (GVAR(RequireSpecialist) && {!_isSpecialist}) exitWith {false};

true
