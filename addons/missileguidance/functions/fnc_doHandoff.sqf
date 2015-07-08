#include "script_component.hpp"
params ["_target","_args"];

[QGVAR(handoff), [_target, _args]] call EFUNC(common,globalEvent);
