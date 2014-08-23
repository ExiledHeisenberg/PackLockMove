/**
 * Load the object moves by the player in a carrier
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

if (PLM_player_in_action) then
{
	player globalChat "The current operation isn't finished.";
}
else
{
	PLM_player_in_action = true;
	
	private ["_object", "_classes_transport_vehicles", "_transport_vehicle", "_i"];
	
	_object = PLM_object_player_is_moving;
	
	_transport_vehicle = nearestObjects [_object, PLM_transporter_classes, 22];
	// Because the carrier may be a transportable object
	_transport_vehicle = _transport_vehicle - [_object];
	
	if (count _transport_vehicle > 0) then
	{
		_transport_vehicle = _transport_vehicle select 0;
		
		if (alive _transport_vehicle && ([0,0,0] distance velocity _transport_vehicle < 6) && (getPos _transport_vehicle select 2 < 2) && !(_transport_vehicle getVariable "PLM_disabled")) then
		{
			private ["_loaded_objects", "_current_load", "_current_object_weight", "_max_capacity"];
			
			_loaded_objects = _transport_vehicle getVariable "PLM_loaded_objects";
			
			// Calculation of the current load
			_current_load = 0;
			{
				for [{_i = 0}, {_i < count PLM_CFG_transportable_objects}, {_i = _i + 1}] do
				{
					if (_x isKindOf (PLM_CFG_transportable_objects select _i select 0)) exitWith
					{
						_current_load = _current_load + (PLM_CFG_transportable_objects select _i select 1);
					};
				};
			} forEach _loaded_objects;
			
			// Search for the ability of the object
			_current_object_weight = 99999;
			for [{_i = 0}, {_i < count PLM_CFG_transportable_objects}, {_i = _i + 1}] do
			{
				if (_object isKindOf (PLM_CFG_transportable_objects select _i select 0)) exitWith
				{
					_current_object_weight = (PLM_CFG_transportable_objects select _i select 1);
				};
			};
			
			// Search for the maximum capacity of the carrier
			_max_capacity = 0;
			for [{_i = 0}, {_i < count PLM_CFG_transporters}, {_i = _i + 1}] do
			{
				if (_transport_vehicle isKindOf (PLM_CFG_transporters select _i select 0)) exitWith
				{
					_max_capacity = (PLM_CFG_transporters select _i select 1);
				};
			};
			
			// If the object can be loaded in the vehicle
			if (_current_load + _current_object_weight <= _max_capacity) then
			{
				// It is stored on the network the new contents of the vehicle
				_loaded_objects = _loaded_objects + [_object];
				_transport_vehicle setVariable ["PLM_loaded_objects", _loaded_objects, true];
				
				player globalChat "Loading in progress...";
				
				// To release the object to the player (if it was in "the hands")
				PLM_object_player_is_moving = objNull;
				sleep 2;
				
				// Choose a disengaged position (sphere of 50m radius) in the sky in a cube of 9km^3
				private ["_nb_tirage_pos", "_attatchto_position"];
				_attatchto_position = [random 3000, random 3000, (10000 + (random 3000))];
				_nb_tirage_pos = 1;
				while {(!isNull (nearestObject _attatchto_position)) && (_nb_tirage_pos < 25)} do
				{
					_attatchto_position = [random 3000, random 3000, (10000 + (random 3000))];
					_nb_tirage_pos = _nb_tirage_pos + 1;
				};
				
				_object attachTo [PLM_PUBVAR_attach_point, _attatchto_position];
				
				player globalChat format ["The object has been loaded in the vehicle %1.", getText (configFile >> "CfgVehicles" >> (typeOf _transport_vehicle) >> "displayName")];
			}
			else
			{
				player globalChat "There is not enough space in this vehicle.";
			};
		};
	};
	
	PLM_player_in_action = false;
};