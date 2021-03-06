/*
 * Author: bux578
 * Creates markers for AI units for given sides.
 *  Marks players in a different colour.
 *
 * Arguments:
 * 0: side <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[west, east]] call FUNC(markAiOnMap)
 *
 * Public: No
 */

#include "script_component.hpp"

private "_sidesToShow";
_sidesToShow = _this select 0;

GVAR(AllMarkerNames) = [];

DFUNC(pfhMarkAiOnMap) = {
    private ["_args", "_sides"];
    _args = _this select 0;
    _sides = _args select 0;


    // delete markers
    {
      deleteMarkerLocal _x;
    } forEach GVAR(AllMarkerNames);

    // reset the array
    GVAR(AllMarkerNames) = [];

    if (alive ACE_player && {GVAR(OriginalUnit) getVariable ["ACE_CanSwitchUnits", false]}) then {

        // create markers
        {
            if (([_x] call FUNC(isValidAi) && (side group _x in _sides)) || (_x getVariable [QGVAR(IsPlayerControlled), false])) then {
                private ["_markerName", "_marker", "_markerColor"];

                _markerName = str _x;

                _marker = createMarkerLocal [_markerName, position _x];
                _markerName setMarkerTypeLocal "mil_triangle";
                _markerName setMarkerShapeLocal "ICON";
                _markerName setMarkerSizeLocal [0.5,0.7];
                _markerName setMarkerDirLocal getDir _x;

                // commy's one liner magic
                _markerColor = format ["Color%1", side group _x];

                if ((_x getVariable [QGVAR(IsPlayerControlled), false])) then {
                    _markerName setMarkerColorLocal "ColorOrange";
                    _markerName setMarkerTextLocal (_x getVariable [QGVAR(PlayerControlledName), ""]);
                } else {
                    _markerName setMarkerColorLocal _markerColor;
                    _markerName setMarkerTextLocal (getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName"));
                };

                GVAR(AllMarkerNames) pushBack _markerName;
            };
        } forEach allUnits;
    };
};

[FUNC(pfhMarkAiOnMap), 1.5, [_sidesToShow]] call CBA_fnc_addPerFrameHandler;
