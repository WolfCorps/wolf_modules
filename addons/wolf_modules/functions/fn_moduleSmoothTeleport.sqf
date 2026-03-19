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

        // Store map of teleporters, so that the other end can find us
        if (isNil "wolf_smoothTeleporters") then { wolf_smoothTeleporters = createHashMap; };

        private _teleportName = _logic getVariable ["TeleportName", ""];
        private _teleporters = wolf_smoothTeleporters getOrDefault [_teleportName, [], true];

        _teleporters pushBack _logic;

        // Set up teleport area

        if (hasInterface) then {
            private _area = [getPos _logic];
            _area append (_logic getVariable ["objectarea", []]); // a, b, angle, isRectangle, c

            _handle = [{
                params ["_args", "_handle"];
                _args params ["_teleportName", "_logic", "_area"];

                private _playerPos = getPosASL player;
                private _playerDir = [vectorDir player, vectorUp player];

                if (player inArea _area) then {

                    if (_logic getVariable ["wolf_smoothTeleport_waitForExit", false]) exitWith {}; // Player was in area yes, wait for them to exit

                    private _sourcePos = getPosASL _logic;
                    private _posDelta = _playerPos vectorDiff _sourcePos;

                    // Find target
                    private _teleporters = wolf_smoothTeleporters get _teleportName;
                    _teleporters = _teleporters select {_x isNotEqualTo _logic}; // Filter out source
                    private _target = _teleporters select 0;
                    //systemChat str ["player enter", _logic];
                    _target setVariable ["wolf_smoothTeleport_waitForExit", true]; // Don't teleport player back, until he left the area and comes back

                    private _targetPos = getPosASL _target;
                    _targetPos = _targetPos vectorAdd _posDelta;
                    //systemChat str ["tp", _target, _targetPos];

                    player setPosASL _targetPos;
                    player setVectorDirAndUp _playerDir;
                } else {
                    //if (_logic getVariable ["wolf_smoothTeleport_waitForExit", false]) then {systemChat str ["player leave", _logic];};
                    _logic setVariable ["wolf_smoothTeleport_waitForExit", false];
                };
            }, 0, [_teleportName, _logic, _area]] call CBA_fnc_addPerFrameHandler;
        };
    };
    // When some attributes were changed (including position and rotation)
    // Fires when module is initially placed in 3DEN
    case "attributesChanged3DEN": {
        _input params [
            ["_logic", objNull, [objNull]]
        ];

        private _teleportName = _logic getVariable ["TeleportName", ""];
        if (_teleportName isEqualTo "") exitWith {
            ["Smooth teleport must have a 'TeleportName' configured", 1, 10] call BIS_fnc_3DENNotification;
            true
        };

        private _allObjects = all3DENEntities select 3;

        // Find the other end
        private _teleportModules = _allObjects select {(configOf _x) isEqualTo (configOf _logic)};
        _teleportModules = _teleportModules select {(_x get3DENAttribute "wolf_TeleportName") select 0 == _teleportName};

        if (count _teleportModules == 1) exitWith {
            [format ["Smooth teleport is missing its other end: %1", _teleportName], 1, 10] call BIS_fnc_3DENNotification;
            true;
        };

        if (count _teleportModules > 2) exitWith {
            [format ["Smooth teleport has too many modules with same name: %1", _teleportName], 1, 10] call BIS_fnc_3DENNotification;
            true;
        };
    };

    // When connection to object changes (i.e., new one is added or existing one removed)
    case "connectionChanged3DEN": {
        _input params [
            ["_logic", objNull, [objNull]]
        ];
    };
};
true;
