/*
 * Author: commy2
 * Called on unit initialization. Adds earplugs if the unit is equipped with either a really loud primary weapon or a rocket launcher.
 *
 * Arguments:
 * 0: A Soldier <Object>
 *
 * Return Value:
 * None
 *
 * Example:
 * [guy] call ace_hearing_fnc_addEarPlugs
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];

// Exit if hearing is disabled or soldier has earplugs already in (persistence scenarios)
if (!GVAR(enableCombatDeafness) || {[_unit] call FUNC(hasEarPlugsIn)}) exitWith {};

private ["_launcher"];

// add earplugs if the soldier has a rocket launcher
_launcher = secondaryWeapon _unit;

if (_launcher != "") exitWith {
    _unit addItem "ACE_EarPlugs";
};

// otherwise add earplugs if the soldier has a big rifle
private ["_magazine", "_ammo"];

_magazine = primaryWeaponMagazine _unit select 0;

if (isNil "_magazine") exitWith {};

_ammo = getText (configFile >> "CfgMagazines" >> _magazine >> "ammo");

if (getNumber (configFile >> "CfgAmmo" >> _ammo >> "audiblefire") > 8) then {
    _unit addItem "ACE_EarPlugs";
};
