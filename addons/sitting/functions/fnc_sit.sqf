/*
 * Author: Jonpas
 * Sits down the player.
 *
 * Arguments:
 * 0: Seat <OBJECT>
 * 1: Player <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [seat, player] call ace_sitting_fnc_sit;
 *
 * Public: No
 */
#include "script_component.hpp"

private ["_configFile", "_sitDirection", "_sitPosition", "_sitRotation", "_sitDirectionVisual"];

params ["_seat","_player"];

// Set global variable for standing up
GVAR(seat) = _seat;

// Overwrite weird position, because Arma decides to set it differently based on current animation/stance...
_player switchMove "amovpknlmstpsraswrfldnon";

// Read config
_configFile = configFile >> "CfgVehicles" >> typeOf _seat;
_sitDirection = (getDir _seat) + getNumber (_configFile >> QGVAR(sitDirection));
_sitPosition = getArray (_configFile >> QGVAR(sitPosition));
_sitRotation = if (isNumber (_configFile >> QGVAR(sitRotation))) then {getNumber (_configFile >> QGVAR(sitRotation))} else {45}; // Apply default if config entry not present

// Get random animation and perform it (before moving player to ensure correct placement)
[_player, call FUNC(getRandomAnimation), 2] call EFUNC(common,doAnimation);

// Set direction and position
_player setDir _sitDirection;
_player setPosASL (_seat modelToWorld _sitPosition) call EFUNC(common,positionToASL);

// Set variables
_player setVariable [QGVAR(isSitting), true];
_seat setVariable [QGVAR(seatOccupied), true, true]; // To prevent multiple people sitting on one seat

// Add rotation control PFH
_sitDirectionVisual = getDirVisual _player; // Needed for precision and issues with using above directly
[{
    EXPLODE_3_PVT(_this select 0,_player,_sitDirectionVisual,_sitRotation);

    // Remove PFH if not sitting any more
    if !(_player getVariable [QGVAR(isSitting), false]) exitWith {
        [_this select 1] call cba_fnc_removePerFrameHandler;
    };

    // Set direction to boundary when passing it
    if (getDir _player > _sitDirectionVisual + _sitRotation) exitWith {
        _player setDir (_sitDirectionVisual + _sitRotation);
    };
    if (getDir _player < _sitDirectionVisual - _sitRotation) exitWith {
        _player setDir (_sitDirectionVisual - _sitRotation);
    };
}, 0, [_player, _sitDirectionVisual, _sitRotation]] call cba_fnc_addPerFrameHandler;
