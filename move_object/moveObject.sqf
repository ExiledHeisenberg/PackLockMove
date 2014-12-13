/**
 * Move/lock an object by the player. It keeps the object as long as he does not release or does not die.
 * The object is released when the variable PLM_object_player_is_moving past to objnull which will complete the script* 
 
 * @param 0 Object being moved
 * 
 * Copyright (C) 2014 OneManGang
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

if (!PLM_GVAR_move_on_ladder) then
	{
	_currentAnim =	animationState player;
	_config = configFile >> "CfgMovesMaleSdr" >> "States" >> _currentAnim;
	_onLadder =	(getNumber (_config >> "onLadder"));
	if(_onLadder == 1) exitWith{player globalChat "You can't move this object while on a ladder";};
	};

if (PLM_player_in_action) then
	{
	player globalChat "The current operation isn't finished.";
	}
else
	{
		PLM_player_in_action = true;
	
		PLM_current_object_selected = objNull;
	
		private ["_oldObjectID","_oldObjectUID","_oldObject","_object", "_primary_weapon", "_action_menu_release_relative", "_action_menu_release_horizontal" , "_action_menu_45", "_action_menu_90", "_action_menu_180", "_item_direction"];
	
		_object = _this select 0;
		_object setVariable ["PLM_object_being_moved_by", player, true];
		_oldObjectID = _object getVariable["ObjectID","0"];
		_oldObjectUID = _object getVariable["ObjectUID","0"];
		_oldObject = _object;

		
		PLM_object_player_is_moving = _object;
		
		// Backup and removal of the primary weapon
		_primary_weapon = primaryWeapon player;
		if (_primary_weapon != "") then
		{
			player playMove "AidlPercMstpSnonWnonDnon04";
			sleep 1.5;
			player removeWeapon _primary_weapon;
		}
		else {sleep 0.5;};
		
		// If the player is killed during this process it returns everything as before
		if (!alive player) then
		{
			PLM_object_player_is_moving = objNull;
			_object setVariable ["PLM_object_being_moved_by", objNull, true];
			// Because attachto of "load" positioned the object at certain heights
			_object setPos [getPos _object select 0, getPos _object select 1, 0];
			_object setVelocity [0, 0, 0];
			
			PLM_player_in_action = false;
		}
		else
		{
			_object attachTo [player, [
				0,
				(((boundingBox _object select 1 select 1) max (-(boundingBox _object select 0 select 1))) max ((boundingBox _object select 1 select 0) max (-(boundingBox _object select 0 select 0)))) + 1,
				1]
			];
			
			if (count (weapons _object) > 0) then
			{
				// The item must rotated in front of the player (otherwise we have the impression of being impaled)
				_item_direction = ((_object weaponDirection (weapons _object select 0)) select 0) atan2 ((_object weaponDirection (weapons _object select 0)) select 1);
				
				// Adjust direction of item
				PLM_PUBVAR_setDir = [_object, (getDir _object)-_item_direction];
				if (isServer) then
				{
					["PLM_PUBVAR_setDir", PLM_PUBVAR_setDir] spawn PLM_FNCT_PUBVAR_setDir;
				}
				else
				{
					publicVariable "PLM_PUBVAR_setDir";
				};
			};
			
			PLM_player_in_action = false;
			PLM_force_horizontal = false;
			
			_action_menu_release_relative = player addAction [("<t color=""#21DE31"">" + "Release the object" + "</t>"), "PLM\move_object\release_object.sqf", false, 5, true, true];
			_action_menu_release_horizontal = player addAction [("<t color=""#21DE31"">" + "Release the object horizontally" + "</t>"), "PLM\move_object\release_object.sqf", true, 5, true, true];
			_action_menu_45 = player addAction [("<t color=""#dddd00"">Rotate object 45°</t>"), "PLM\move_object\rotate.sqf", 45, 5, true, true];
			_action_menu_90 = player addAction [("<t color=""#dddd00"">Rotate object 90°</t>"), "PLM\move_object\rotate.sqf", 90, 5, true, true];
			_action_menu_180 = player addAction [("<t color=""#dddd00"">Rotate object 180°</t>"), "PLM\move_object\rotate.sqf", 180, 5, true, true];
			
			// You cannot enter a vehicle or move too fast while carrying objects
			while {!isNull PLM_object_player_is_moving && alive player} do
			{
				if (vehicle player != player) then
				{
					player globalChat "You can't get in a vehicle while you're carrying this object !";
					player action ["eject", vehicle player];
					sleep 1;
				};
				
				if ([0,0,0] distance (velocity player) > 2.8) then
				{
					player globalChat "You're walking too fast ! (Hold the shift key to slow down)";

					if((currentWeapon player) in PLM_GVAR_sidearms)
					then {player playMove "amovpercmstpsraswpstdnon_amovppnemstpsraswpstdnon";} else {player playMove "AmovPpneMstpSnonWnonDnon"};

					sleep 1;
				};
				
				sleep 0.25;
			};
			
			// The object is no longer being carried
			detach _object;
			if(PLM_force_horizontal) then {
				PLM_force_horizontal = false;

				_opos = getPosASL _object;
				_ppos = getPosASL player;
				_opos set [2, _ppos select 2];
				_opos2 = +_opos;
				_opos2 set [2, (_opos2 select 2) - 1];
				if(terrainIntersectASL [_opos, _opos2]) then {
					_object setPosATL [getPosATL _object select 0, getPosATL _object select 1, getPosATL player select 2];
				} else {
					_object setPosASL _opos;
				};
			} else {
				if((getPosATL player select 2) < 5) then {
					_object setPos [getPos _object select 0, getPos _object select 1, getPosATL player select 2];
				} else {
					_object setPosATL [getPosATL _object select 0, getPosATL _object select 1, getPosATL player select 2];
				};
			};
			
			_object setVelocity [0, 0, 0];
			
			_dir= getDir _object;
			_location= getPos _object;
			_classname= typeOf _object;
			
			PVDZE_obj_Delete = [_oldObjectID,_oldObjectUID];
			publicVariableServer "PVDZE_obj_Delete";
			if (isServer) then {
				PVDZE_obj_Delete call server_deleteObj;
			};
			
			PVDZE_obj_Publish = [0,_object,[_dir,_location],_classname];
			publicVariableServer "PVDZE_obj_Publish";
			
			player removeAction _action_menu_release_relative;
			player removeAction _action_menu_release_horizontal;
			player removeAction _action_menu_45;
			player removeAction _action_menu_90;
			player removeAction _action_menu_180;
			PLM_object_player_is_moving = objNull;
			
			_object setVariable ["PLM_object_being_moved_by", objNull, true];
			
			// Restore primary weapon
			if (alive player && _primary_weapon != "") then
			{
				if(primaryWeapon player != "") then {
					_o = createVehicle ["WeaponHolder", player modelToWorld [0,0,0], [], 0, "NONE"];
					_o addWeaponCargoGlobal [_primary_weapon, 1];
				} else {
					player addWeapon _primary_weapon;
					player selectWeapon _primary_weapon;
					player selectWeapon (getArray (configFile >> "cfgWeapons" >> _primary_weapon >> "muzzles") select 0);
				};
			};
		};
	};
