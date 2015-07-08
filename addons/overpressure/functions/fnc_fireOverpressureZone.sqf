/*
 * Author: commy2 and esteldunedain
 *
 * Handle fire of local vehicle weapons creating overpressure zones
 *
 * Argument:
 * 0: Unit that fired (Object)
 * 1: Weapon fired (String)
 * 2: Muzzle (String)
 * 3: Mode (String)
 * 4: Ammo (String)
 * 5: Magazine (String)
 * 6: Projectile (Object)
 *
 * Return value:
 * None
 */
//#define DEBUG_MODE_FULL
#include "script_component.hpp"

params ["_firer","_weapon","_muzzle","_mode","_ammo","_magazine","_projectile"];

// Prevent AI from causing overpressure damage
if !([gunner _firer] call EFUNC(common,isPlayer)) exitWith {};  //@todo non-maingun turrets?

private ["_position", "_direction"];

_position = getPosASL _projectile;
_direction = vectorDir _projectile;

private ["_dangerZoneAngle", "_dangerZoneRange", "_dangerZoneDamage"];

_dangerZoneAngle = getNumber (configFile >> "CfgWeapons" >> _weapon >> QGVAR(angle)) / 2;
_dangerZoneRange = getNumber (configFile >> "CfgWeapons" >> _weapon >> QGVAR(range));
_dangerZoneDamage = getNumber (configFile >> "CfgWeapons" >> _weapon >> QGVAR(damage));

// Damage to others
private "_affected";
_affected = getPos _projectile nearEntities ["CAManBase", _dangerZoneRange];

// Let each client handle their own affected units
["overpressure", _affected, [_firer, _position, _direction, _weapon]] call EFUNC(common,targetEvent);

// Draw debug lines
#ifdef DEBUG_MODE_FULL
    [   _position,
        _position vectorAdd (_direction vectorMultiply _dangerZoneRange),
        [1,0,0,1]
    ] call EFUNC(common,addLineToDebugDraw);

    private "_ref";
    _ref = _direction call EFUNC(common,createOrthonormalReference);
    [   _position,
        _position vectorAdd (_direction vectorMultiply _dangerZoneRange) vectorAdd ((_ref select 1) vectorMultiply _dangerZoneRange * tan _dangerZoneAngle),
        [1,1,0,1]
    ] call EFUNC(common,addLineToDebugDraw);
    [   _position,
        _position vectorAdd (_direction vectorMultiply _dangerZoneRange) vectorDiff ((_ref select 1) vectorMultiply _dangerZoneRange * tan _dangerZoneAngle),
        [1,1,0,1]
    ] call EFUNC(common,addLineToDebugDraw);
    [   _position,
        _position vectorAdd (_direction vectorMultiply _dangerZoneRange) vectorAdd ((_ref select 2) vectorMultiply _dangerZoneRange * tan _dangerZoneAngle),
        [1,1,0,1]
    ] call EFUNC(common,addLineToDebugDraw);
    [   _position,
        _position vectorAdd (_direction vectorMultiply _dangerZoneRange) vectorDiff ((_ref select 2) vectorMultiply _dangerZoneRange * tan _dangerZoneAngle),
        [1,1,0,1]
    ] call EFUNC(common,addLineToDebugDraw);

#endif
