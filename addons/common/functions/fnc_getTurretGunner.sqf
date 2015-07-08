/*
 * Author: commy2
 *
 * Get the turret index of a vehicles gunner.
 *
 * Argument:
 * 0: Vehicle (Object)
 *
 * Return value:
 * Turret index of the vehicles gunner. Empty array means no gunner position. (Array)
 */
#include "script_component.hpp"

private ["_turrets", "_turret", "_config"];

params ["_vehicle"];

_turrets = allTurrets [_vehicle, true];

_turret = [];
{
    _config = configFile >> "CfgVehicles" >> typeOf _vehicle;

    _config = [_config, _x] call FUNC(getTurretConfigPath);

    if (getNumber (_config >> "primaryGunner") == 1) exitWith {
        _turret = _x;
    };
} forEach _turrets;

_turret
