/**
 * Load the selected object (PLM_current_object_selected) in a carrier
 * 
 * @param 0 the transporting vehicle
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
	
	_object = PLM_current_object_selected;
	_transport_vehicle = _this select 0;
	
	if (!(isNull _object) && !(_object getVariable "PLM_disabled")) then
	{
		if (isNull (_object getVariable "PLM_is_transported_by") && (isNull (_object getVariable "PLM_object_being_moved_by") || (!alive (_object getVariable "PLM_object_being_moved_by")))) then
		{
			private ["_loaded_objects", "_current_load", "_current_object_weight", "_max_capacity"];
			
			_loaded_objects = _transport_vehicle getVariable "PLM_loaded_objects";
			
			// Calcul du chargement actuel
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
			
			// Recherche de la capacité de l'objet
			_current_object_weight = 99999;
			for [{_i = 0}, {_i < count PLM_CFG_transportable_objects}, {_i = _i + 1}] do
			{
				if (_object isKindOf (PLM_CFG_transportable_objects select _i select 0)) exitWith
				{
					_current_object_weight = (PLM_CFG_transportable_objects select _i select 1);
				};
			};
			
			// Recherche de la capacité maximale du transporteur
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
				if (_object distance _transport_vehicle <= 30) then
				{
					// It is stored on the network the new contents of the vehicle
					_loaded_objects = _loaded_objects + [_object];
					_transport_vehicle setVariable ["PLM_loaded_objects", _loaded_objects, true];
					
					player globalChat "Loading in progress...";
					
					sleep 2;
					
					// Choisir une position dégagée (sphère de 50m de rayon) dans le ciel dans un cube de 9km^3
					private ["_nb_tirage_pos", "_position_attache"];
					_position_attache = [random 3000, random 3000, (10000 + (random 3000))];
					_nb_tirage_pos = 1;
					while {(!isNull (nearestObject _position_attache)) && (_nb_tirage_pos < 25)} do
					{
						_position_attache = [random 3000, random 3000, (10000 + (random 3000))];
						_nb_tirage_pos = _nb_tirage_pos + 1;
					};
					
					_object attachTo [PLM_PUBVAR_attach_point, _position_attache];
					
					PLM_current_object_selected = objNull;
					
					player globalChat format ["The object %1 has been loaded in the vehicle.", getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
				}
				else
				{
					player globalChat format ["The object %1 is too far from the vehicle to be loaded.", getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
				};
			}
			else
			{
				player globalChat format ["There is not enough space in this vehicle. Space left: %1, Required: %2", (_max_capacity - _current_load), _current_object_weight];
			};
		}
		else
		{
			player globalChat format ["The object %1 is in transit.", getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
		};
	};
	
	PLM_player_in_action = false;
};