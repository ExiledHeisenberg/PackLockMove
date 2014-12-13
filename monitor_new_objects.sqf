/**
 * Periodically scans for new objects and intialize if needed
 * 
 * Copyright (C) 2014 OneManGang
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
diag_log ("PLM: (MONITOR NEW) Monitor starting");

//Wait for it....
sleep .1;

private ["_count_valid_objects","_list_of_valid_objects", "_list_of_vehicles_initialized", "_vehicle_list", "_count_vehicle_list", "_i", "_object"];

// Union of tables of types of objects used in a iskindof
_list_of_valid_objects = PLM_CFG_moveable_objects + PLM_transportable_classes;
_count_valid_objects = count _list_of_valid_objects;
diag_log (format ["PLM: (MONITOR NEW) Number of objects found: *%1*",_count_valid_objects]);
 
// Will Contain the list of vehicles (and objects) already initialized
_list_of_vehicles_initialized = [];

while {true} do
{
	if !(isNull player) then
	{

		// Initialize vehicles and the new objects deriving from "Static" near the player
		_vehicle_list = (vehicles + nearestObjects [player, ["Static"], 80]) - _list_of_vehicles_initialized;
		_count_vehicle_list = count _vehicle_list;

		diag_log (format ["PLM: (MONITOR NEW) Uninitialized vehicles in area: *%1*",_count_vehicle_list]);

		
		if (_count_vehicle_list > 0) then
		{

			// It browses all the vehicles in the area every 10 seconds
			for [{_i = 0}, {_i < _count_vehicle_list}, {_i = _i + 1}] do
			{
				_object = _vehicle_list select _i;
				

				// If the object is a movable/transportable object
				if ({_object isKindOf _x} count _list_of_valid_objects > 0) then
				{
					//diag_log (format ["PLM: (MONITOR_NEW) Initializing object: *%1*",_object]);

					[_object] spawn PLM_FNCT_object_init;
				};

				
				// If the object is a transporter vehicle
				if ({_object isKindOf _x} count PLM_transporter_classes > 0) then
				{
					//diag_log (format ["PLM: (MONITOR_NEW) Transporter unit found: *%1*",_object]);

					[_object] spawn PLM_FNCT_transport_init;
				};
				
				
				sleep (10/_count_vehicle_list);
			};
			
			// After an object has been initialized, they are stored to avoid being re-initialized
			_list_of_vehicles_initialized = _list_of_vehicles_initialized + _vehicle_list;
		}
		else
		{
			sleep 10;
		};
	}
	else
	{
		sleep 2;
	};
};