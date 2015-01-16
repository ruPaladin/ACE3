/*

by commy2

Handles releasing the special vector keys.

*/
#include "script_component.hpp"

private "_fnc_setPFH";
_fnc_setPFH = {
    if (GVAR(holdKeyHandler) > -1) then {
        [GVAR(holdKeyHandler)] call CBA_fnc_removePerFrameHandler;
        GVAR(holdKeyHandler) = -1;
    };

    GVAR(currentMode) = _this;//
    GVAR(holdKeyHandler) = [FUNC(onKeyHold), 0, _this] call CBA_fnc_addPerFrameHandler;
};

switch (_this select 0) do {
    case ("azimuth"): {

        GVAR(isKeyDownAzimuth) = false;

        if (GVAR(isKeyDownDistance)) then {
            if (GVAR(currentMode) == "distance") then {
                ["azimuth"] call FUNC(clearDisplay);
                [true] call FUNC(showP1);
                GVAR(pData) = [call FUNC(getDistance), call FUNC(getDirection)];
                "relative_distance" call _fnc_setPFH;
            };
        };

    };

    case ("distance"): {

        GVAR(isKeyDownDistance) = false;

        if (GVAR(isKeyDownAzimuth)) then {
            if (GVAR(currentMode) == "azimuth") then {
                ["distance"] call FUNC(clearDisplay);
                [true] call FUNC(showP1);
                GVAR(pData) = [call FUNC(getDistance), call FUNC(getDirection)];
                "relative_azimuth+distance" call _fnc_setPFH;
            };
        };

    };
};