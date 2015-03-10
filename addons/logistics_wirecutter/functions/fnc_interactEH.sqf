/*
 * Author: PabstMirror
 * When interact_menu starts rendering (from "interact_keyDown" event)
 *
 * Arguments:
 * Nothing
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [] call ace_logistics_wirecutter_fnc_interactEH
 *
 * Public: Yes
 */
#include "script_component.hpp"


//for performance only do stuff it they have a wirecutter item
//(if they somehow get one durring keydown they'll just have to reopen)
if (!("ACE_wirecutter" in (items ace_player))) exitWith {};

[{
    PARAMS_2(_args,_pfID);
    EXPLODE_3_PVT(_args,_setPosition,_addedHelpers,_fencesHelped);

    if (!EGVAR(interact_menu,keyDown)) then {
        {deleteVehicle _x;} forEach _addedHelpers;
        [_pfID] call CBA_fnc_removePerFrameHandler;
    } else {
        //If play moved >5 meters from last pos, then rescan
        if (((getPosASL ace_player) distance _setPosition) > 5) then {

            _fncStatement = {
                _attachedFence = _target getVariable [QGVAR(attachedFence), objNull];
                [ace_player, _attachedFence] call FUNC(cutDownFence);
            };
            _fncCondition = {
                _attachedFence = _target getVariable [QGVAR(attachedFence), objNull];
                ((!isNull _attachedFence) && {(damage _attachedFence) < 1} && {("ACE_wirecutter" in (items ace_player))})
            };

            {
                if (!(_x in _fencesHelped)) then {
                    if ([_x] call FUNC(isFence)) then {
                        _fencesHelped pushBack _x;
                        _helper = "Sign_Sphere25cm_F" createVehicleLocal (getpos _x);
                        [_helper, 0, [""], (localize "STR_ACE_logistics_wirecutter_CutFence"), QUOTE(PATHTOF(ui\wirecutter_ca.paa)), [0,0,0], _fncStatement, _fncCondition, 5] call EFUNC(interact_menu,addAction);
                        _helper setPosASL ((getPosASL _x) vectorAdd [0,0,1.25]);
                        _helper hideObject true;
                        _helper setVariable [QGVAR(attachedFence), _x];
                        _addedHelpers pushBack _helper;
                    };
                };
            } forEach nearestObjects [ace_player, [], 15];

            _args set [0, (getPosASL ace_player)];
        };
    };
}, 0.1, [((getPosASL ace_player) vectorAdd [-100,0,0]), [], []]] call CBA_fnc_addPerFrameHandler;
