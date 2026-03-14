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

        //systemChat str ( _logic getVariable ["objectarea", []]);

        private _vehSpots = _logic getVariable ["wolf_vehSpots", []]; // Array of marker names

        if (isServer) then
        {
            // Handle vehicles
            private _vehicles = missionProfileNamespace getVariable "w_mt_vehicles";

            {
                // Try to find a pos
                private _zone = _vehSpots deleteAt 0; // is a marker name
                if (isNil "_zone") then {
                    //#TODO throw error
                    continue;
                };

                private _pos = AGLToASL markerPos [_zone, true];
                private _dir = markerDir _zone;

                [_x, _pos, _dir] spawn {
                    sleep 5; // This is a hack, ACE cargo requires something out of their postInit, but postInit didn't run yet
                    call wolf_MissionTransition_fnc_server_deserializeVehicle;
                };
            } forEach _vehicles;

        };

        if (hasInterface) then // Player can also be server when testing locally
        {
            // Execute player code
            [] spawn {
                waitUntil {!isNull player};
                sleep 5;
                [getPlayerUID player] remoteExec ["wolf_MissionTransition_fnc_server_fetchClientLoadout", 2];
            }
        };

        //deleteVehicle _logic; // We don't do anything, no need to clutter things
    };
    // When some attributes were changed (including position and rotation)
    // Fires when module is initially placed in 3DEN
    case "attributesChanged3DEN": {
        _input params [
            ["_logic", objNull, [objNull]]
        ];

        // Check that we don't have multiple of this module
        private _allObjects = all3DENEntities select 3;

        if (_allObjects findIf {_x != _logic && _x isKindOf typeOf _logic} != -1) then
        {
            ["You have multiple MissionTransition entry modules, that's not possible", 1, 10] call BIS_fnc_3DENNotification;
        };

        private _missionGroup = getMissionConfigValue "missionGroup";
        if (isNil "_missionGroup" || {_missionGroup == ""}) then
        {
            ["description.ext 'missionGroup' is missing, that is required for MissionTransition", 1, 10] call BIS_fnc_3DENNotification;
        };
    };
};
true;
