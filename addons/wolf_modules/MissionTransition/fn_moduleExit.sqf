params [
    ["_mode", "", [""]],
    ["_input", [], [[]]]
];

switch _mode do
{
    // Default object init
    case "init":
    {
        _input params [
            ["_logic", objNull, [objNull]],        // Module logic
            ["_isActivated", true, [true]],        // True when the module was activated, false when it is deactivated
            ["_isCuratorPlaced", false, [true]]    // True if the module was placed by Zeus
        ];
        // ... code here...

        private _excludedPlayers = _logic getVariable ["ExcludedPlayers", -1]; // (as per the previous example, but you can define your own)
        wolf_MissionTransition_ExcludedPlayers = _excludedPlayers; // Server will use this in wolf_MissionTransition_fnc_server_storeClientLoadout to see if all players are ready
        wolf_MissionTransition_NextMission = _logic getVariable ["FollowupMission", ""]; // Server will use this in wolf_MissionTransition_fnc_server_storeClientLoadout to see if all players are ready
        //systemChat str ( _logic getVariable ["objectarea", []]); // [10, 10, 0, true, -1]

        private _playerZones = _logic getVariable ["wolf_playerZones", []]; // Array of triggers
        private _vehZones = _logic getVariable ["wolf_vehZones", []]; // Array of triggers

        wolf_MissionTransition_VehicleZones = _vehZones;

        // Disable veh zone triggers. Save performance, we only poll them once at the end and only use them for area
        {
            _x enableSimulation false; // We don't actually use these triggers
            //_x setTriggerActivation ["NONE", "PRESENT", false];
        } forEach _vehZones;

        {
            _x setTriggerActivation ["ANYPLAYER", "PRESENT", true];
            _x setTriggerStatements ["player in thisList", "if (player in thisList) then {player call wolf_MissionTransition_fnc_client_enteredEndZone;};", ""];
        } forEach _playerZones;

        deleteVehicle _logic; // We don't do anything, no need to clutter things
    };
    // When some attributes were changed (including position and rotation)
    // Fires when module is initially placed in 3DEN
    case "attributesChanged3DEN": {
        _input params [
            ["_logic", objNull, [objNull]]
        ];
        // ... code here...
        private _excludedPlayers = _logic getVariable ["ExcludedPlayers", -1]; // (as per the previous example, but you can define your own)
        private _allObjects = all3DENEntities select 0;

        private _missingPlayers = _excludedPlayers select {private _wantedPlayerName = _x; (_allObjects findIf {_x get3DENAttribute "name" select 0== _wantedPlayerName}) == -1};

        if (_missingPlayers isNotEqualTo []) then
        {
            // Some excluded players don't exist
            [format ["MissionTransition exit module has units excluded, who don't exist: %1", _missingPlayers], 1, 10] call BIS_fnc_3DENNotification;
        };

        // Check that we don't have multiple of this module
        private _allObjects = all3DENEntities select 3;

        if (_allObjects findIf {_x != _logic && _x isKindOf typeOf _logic} != -1) then
        {
            ["You have multiple MissionTransition exit modules, that's not possible", 1, 10] call BIS_fnc_3DENNotification;
        };


        private _missionGroup = getMissionConfigValue "missionGroup";
        if (isNil "_missionGroup" || {_missionGroup == ""}) then
        {
            ["description.ext 'missionGroup' is missing, that is required for MissionTransition", 1, 10] call BIS_fnc_3DENNotification;
        };

    };

    // When connection to object changes (i.e., new one is added or existing one removed)
    case "connectionChanged3DEN": {
        _input params [
            ["_logic", objNull, [objNull]]
        ];

        //#TODO configure the trigger here?
        // ... code here...
    };
};
true;
