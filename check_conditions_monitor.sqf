/**
 * Regularly checks the conditions of the object pointed to by the weapon of the player
 * Allows you to decrease the frequency of audits of conditions normally made in the addaction 
 * The justification of this system is that the conditions are very complex (count, nearestobjects)and can eat up client speed
 * You can adjust the delay timer (_timer) to adjust the frequency, lower = faster = more demand on client
 * 
 * Copyright (C) 2014 OneManGang
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
private ["_current_target","_timer"];

diag_log ("PLM: (CONDITION_MONITOR) Initializing");
_timer = 0.5;


while {true} do
{
	PLM_object_addAction = objNull;
	
	_current_target = cursorTarget;
//	diag_log (format ["PLM: Current Target: *%1*",_current_target]);

	if !(isNull _current_target) then
	{
		//diag_log (format ["PLM: Current Target: *%1*",_current_target]);
		if (player distance _current_target < 13) then
		{
			PLM_object_addAction = _current_target;
			
			PLM_object_canLock = !(_current_target getVariable ['objectLocked', false]);
			//diag_log (format ["PLM: (PRE-CHECK) PLM_object_addAction: *%1*",PLM_object_addAction]);
			//diag_log (format ["PLM: (PRE-CHECK) PLM_object_canLock: *%1*",PLM_object_canLock]);

			// If the object is a movable object
			//diag_log (format ["PLM: PLM_CFG_moveable_objects: *%1*",PLM_CFG_moveable_objects]);

			if ({_current_target isKindOf _x} count PLM_CFG_moveable_objects > 0) then
			{
				//diag_log ("PLM: object is moveable");
				//diag_log (format ["PLM: (PRE-CHECK) PLM_object_can_be_moved: *%1*",PLM_object_can_be_moved]);


				// Condition action move_object
				PLM_object_can_be_moved = (vehicle player == player && (count crew _current_target == 0) && (isNull PLM_object_player_is_moving) &&
					(isNull (_current_target getVariable "PLM_object_being_moved_by") || (!alive (_current_target getVariable "PLM_object_being_moved_by"))) &&
					isNull (_current_target getVariable "PLM_is_transported_by") && !(_current_target getVariable "PLM_disabled"));
					
					/*
					diag_log (format ["PLM: (CONDITION CHECK) var0: *%1*",_current_target]);
					diag_log (format ["PLM: (CONDITION CHECK) var1: *%1*",(vehicle player == player)]);
					diag_log (format ["PLM: (CONDITION CHECK) var2: *%1*",(count crew _current_target)]);
					diag_log (format ["PLM: (CONDITION CHECK) var3: *%1*",(isNull PLM_object_player_is_moving)]);
					diag_log (format ["PLM: (CONDITION CHECK) var4: *%1*",(isNull (_current_target getVariable "PLM_object_being_moved_by"))]);
					diag_log (format ["PLM: (CONDITION CHECK) var5: *%1*",(!alive (_current_target getVariable "PLM_object_being_moved_by"))]);
					diag_log (format ["PLM: (CONDITION CHECK) var6: *%1*",(_current_target getVariable "PLM_is_transported_by")]);
					diag_log (format ["PLM: (CONDITION CHECK) var7: *%1*",(!(_current_target getVariable "PLM_disabled"))]);
					diag_log (format ["PLM: (CONDITION CHECK) var8: *%1*",PLM_object_being_moved_by]);
					
					diag_log (format ["PLM: (POST-CHECK) PLM_object_can_be_moved: *%1*",PLM_object_can_be_moved]);
					*/

			}
			else
			{
			//diag_log ("PLM: object is NOT moveable");
			};
			
			
			// If the object is a transportable
			if ({_current_target isKindOf _x} count PLM_transportable_classes > 0) then
			{
				
				//diag_log ("PLM: object is transportable");

				// And moveable
				if ({_current_target isKindOf _x} count PLM_CFG_moveable_objects > 0) then
				{
					//diag_log ("PLM: AND movable");
					//diag_log (format ["PLM: (PRE-CHECK) PLM_object_can_be_trans_moved: *%1*",PLM_object_can_be_trans_moved]);

					// Condition action charger_deplace
					PLM_object_can_be_trans_moved = (vehicle player == player && (count crew _current_target == 0) && (PLM_object_player_is_moving == _current_target) &&
						{_x != _current_target && alive _x && ([0,0,0] distance velocity _x < 6) && (getPos _x select 2 < 2) &&
						!(_x getVariable "PLM_disabled")} count (nearestObjects [_current_target, PLM_transporter_classes, 18]) > 0 &&
						!(_current_target getVariable "PLM_disabled"));
						//diag_log (format ["PLM: (POST CHECK) PLM_object_can_be_trans_moved: *%1*",PLM_object_can_be_trans_moved]);

				}
				
				else
				{
				//diag_log ("PLM: BUT NOT moveable");
				};
			}
			else
			{
			//diag_log ("PLM: object is NOT trasnportable");
			};
			//diag_log (format ["PLM: (PRE-CHECK) PLM_object_can_be_transported: *%1*",PLM_object_can_be_transported]);

			/*
					diag_log (format ["PLM: (CONDITION CHECK) var1: *%1* - *%2*",(vehicle player),player]);
					diag_log (format ["PLM: (CONDITION CHECK) var2: *%1*",(count crew _current_target)]);
					diag_log (format ["PLM: (CONDITION CHECK) var3: *%1*", PLM_object_player_is_moving]);
					diag_log (format ["PLM: (CONDITION CHECK) var4: *%1*",(_current_target getVariable "PLM_object_being_moved_by")]);
					diag_log (format ["PLM: (CONDITION CHECK) var5: *%1*",(alive (_current_target getVariable "PLM_object_being_moved_by"))]);
					diag_log (format ["PLM: (CONDITION CHECK) var6: *%1*",(_current_target getVariable "PLM_is_transported_by")]);
					diag_log (format ["PLM: (CONDITION CHECK) var7: *%1*",(_current_target getVariable "PLM_disabled")]);
			*/
			
			
				// Condition action select_object_load
				PLM_object_can_be_transported = (vehicle player == player && (count crew _current_target == 0) &&
					isNull PLM_object_player_is_moving && isNull (_current_target getVariable "PLM_is_transported_by") &&
					(isNull (_current_target getVariable "PLM_object_being_moved_by") || (!alive (_current_target getVariable "PLM_object_being_moved_by"))) &&
					!(_current_target getVariable "PLM_disabled"));
			//diag_log (format ["PLM: (POST CHECK) PLM_object_can_be_transported: *%1*",PLM_object_can_be_transported]);

			};
			
			// If object is an object tranporter
			if ({_current_target isKindOf _x} count PLM_transporter_classes > 0) then
			{
				//diag_log ("PLM: object is a transporter");



				// Condition action trans_move (transportable and moveablee)
				PLM_object_can_be_trans_moved = (alive _current_target && (vehicle player == player) && (!isNull PLM_object_player_is_moving) &&
					!(PLM_object_player_is_moving getVariable "PLM_disabled") &&
					({PLM_object_player_is_moving isKindOf _x} count PLM_transportable_classes > 0) &&
					([0,0,0] distance velocity _current_target < 6) && (getPos _current_target select 2 < 2) && 
					!(_current_target getVariable "PLM_disabled"));
				
				// Condition action can_be_loaded (transportable)
				PLM_object_can_be_loaded = (alive _current_target && (vehicle player == player) && (isNull PLM_object_player_is_moving) &&
					(!isNull PLM_current_object_selected) && (PLM_current_object_selected != _current_target) &&
					!(PLM_current_object_selected getVariable "PLM_disabled") &&
					({PLM_current_object_selected isKindOf _x} count PLM_transportable_classes > 0) &&
					([0,0,0] distance velocity _current_target < 6) && (getPos _current_target select 2 < 2) && 
					!(_current_target getVariable "PLM_disabled"));
				
				// Vehicle is a transport and can view contents
				PLM_can_view_vehicle_content = (alive _current_target && (vehicle player == player) && (isNull PLM_object_player_is_moving) &&
					([0,0,0] distance velocity _current_target < 6) && (getPos _current_target select 2 < 2) && !(_current_target getVariable "PLM_disabled"));
					
					
					/*
					diag_log (format ["PLM: PLM_object_can_be_trans_moved: *%1*",PLM_object_can_be_trans_moved]);
					diag_log (format ["PLM: PLM_object_can_be_loaded: *%1*",PLM_object_can_be_loaded]);
					diag_log (format ["PLM: PLM_can_view_vehicle_content: *%1*",PLM_can_view_vehicle_content]);
					*/

			};
		};
//	};
	
	sleep _timer;
};