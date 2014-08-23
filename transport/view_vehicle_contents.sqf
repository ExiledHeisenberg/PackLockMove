/**
 * Opens the dialog box of the contents of the vehicle and the prefilled according to vehicle
 * 
 * @param 0 le véhicule dont il faut afficher le contenu
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

disableSerialization; // A cause of displayctrl

if (PLM_player_in_action) then
{
	player globalChat "The current operation isn't finished.";
}
else
{
	PLM_player_in_action = true;
	
	private ["_transport_vehicle", "_current_load", "_max_capacity", "_vehicle_contents", "_tab_contenu_regroupe"];
	private ["_object_class_names", "_object_class_qty", "_i", "_j", "_dlg_vehicle_content"];
	
	_transport_vehicle = _this select 0;
	
	uiNamespace setVariable ["PLM_dlg_CV_transport_vehicle", _transport_vehicle];
	
	createDialog "PLM_dlg_vehicle_content";
	
	_vehicle_contents = _transport_vehicle getVariable "PLM_loaded_objects";
	
	/** List of class names of objects contained in the vehicle, without duplicate */
	_object_class_names = [];
	/** Quantity associated (by index) to class names in _object_class_names */
	_object_class_qty = [];
	
	_current_load = 0;
	
	// Preparation of the list of contents and quantities associated with the objects
	for [{_i = 0}, {_i < count _vehicle_contents}, {_i = _i + 1}] do
	{
		private ["_object"];
		_object = _vehicle_contents select _i;
		
		if !((typeOf _object) in _object_class_names) then
		{
			_object_class_names = _object_class_names + [typeOf _object];
			_object_class_qty = _object_class_qty + [1];
		}
		else
		{
			private ["_idx_object"];
			_idx_object = _object_class_names find (typeOf _object);
			_object_class_qty set [_idx_object, ((_object_class_qty select _idx_object) + 1)];
		};
		
		// Adding the object to the current load
		for [{_j = 0}, {_j < count PLM_CFG_transportable_objects}, {_j = _j + 1}] do
		{
			if (_object isKindOf (PLM_CFG_transportable_objects select _j select 0)) exitWith
			{
				_current_load = _current_load + (PLM_CFG_transportable_objects select _j select 1);
			};
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
	
	
	// Disply content in the dialog box
	#include "dlg_constants.h"
	private ["_ctrl_liste"];
	
	_dlg_vehicle_content = findDisplay PLM_IDD_dlg_vehicle_contents;
	
	/**** Beginning of translations of labels ****/
	(_dlg_vehicle_content displayCtrl PLM_dlg_VC_btn_title) ctrlSetText "Content of vehicle";
	(_dlg_vehicle_content displayCtrl PLM_dlg_VC_credits) ctrlSetText "PackLockMove";
	(_dlg_vehicle_content displayCtrl PLM_IDC_dlg_VC_btn_unload) ctrlSetText "Unload";
	(_dlg_vehicle_content displayCtrl PLM_dlg_VC_btn_close) ctrlSetText "Cancel";
	/**** Finish translations of labels ****/
	
	(_dlg_vehicle_content displayCtrl PLM_IDC_dlg_VC_vehicle_capacity) ctrlSetText (format ["Loading : %1/%2", _current_load, _max_capacity]);
	
	_ctrl_liste = _dlg_vehicle_content displayCtrl PLM_IDC_dlg_VC_contents;
	
	if (count _object_class_names == 0) then
	{
		(_dlg_vehicle_content displayCtrl PLM_IDC_dlg_VC_btn_unload) ctrlEnable false;
	}
	else
	{
		// Insertion of each type of objects in the list
		for [{_i = 0}, {_i < count _object_class_names}, {_i = _i + 1}] do
		{
			private ["_index", "_icon"];
			
			_icon = getText (configFile >> "CfgVehicles" >> (_object_class_names select _i) >> "icon");
			
			// If the icon is valid
			if (toString ([toArray _icon select 0]) == "\") then
			{
				_index = _ctrl_liste lbAdd (getText (configFile >> "CfgVehicles" >> (_object_class_names select _i) >> "displayName") + format [" (%1x)", _object_class_qty select _i]);
				_ctrl_liste lbSetPicture [_index, _icon];
			}
			else
			{
				// If the satellite phone is used for a PC of artillery
				if (!(isNil "R3F_ARTY_active") && (_object_class_names select _i) == "SatPhone") then
				{
					_index = _ctrl_liste lbAdd ("     " + "Artillery CQ" + format [" (%1x)", _object_class_qty select _i]);
				}
				else
				{
					_index = _ctrl_liste lbAdd ("     " + getText (configFile >> "CfgVehicles" >> (_object_class_names select _i) >> "displayName") + format [" (%1x)", _object_class_qty select _i]);
				};
			};
			
			_ctrl_liste lbSetData [_index, _object_class_names select _i];
		};
	};
	
	waitUntil (uiNamespace getVariable "PLM_dlg_vehicle_content");
	PLM_player_in_action = false;
};