/**
 * Initialize the transporting system
 * 
 * @param 0 The transporting vehicle
 */
 
diag_log ("PLM: (TRANS_INIT) Initializing");


private ["_transport_vehicle", "_is_disabled", "_objects_charges"];

_transport_vehicle = _this select 0;

_is_disabled = _transport_vehicle getVariable "PLM_disabled";
if (isNil "_is_disabled") then
{
	_transport_vehicle setVariable ["PLM_disabled", false];
};

// Local specifying of the variable if it is not defined on the network
_objects_charges = _transport_vehicle getVariable "PLM_loaded_objects";
if (isNil "_objects_charges") then
{
	_transport_vehicle setVariable ["PLM_loaded_objects", [], false];
};

_transport_vehicle addAction [("<t color=""#dddd00"">" + "Load in the vehicle" + "</t>"), "PLM\transport\load_in_vehicle.sqf", nil, 6, true, true, "", "PLM_object_addAction == _target && PLM_object_can_be_trans_moved"];

_transport_vehicle addAction [("<t color=""#eeeeee"">" + "... load the selected object in this vehicle" + "</t>"), "PLM\transport\load_in_this_vehicle.sqf", nil, 6, true, true, "", "PLM_object_addAction == _target && PLM_object_can_be_loaded"];

_transport_vehicle addAction [("<t color=""#dddd00"">" + "View the vehicle content" + "</t>"), "PLM\transport\view_vehicle_contents.sqf", nil, 5, false, true, "", "PLM_object_addAction == _target && PLM_can_view_vehicle_content"];