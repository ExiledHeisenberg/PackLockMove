/**
 * Script to allow packing, load and move objects into vehicles or aroudn the map
 Dissected from R3F_ARTY_AND_LOG script
 Translated and cleaned up by OneManGang
 * 
 * Copyright (C) 2014 OneManGang
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
diag_log ("PLM: Script starting");
#include "config.sqf"


if (isServer) then
	{
		// Service run on the server: orient an object (because setdir is a local argument)
		PLM_FNCT_PUBVAR_setDir =
		{
			private ["_object", "_direction"];
			_object = _this select 1 select 0;
			_direction = _this select 1 select 1;
			
			// Orie/nt the object and broadcast the result
			_object setDir _direction;
			_object setPos (getPos _object);
		};
	"PLM_FNCT_PUBVAR_setDir" addPublicVariableEventHandler PLM_FNCT_PUBVAR_setDir;
	};
	
if (isServer) then
{
	// Create the attachment point which will serve as the attachto for objects to load virtually in the vehicles
	PLM_PUBVAR_attach_point = "HeliHEmpty" createVehicle [0, 0, 0];
	publicVariable "PLM_PUBVAR_attach_point";
	diag_log ("PLM: Attachment point created");
};

//diag_log (format ["PLM: (PRE-LOOP) ATTACHMENT CHECK: *%1*",PLM_PUBVAR_attach_point]);
//diag_log (format ["PLM: (PRE-LOOP) isServer - isDedicated: *%1* - *%2*",isServer,isDedicated]);


// Client-Side only 
if !(isServer && isDedicated) then

{
	//diag_log (format ["PLM: (LOOP) ATTACHMENT CHECK: *%1*",PLM_PUBVAR_attach_point]);
	// The client waits for the attach point to be created
	waitUntil {!isNil "PLM_PUBVAR_attach_point"};
	diag_log ("PLM: Server Side attachment point ready");

	/** Indicates what object the player is in the process of moving, objnull if none */
	PLM_object_player_is_moving = objNull;
	
	/** Counter to ensure player only performs one action at a time until complete (true: activity locked) */
	PLM_player_in_action = false;
	
	/** Object currently select to be loaded */
	PLM_current_object_selected = objNull;
	
	// Holder array for list of class names of transporter vehicles in the area (for the nearestobjects, count iskindof, ... )
	PLM_transporter_classes = [];
	
	{
		PLM_transporter_classes = PLM_transporter_classes + [_x select 0];
	} forEach PLM_CFG_transporters;
	
	// Holder array for list of class names of transportable objects in the area (for the nearestobjects, count iskindof, ... )
	PLM_transportable_classes = [];
	
	{
		PLM_transportable_classes = PLM_transportable_classes + [_x select 0];
	} forEach PLM_CFG_transportable_objects;
	
	//Functions to call either move/lock function or packing function
	
	PLM_FNCT_object_init = compile preprocessFile "PLM\object_init.sqf";
	PLM_FNCT_transport_init = compile preprocessFile "PLM\transport\transport_init.sqf";
	
	/** Indicates which is the object for the variables of actions of addaction */
	PLM_object_addAction = objNull;
	
	// List of variables for activating actions in menus
	PLM_object_can_be_loaded = true;
	PLM_can_view_vehicle_content = true;
	PLM_object_can_be_moved = true;
	PLM_can_object_be_detached = false;
	PLM_object_can_be_trans_moved = false;
	PLM_object_can_be_transported = true;

// Monitor to identify all objects and look for new ones that are created in game

//	if !(isServer && isDedicated) then
//	{
		execVM "PLM\monitor_new_objects.sqf";
		diag_log ("PLM: NON-dedicated object monitor launched");

//	}
	// Lite Version for the dedicated server
//	else
//	{
//		execVM "PLM\monitor_new_objects_dedicated.sqf";
//		diag_log ("PLM: Dedicated object monitor launched");
//
//	};
	
	
	/** Monitor for current conditions to update menus */
	execVM "PLM\check_conditions_monitor.sqf";
	diag_log ("PLM: Init complete");

}
else {diag_log ("PLM: INIT STOPPED (Client = BAD  Server = OK)");}

;

