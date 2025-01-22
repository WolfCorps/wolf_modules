/*
made by IR0NSIGHT
a script which plays gunshots at 400m distance in the direction of a given center object.
creates illusion of nearby gunfight in the direction of the specified object, while allowing bigger distances than are possible with vanilla soundsimulation.
call skript with: 
execVM "yourlinktoskriptinMissionFolder\ambient_battles.sqf";
will only execute on the server machine.
*/
//--------------------------------------------------------------------------------------------
// will remotely call sounds on all clients (including server). define paramters in _handles array
//requires an object called "center" (as its varname in editor) as the soundsource. object will not be touched or teleported.
diag_Log ["#############################################################", _this]; 
params ["_action", "_ambientbattles"];
_module = _ambientbattles select 0;
_dist = _module getVariable "distance";
_dist = parseNumber _dist;
_duration = _module getVariable "duration";
_duration = parseNumber _duration;
_center = _module;
_maxDistance = _module getVariable "maxdistance";
_maxDistance = parseNumber _maxDistance;	

if (!isServer) exitWith {};
if (_action !="init") exitWith {}; //only executes ingame, not in Eden
[false, _duration, _dist, _center, _maxDistance] spawn { //[debug mode, duration in seconds]
	params["_debug","_duration","_dist","_center", "_maxDistance"];
	

	private _i = 0; //iteration counter
	private ["_posC","_posP","_direction","_dirNorm","_dist","_center","_source"];
	private	_listShots = [
		"A3\Sounds_F\weapons\HMG\HMG_gun.wss",
		"A3\Sounds_F\weapons\M4\m4_st_1.wss",
		"A3\Sounds_F\weapons\M200\M200_burst.wss",
		"A3\Sounds_F\weapons\mk20\mk20_shot_1.wss"
	];
	private _listRare = [
		"A3\Sounds_F\weapons\Explosion\explosion_antitank_1.wss",
		"A3\Sounds_F\weapons\Explosion\expl_shell_1.wss",
		"A3\Sounds_F\weapons\Explosion\expl_big_1.wss"
	];
	//place soundsource in direction of city with 400m away from player
	_headPos = _center;
	if (_debug) then {
		hint "starting audio";
	};
	
	sleep 2;
	_start = time;
	_end = _start + _duration;
	while {time < _end} do {
		//loop
		_i = _i + 1;
		if (_debug) then {
			hint str _i;	
		};
		//--------play sounds
		//remote exec position and sound play

		for "_i" from 0 to 5 do { //spawn up to 5 salvos of fast fire (MG)
			_sound = selectRandom (if (random 1 < 0.05) then {_listRare} else {_listShots});
			//params["_sound","_pos","_shots","_delay","_volume"];
			[_sound,	[0,0,0],	random 15,	random 10,0.5 + random 0.5,_center,_dist,_maxDistance] remoteExec ["IRN_fnc_remoteSound",0, true];
		};

		//--------------
		sleep random 20;
	};
	if (_debug) then {
		hint ("player to soundsource: " + str (getPosASL player distance _headPos));
		hint "finished audio";
	};
};
