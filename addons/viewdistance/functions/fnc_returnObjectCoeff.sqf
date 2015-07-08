/*
 * Author: Winter
 * Returns the object view distance coefficient according to the given index
 *
 *
 * Arguments:
 * 0: Object View Distance setting Index <SCALAR>
 *
 * Return Value:
 * Object View Distance <SCALAR>
 *
 * Example:
 * [2] call ace_viewdistance_fnc_returnObjectCoeff;
 *
 * Public: No
 */

#include "script_component.hpp"

params ["_index"];

private ["_return"];

_return = switch (_index) do {
    case 0: {0.00}; // Off
    case 1: {0.20}; // Very Low
    case 2: {0.40}; // Low
    case 3: {0.60}; // Medium
    case 4: {0.80}; // High
    case 5: {1.00}; // Very High
    default {0.50}; // something broke if this returns
};

_return;
