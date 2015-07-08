/*
 * Author: KoffeinFlummi and esteldunedain
 * Calculates average g-forces and triggers g-effects
 *
 * Argument:
 * 0: Arguments <ARRAY>
 * 1: pfh_id <NUMBER>
 *
 * Return value:
 * None
 *
 * Public: No
 */
 #include "script_component.hpp"

private ["_interval", "_player", "_newVel", "_accel", "_currentGForce", "_average", "_sum", "_classCoef", "_suitCoef", "_gBlackOut", "_gRedOut", "_g", "_gBO", "_coef", "_strength"];

params ["_params","_pfhId"];

_interval = ACE_time - GVAR(lastUpdateTime);

// Update the g-forces at constant game ACE_time intervals
if (_interval < INTERVAL) exitWith {};

if (isNull ACE_player) exitWith {};

if !(alive ACE_player) exitWith {};

GVAR(lastUpdateTime) = ACE_time;

/*if !(vehicle ACE_player isKindOf "Air") exitWith {
    GVAR(GForces) = [];
    GVAR(GForces_Index) = 0;
    waitUntil {sleep 5; (vehicle _player isKindOf "Air") or ((getPos _player select 2) > 5)};
};*/

_newVel = velocity (vehicle ACE_player);

_accel = ((_newVel vectorDiff GVAR(oldVel)) vectorMultiply (1 / INTERVAL)) vectorAdd [0, 0, 9.8];
_currentGForce = (_accel vectorDotProduct vectorUp (vehicle ACE_player)) / 9.8;

// Cap maximum G's to +- 10 to avoid g-effects when the update is low fps.
_currentGForce = (_currentGForce max -10) min 10;

GVAR(GForces) set [GVAR(GForces_Index), _currentGForce];
GVAR(GForces_Index) = (GVAR(GForces_Index) + 1) % round (AVERAGEDURATION / INTERVAL);
GVAR(oldVel) = _newVel;

/* Source: https://github.com/KoffeinFlummi/AGM/issues/1774#issuecomment-70341573
*
* For untrained people without g-suits:
* GLOC: 5G for 6 s
* RedOut: 2.5G for 6 s
*
* For trained jet pilots without g-suits:
* GLOC: 9G for 6 s
* RedOut: 4.5G
*
* For trained jet pilots with g-suits:
* GLOC: 10.5G for 6 s
* RedOut: 4.5G
*
* Effects and camera shake start 30% the limit value, and build gradually
*/

_average = 0;
if (count GVAR(GForces) > 0) then {
    _sum = 0;
    {
        _sum = _sum + _x;
    } forEach GVAR(GForces);
    _average = _sum / (count GVAR(GForces));
};

_classCoef = ACE_player getVariable ["ACE_GForceCoef",
    getNumber (configFile >> "CfgVehicles" >> (typeOf ACE_player) >> "ACE_GForceCoef")];
_suitCoef = if ((uniform ACE_player) != "") then {
    getNumber (configFile >> "CfgWeapons" >> (uniform ACE_player) >> "ACE_GForceCoef")
} else {
    1
};

//Fix "Error Zero divisor"
if (_classCoef == 0) then {_classCoef = 0.001};
if (_suitCoef == 0) then {_suitCoef = 0.001};

_gBlackOut = MAXVIRTUALG / _classCoef + MAXVIRTUALG / _suitCoef - MAXVIRTUALG;
_gRedOut = MINVIRTUALG / _classCoef;

["GForces", [], {format ["_g _gBO _coef: %1, %2, %3", _average, _gBlackOut, 2 * ((1.0 - ((_average - 0.30 * _gBlackOut) / (0.70 * _gBlackOut)) ^ 2) max 0) ]}] call EFUNC(common,log);

// @todo: Sort the interaction with medical
if ((_average > _gBlackOut) and {isClass (configFile >> "CfgPatches" >> "ACE_Medical") and {!(ACE_player getVariable ["ACE_isUnconscious", false])}}) then {
    [ACE_player, true, (10 + floor(random 5))] call EFUNC(medical,setUnconscious);
};

GVAR(GForces_CC) ppEffectAdjust [1,1,0,[0,0,0,1],[0,0,0,0],[1,1,1,1],[10,10,0,0,0,0.1,0.5]];

if !(ACE_player getVariable ["ACE_isUnconscious", false]) then {
    if (_average > 0.30 * _gBlackOut) then {
        _strength = ((_average - 0.30 * _gBlackOut) / (0.70 * _gBlackOut)) max 0;
        GVAR(GForces_CC) ppEffectAdjust [1,1,0,[0,0,0,1],[0,0,0,0],[1,1,1,1],[2*(1-_strength),2*(1-_strength),0,0,0,0.1,0.5]];
        addCamShake [_strength, 1, 15];
    } else {
        if (_average < -0.30 * _gRedOut) then {
            _strength = ((abs _average - 0.30 * _gRedOut) / (0.70 * _gRedOut)) max 0;
            GVAR(GForces_CC) ppEffectAdjust [1,1,0,[1,0.2,0.2,1],[0,0,0,0],[1,1,1,1],[2*(1-_strength),2*(1-_strength),0,0,0,0.1,0.5]];
            addCamShake [_strength / 1.5, 1, 15];
        };
    };
};

GVAR(GForces_CC) ppEffectCommit INTERVAL;
