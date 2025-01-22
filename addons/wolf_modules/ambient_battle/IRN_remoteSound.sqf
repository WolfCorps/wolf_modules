params["_sound","_pos","_shots","_delay","_volume","_center","_dist", "_maxDistance"];
//get distance to center
_d =_center distance player;
if (_d > _maxDistance) exitWith {			
};
//get pos			
_pos = [_center,_dist] call IRN_fnc_calcSoundPos;			
//play salvo			
[_sound,_pos,_shots,_delay,_volume] spawn IRN_fnc_spawnSalvo;