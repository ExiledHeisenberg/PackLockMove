//	@file Author: OneManGang
//	@file Version: 1.0
//  @file Date:	9/2/2014	
//	@file Description: Locks an object until the player disconnects.
//	@file Args: [object,player,int,lockState(lock = 0 / unlock = 1)]

// Check if mutex lock is active.
if(PLM_player_in_action) exitWith {
	player globalChat "The current operation isn't finished.";
};

private["_locking", "_currObject", "_lockState", "_lockDuration", "_stringEscapePercent", "_iteration", "_unlockDuration", "_totalDuration"];

_currObject = _this select 0;
_lockState = _this select 3;

_totalDuration = 0;
_stringEscapePercent = "%";

switch (_lockState) do {
    case 0:{ // LOCK
    
    	PLM_player_in_action = true;
		_totalDuration = 5;
		_lockDuration = _totalDuration;
		_iteration = 0;
		
		player switchMove "AinvPknlMstpSlayWrflDnon_medic";
		
		for "_iteration" from 1 to _lockDuration do {
		    
            if(player distance _currObject > 5) exitWith { // If the player dies, revert state.
		        2 cutText ["Object lock interrupted...", "PLAIN DOWN", 1];
                PLM_player_in_action = false;
			};
            
            if (!(alive player)) exitWith {// If the player dies, revert state.
				2 cutText ["Object lock interrupted...", "PLAIN DOWN", 1];
                PLM_player_in_action = false;
			};
            
            if (animationState player != "AinvPknlMstpSlayWrflDnon_medic") then { // Keep the player locked in medic animation for the full duration of the unlock.
                player switchMove "AinvPknlMstpSlayWrflDnon_medic";
            };
            
			_lockDuration = _lockDuration - 1;
		    _iterationPercentage = floor (_iteration / _totalDuration * 100);
		    
			2 cutText [format["Object lock %1%2 complete", _iterationPercentage, _stringEscapePercent], "PLAIN DOWN", 1];
		    sleep 1;
		    
			if (_iteration >= _totalDuration) exitWith { // Sleep a little extra to show that lock has completed.
		        sleep 1;
                _currObject setVariable ["objectLocked", true, true];
                2 cutText ["", "PLAIN DOWN", 1];
                PLM_player_in_action = false;
		    }; 
		};
		
		player SwitchMove "amovpknlmstpslowwrfldnon_amovpercmstpsraswrfldnon"; // Redundant reset of animation state to avoid getting locked in animation.       
    };
    case 1:{ // UNLOCK
        
        PLM_player_in_action = true;
		_totalDuration = 45;
		_unlockDuration = _totalDuration;
		_iteration = 0;
		
		player switchMove "AinvPknlMstpSlayWrflDnon_medic";
		
		for "_iteration" from 1 to _unlockDuration do {
		    
            if(player distance _currObject > 5) exitWith { // If the player dies, revert state.
		        2 cutText ["Object unlock interrupted...", "PLAIN DOWN", 1];
                PLM_player_in_action = false;
			};
            
            if (!(alive player)) exitWith {// If the player dies, revert state.
				2 cutText ["Object unlock interrupted...", "PLAIN DOWN", 1];
                PLM_player_in_action = false;
			};
            
            if (animationState player != "AinvPknlMstpSlayWrflDnon_medic") then { // Keep the player locked in medic animation for the full duration of the unlock.
                player switchMove "AinvPknlMstpSlayWrflDnon_medic";
            };
            
			_unlockDuration = _unlockDuration - 1;
		    _iterationPercentage = floor (_iteration / _totalDuration * 100);
		    
			2 cutText [format["Object unlock %1%2 complete", _iterationPercentage, _stringEscapePercent], "PLAIN DOWN", 1];
		    sleep 1;
		    
			if (_iteration >= _totalDuration) exitWith { // Sleep a little extra to show that lock has completed
		        sleep 1;
                _currObject setVariable ["objectLocked", false, true];
                2 cutText ["", "PLAIN DOWN", 1];
                PLM_player_in_action = false;
		    }; 
		};
		
		player SwitchMove "amovpknlmstpslowwrfldnon_amovpercmstpsraswrfldnon"; // Redundant reset of animation state to avoid getting locked in animation.     
    };
    default{  // This should not happen... 
        diag_log format["PLM: An error has occured in toggleLockState.sqf. _lockState was unknown. _lockState actual: %1", _lockState];
    };
    
    if !(PLM_player_in_action) then {
        PLM_player_in_action = false;
        diag_log format["PLM: An error has occured in toggleLockState.sqf. Mutex lock was not reset. Mutex lock state actual: %1", PLM_player_in_action];
    }; 
};
