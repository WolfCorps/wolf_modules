params ["_playerUID"];

private _varName = format ["w_mt_loadout_%1", _playeruid];
private _loadout = missionProfileNamespace getVariable _varName;
if (isNil "_loadout") exitWith {};

[_loadout] remoteExec ["wolf_MissionTransition_fnc_client_applyLoadout", remoteExecutedOwner]
