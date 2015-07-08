//#define DEBUG_MODE_FULL
#include "script_component.hpp"
params ["_target","_ammo","_shooter"];

if(GVAR(enabled) < 1) exitWith {};    // bail if enabled
if !(local (gunner _shooter) || {local _shooter}) exitWith {}; // bail if not shooter

_shooter setVariable [QGVAR(vanilla_target),_target, false];
