/**
 * Unload an object of a carrier - called quote the interface listing the contents of the carrier
 * 
 * Copyright (C) 2014 OneMnGang
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
	
	#include "dlg_constants.h"
	private ["_transport_vehicle", "_loaded_objects", "_type_object_to_unload", "_object_to_unload", "_i"];
	
	_transport_vehicle = uiNamespace getVariable "PLM_dlg_CV_transport_vehicle";
	_loaded_objects = _transport_vehicle getVariable "PLM_loaded_objects";
	
	_type_object_to_unload = lbData [PLM_IDC_dlg_VC_contents, lbCurSel PLM_IDC_dlg_VC_contents];
	
	closeDialog 0;
	
	// Search for an object of the requested type
	_object_to_unload = objNull;
	for [{_i = 0}, {_i < count _loaded_objects}, {_i = _i + 1}] do
	{
		if (typeOf (_loaded_objects select _i) == _type_object_to_unload) exitWith
		{
			_object_to_unload = _loaded_objects select _i;
		};
	};
	
	if !(isNull _object_to_unload) then
	{
		// Remove the object from vehicle inventory
		_loaded_objects = _loaded_objects - [_object_to_unload];
		_transport_vehicle setVariable ["PLM_loaded_objects", _loaded_objects, true];
		
		detach _object_to_unload;
		
		if ({_object_to_unload isKindOf _x} count PLM_CFG_moveable_objects > 0) then
		{
			[_object_to_unload] execVM "PLM\move_object\moveObject.sqf";
		}
		else
		{
			private ["_dimension_max"];
			_dimension_max = (((boundingBox _object_to_unload select 1 select 1) max (-(boundingBox _object_to_unload select 0 select 1))) max ((boundingBox _object_to_unload select 1 select 0) max (-(boundingBox _object_to_unload select 0 select 0))));
			
			player globalChat "Unloading in progress...";
			
			sleep 2;
			
			// We asked the object at random toward the rear of the carrier
			_object_to_unload setPos [
				(getPos _transport_vehicle select 0) - ((_dimension_max+5+(random 10)-(boundingBox _transport_vehicle select 0 select 1))*sin (getDir _transport_vehicle - 90+random 180)),
				(getPos _transport_vehicle select 1) - ((_dimension_max+5+(random 10)-(boundingBox _transport_vehicle select 0 select 1))*cos (getDir _transport_vehicle - 90+random 180)),
				0
			];
			_object_to_unload setVelocity [0, 0, 0];
			
			player globalChat "The object has been unloaded from the vehicle.";
		};
	}
	else
	{
		player globalChat "The object has already been unloaded.";
	};
	
	PLM_player_in_action = false;
};