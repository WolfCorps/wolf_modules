params ["_playerUID", "_playerLoadout"];


missionProfileNamespace setVariable [format ["w_mt_loadout_%1", _playeruid], _playerLoadout];
saveMissionProfileNamespace;

diag_log ["mission trasnsition serverStored", _playerUID];

if (isNil "wolf_MissionTransition_PlayersSaved") then {wolf_MissionTransition_PlayersSaved = [];};

wolf_MissionTransition_PlayersSaved pushBack _playerUID;

//#TODO check if all players (except wolf_MissionTransition_ExcludedPlayers) are saved, if yes run serverCommand to switch missionConfigFile

private _playerRemaining = allPlayers;
_playerRemaining = _playerRemaining select {!(vehicleVarName _x in wolf_MissionTransition_ExcludedPlayers)}; // Ignore excluded players

private _playerUIDRemaining = _playerRemaining apply {getPlayerUID _x};
private _playerUIDRemaining = _playerUIDRemaining - wolf_MissionTransition_PlayersSaved;

diag_log ["Transition waiting for", _playerUIDRemaining];

if (_playerUIDRemaining isEqualTo []) then
{
    //#TODO Save all vehicles now
    // in wolf_MissionTransition_VehicleZones

    private _serializedVehicles = [];

    {
        private _vehTriggerArea = _x;
        private _vehicles = vehicles inAreaArray _vehTriggerArea;

        _serializedVehicles append (_vehicles apply { _x call wolf_MissionTransition_fnc_server_serializeVehicle });
    } forEach wolf_MissionTransition_VehicleZones;

    missionProfileNamespace setVariable ["w_mt_vehicles", _serializedVehicles];

    if (wolf_MissionTransition_NextMission != "") then
    {
        private _password = (getServerInfo get 'PublicSettings') get 'exposedServerCommandPasssword';
        _password serverCommand format ["#mission %1", wolf_MissionTransition_NextMission];
    }
}

