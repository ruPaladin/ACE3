/*
 * Author: PabstMirror
 * Changes the display mode of the microDAGR
 *
 * Arguments:
 * 0: Display Mode to show the microDAGR in <NUMBER><OPTIONAL>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [1] call ace_microdagr_fnc_openDisplay
 *
 * Public: No
 */
#include "script_component.hpp"

private ["_oldShowMode", "_args", "_pfID", "_player"];

_newDisplayShowMode = param [0,-1];
_oldShowMode = GVAR(currentShowMode);

if (_newDisplayShowMode == -1) then {
    //Toggle mode button:
    if (_oldShowMode in [DISPLAY_MODE_DISPLAY, DISPLAY_MODE_HIDDEN]) then {_newDisplayShowMode = DISPLAY_MODE_DIALOG};
    if (_oldShowMode in [DISPLAY_MODE_DIALOG, DISPLAY_MODE_CLOSED]) then {_newDisplayShowMode = DISPLAY_MODE_DISPLAY};
};

if ((_newDisplayShowMode == DISPLAY_MODE_DISPLAY) && {!([DISPLAY_MODE_DISPLAY] call FUNC(canShow))}) then {_newDisplayShowMode = DISPLAY_MODE_HIDDEN};
if ((_newDisplayShowMode == DISPLAY_MODE_DIALOG) && {!([DISPLAY_MODE_DIALOG] call FUNC(canShow))}) then {_newDisplayShowMode = DISPLAY_MODE_HIDDEN};



//On first-startup
if (GVAR(currentApplicationPage) == APP_MODE_NULL) then {
    GVAR(currentApplicationPage) = APP_MODE_INFODISPLAY;
    GVAR(mapPosition) = getPos ace_player;
};

if (_newDisplayShowMode in [DISPLAY_MODE_CLOSED, DISPLAY_MODE_HIDDEN]) then {

    //If Dialog is open, back it up before closing:
    if (dialog && {!isNull (uiNamespace getVariable [QGVAR(DialogDisplay), displayNull])}) then {
        [-1] call FUNC(saveCurrentAndSetNewMode);
        closeDialog 0;
    };

    //Close the display:
    (QGVAR(TheRscTitleDisplay) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
} else {
    if (_newDisplayShowMode == DISPLAY_MODE_DISPLAY) then {
        //If Dialog is open, back it up before closing:
        if (dialog && {!isNull (uiNamespace getVariable [QGVAR(DialogDisplay), displayNull])}) then {
            [-1] call FUNC(saveCurrentAndSetNewMode);
            closeDialog 0;
        };
        //Open the display:
        (QGVAR(TheRscTitleDisplay) call BIS_fnc_rscLayer) cutRsc [QGVAR(TheRscTitleDisplay), "PLAIN", 0, true];
    } else { //DISPLAY_MODE_DIALOG
        //Close the display:
        (QGVAR(TheRscTitleDisplay) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
        //Open the dialog:
        createDialog QGVAR(TheDialog);
    };
};

GVAR(currentShowMode) = _newDisplayShowMode;
//Update display applicaiton if open:
if (GVAR(currentShowMode) in [DISPLAY_MODE_DIALOG, DISPLAY_MODE_DISPLAY]) then {
    [] call FUNC(showApplicationPage);
};

if ((_oldShowMode == DISPLAY_MODE_CLOSED) && {GVAR(currentShowMode) != DISPLAY_MODE_CLOSED}) then {
    //Start a pfeh to update display and handle hiding display

    [{
        params ["_args","_pfID"];
        EXPLODE_1_PVT(_args,_player);
        if ((isNull ace_player) || {!alive ace_player} || {ace_player != _player} || {!("ACE_microDAGR" in (items ace_player))} || {GVAR(currentShowMode) == DISPLAY_MODE_CLOSED}) then {
            //Close Display if still open:
            if (GVAR(currentShowMode) != DISPLAY_MODE_CLOSED) then {
                [DISPLAY_MODE_CLOSED] call FUNC(openDisplay);
            };
            [_pfID] call CBA_fnc_removePerFrameHandler;
        } else {
            if (GVAR(currentShowMode) == DISPLAY_MODE_HIDDEN) then {
                //If display is hidden, and we can show, then swithc modes:
                if ([DISPLAY_MODE_DISPLAY] call FUNC(canShow)) then {
                    [DISPLAY_MODE_DISPLAY] call FUNC(openDisplay);
                };
            } else {
                if ([GVAR(currentShowMode)] call FUNC(canShow)) then {
                    [] call FUNC(updateDisplay);
                } else {
                    [DISPLAY_MODE_HIDDEN] call FUNC(openDisplay);
                };
            };
        };
    }, 0.1, [ace_player]] call CBA_fnc_addPerFrameHandler;
};
