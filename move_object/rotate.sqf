/*
	@file Author: OneManGng
	@file Version: 1.0
   	@file Date:	9/2/2014	
	@file Description: Rotates an object by x degrees depending on args
	@file Args: [rotation amount(int)]
*/

private ["_currDirection", "_targetDirection", "_rotateAmount"];

_rotateAmount = _this select 3;
_targetDirection = "";

if (PLM_player_in_action) then {
	player globalChat "The current operation isn't finished.";
} else {
	_targetDirection = (getDir PLM_object_player_is_moving) + _rotateAmount; // Get the direction of the object and increment by _rotateAmount
	_targetDirection = _targetDirection - getDir player;

	PLM_object_player_is_moving setDir _targetDirection;
	PLM_PUBVAR_setDir = [PLM_object_player_is_moving, _targetDirection];
	publicVariable "PLM_PUBVAR_setDir";
	PLM_player_in_action = false;
};





