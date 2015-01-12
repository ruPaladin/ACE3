/**
 * fn_defineVariable.sqf
 * @Descr: Define a variable for the CSE variable framework
 * @Author: Glowbal
 *
 * @Arguments: [name STRING, defaultValue ANY, publicFlag BOOL, category STRING, type NUMBER, persistentFlag BOOL]
 * @Return:
 * @PublicAPI: true
 */

private ["_name","_value","_defaultGlobal","_catagory","_code","_persistent"];
_name = _this select 0;
_value = _this select 1;
_defaultGlobal = _this select 2;
_catagory = _this select 3;
_code = 0;
_persistent = false;

if (count _this < 3) exitwith {};
if (count _this > 4) then {
	_code = _this select 4;
	if (count _this > 5) then {
		_persistent = _this select 5;
	};
};

if (typeName _name != typeName "") then {
	throw "IllegalArgument";
};

if (isnil 'CSE_OBJECT_VARIABLES_STORAGE') then {
	CSE_OBJECT_VARIABLES_STORAGE = [];
};

CSE_OBJECT_VARIABLES_STORAGE pushback [_name,_value,_defaultGlobal,_catagory,_code, _persistent];

missionNamespace setvariable ["cse_object_variables_storage_" + _name, [_name,_value,_defaultGlobal,_catagory,_code, _persistent]];

[[_name,_value,_defaultGlobal,_catagory,_code, _persistent],"variableDefined"] call cse_fnc_customEventHandler_F;