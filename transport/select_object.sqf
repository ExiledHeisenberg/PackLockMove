/**
 * Sélectionne un objet à charger dans un transporteur
 * 
 * @param 0 l'objet à sélectionner
 */

if (PLM_player_in_action) then
{
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	_tempVar = false;
	if(!isNil {(_this select 0) getVariable "R3F_Side"}) then {
		if(side player != ((_this select 0) getVariable "R3F_Side")) then {
			{if(side _x ==  ((_this select 0) getVariable "R3F_Side") && alive _x && _x distance (_this select 0) < 150) exitwith {_tempVar = true;};} foreach AllUnits;
		};
	};
	if(_tempVar) exitwith {hint format["This object belongs to %1 and they're nearby you cannot take this.", (_this select 0) getVariable "R3F_Side"]; PLM_player_in_action = false;};

	PLM_player_in_action = true;
	
	PLM_current_object_selected = _this select 0;
	player globalChat format [STR_R3F_LOG_action_selectionner_object_charge_fait, getText (configFile >> "CfgVehicles" >> (typeOf PLM_current_object_selected) >> "displayName")];
	
	PLM_player_in_action = false;
};