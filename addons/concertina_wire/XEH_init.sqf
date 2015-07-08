#include "script_component.hpp"

params ["_wire"];
_wire addEventHandler ["HandleDamage", {_this call FUNC(handleDamage)}];
