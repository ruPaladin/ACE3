/**
 * fn_sortAlphabeticallyBy.sqf
 * @Descr:
 * @Author: Glowbal
 *
 * @Arguments: []
 * @Return:
 * @PublicAPI: true
 */

#include "script_component.hpp"

private ["_elements","_indexes", "_theElement", "_tmp", "_tempIndex", "_j", "_i", "_returnArray"];

params ["_array","_elementN"];

_indexes = [];
_elements = [];

{
    _theElement = toArray (_x select _elementN);
    _indexes pushback _foreachIndex;
    _elements pushback _theElement;
} forEach _array;

for "_i" from 1 to (count _elements) - 1 do {
    _tmp = _elements select _i;
    _tempIndex = _indexes select _i;
    _j = _i;
    while {_j >= 1 && {_tmp < _elements select (_j - 1)}} do {
        _elements set [_j, _elements select (_j - 1)];
        _indexes set [_j, _indexes select (_j - 1)];
        _j = _j - 1;
    };
    _elements set[_j, _tmp];
    _indexes set [_j, _tempIndex];
};

_returnArray = [];
{
    _returnArray pushback (_array select _x);
} forEach _indexes;

_returnArray;
