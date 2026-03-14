params ["_player"];

[getPlayerUID player, [player] call CBA_fnc_getLoadout] remoteExec ["wolf_MissionTransition_fnc_server_storeClientLoadout", 2];

// Fade out player, tell them to wait

cutText ["test text", "BLACK FADED", 999];
