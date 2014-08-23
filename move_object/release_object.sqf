/*
	@file Author: OneManGang (Original code part of R3F)
	@file Version: 1.0
   	@file Date:	9/2/2014	
	@file Description: Releases the object that the player has currently selected.
	@file Args: [ , , ,boolean(true = release horizontally)]
*/
if (PLM_player_in_action) then
{
	player globalChat "The current operation isn't finished.";;
}
else
{
	_doReleaseHorizontally = _this select 3;

	PLM_player_in_action = true;
	
	if (_doReleaseHorizontally) then {
		PLM_force_horizontal = true; // Force the object horizontally according the the centre of said object.
	};

	PLM_object_player_is_moving = objNull;
	sleep 0.1;
	
	PLM_player_in_action = false;
};