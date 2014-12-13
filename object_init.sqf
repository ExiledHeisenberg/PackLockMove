/**
 * Initializes a movable object
 * 
 * @param 0 The object being initalized
 * 
 * Copyright (C) 2014 OneManGang
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

//diag_log ("PLM: (OBJECT MOVE) Initializing");

private ["_object", "_is_disabled", "_is_transported_by", "_is_moved_by", "_objectState", "_doLock", "_doUnlock","_currentAnim","_config","_onLadder"];

_object = _this select 0;

_doLock = 0;
_doUnlock = 1;

_is_disabled = _object getVariable "PLM_disabled";

if (isNil "_is_disabled") then
{
	_object setVariable ["PLM_disabled", false];
};

//diag_log (format ["PLM: (OBJECT MOVE) Object is disabled: *%1*",_is_disabled]);

// Local Definition of the variable if it is not defined on the network
_is_transported_by = _object getVariable "PLM_is_transported_by";

if (isNil "_is_transported_by") then
{
	_object setVariable ["PLM_is_transported_by", objNull, false];
};

//diag_log (format ["PLM: (OBJECT MOVE) Object is transported by: *%1*",_is_transported_by]);

// Local Definition of the variable if it is not defined on the network
_is_moved_by = _object getVariable "PLM_object_being_moved_by";
if (isNil "_is_moved_by") then
{
	_object setVariable ["PLM_object_being_moved_by", objNull, false];
};

//diag_log (format ["PLM: (OBJECT MOVE) Object is being moved by: *%1*",_is_moved_by]);


// Do not mount in a vehicle which is beig moved
_object addEventHandler ["GetIn",
{
	if (_this select 2 == player) then
	{
		_this spawn
		{
			if ((!(isNull (_this select 0 getVariable "PLM_object_being_moved_by")) && 
			(alive (_this select 0 getVariable "PLM_object_being_moved_by"))) || !(isNull (_this select 0 getVariable "PLM_is_transported_by"))) then
			{
				player action ["eject", _this select 0];
				player globalChat "This vehicle is being transported";
			};
		};
	};
}];



if ({_object isKindOf _x} count PLM_CFG_moveable_objects > 0) then
{
	//diag_log (format ["PLM: (OBJECT MOVE) Object lock state: *%1*",(_target getVariable ['objectLocked', false])]);
	//diag_log (format ["PLM: (OBJECT MOVE) Object can be locked: *%1*",PLM_object_canLock]);

	_object addAction [("<t color=""#dddd00"">" + "Move this object" + "</t>"), "PLM\move_object\moveObject.sqf", nil, 5, false, true, "", "PLM_object_addAction == _target && PLM_object_can_be_moved && !(_target getVariable ['objectLocked', false])"];
	_object addAction [("<t color=""#21DE31"">" + "Lock this object" + "</t>"), "PLM\move_object\toggleLockState.sqf", _doLock, -5, false, true, "", "PLM_object_addAction == _target && PLM_object_can_be_moved && PLM_object_canLock && PLM_GVAR_objects_lockable"];
	_object addAction [("<t color=""#E01B1B"">" + "Unlock this object" + "</t>"), "PLM\move_object\toggleLockState.sqf", _doUnlock, -5, false, true, "", "PLM_object_addAction == _target && PLM_object_can_be_moved && !PLM_object_canLock && PLM_GVAR_objects_lockable"];
};

if ({_object isKindOf _x} count PLM_transportable_classes > 0) then
{
	//diag_log (format ["PLM: (OBJECT MOVE) Object is transportable: *%1*",_object]);

	if ({_object isKindOf _x} count PLM_CFG_moveable_objects > 0) then
	{
		//diag_log (format ["PLM: (OBJECT MOVE) AND object is movable: *%1*",_object]);

		_object addAction [("<t color=""#dddd00"">" + "Load in the vehicle" + "</t>"), "PLM\transport\load_in_vehicle.sqf", nil, 6, true, true, "", "PLM_object_addAction == _target && PLM_object_can_be_trans_moved"];
	};
	//diag_log (format ["PLM: (OBJECT MOVE) BUT NOT movable: *%1*",_object]);

	
	_object addAction [("<t color=""#dddd00"">" + "Load in..." + "</t>"), "PLM\transport\select_object.sqf", nil, 5, false, true, "", "PLM_object_addAction == _target && PLM_object_can_be_transported && PLM_object_canLock"];
};