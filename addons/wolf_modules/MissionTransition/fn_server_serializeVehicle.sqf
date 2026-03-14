params ["_veh"];


private _data = createHashMap;


// These are property that are only relevant to root vehicle, not ace cargo vehicles
_data set ["pos", getPosASL _veh];
_data set ["vdir", vectorDir _veh];
_data set ["dir", direction _veh];

// This has properties that apply to both the root vehicle, and also everything in ACE cargo. This is recursive!
private _fnc_serializeCargoVehicle = {
    params ["_data", "_veh"];

    _data set ["type", typeOf _veh];

    _data set ["varName", vehicleVarName _veh];


    _data set ["fuel", fuel _veh];
    _data set ["aceFuel", [_veh] call ace_refuel_fnc_getFuel];

    _data set ["damage", getAllHitPointsDamage _veh]; // https://community.bistudio.com/wiki/setHitPointDamage

    // getAmmoCargo and fuel and repair, for support vehicles?
    _data set ["magTurret", magazinesAllTurrets _veh];
    _data set ["pylons", getAllPylonsInfo _veh];

    _data set ["inventory", [_veh, str _veh, typeOf _veh] call wolf_logistics_main_fnc_createPresetFromBox];


    // ACE Cargo

    _data set ["cargoSpace", _veh getVariable ["ace_cargo_space", getNumber (configOf _veh >> "ace_cargo_space")]];
    _data set ["cargoSize", _veh getVariable ["ace_cargo_size", getNumber (configOf _veh >> "ace_cargo_size")]];

    private _aceCargo = _veh getVariable ["ace_cargo_loaded", []];

    private _cargoData = _aceCargo apply {
        // _x is either string or vehicle. Some objects may only exist as strings
        if (_x isEqualType "") then { continueWith _x; }; // That is all we have, and that's fine

        // Its a full vehicle.

        private _vehData = createHashMap;
        [_vehData, _x] call _fnc_serializeCargoVehicle; // Recursion
        _vehData
    };

    _data set ["cargo", _cargoData];

};

[_data, _veh] call _fnc_serializeCargoVehicle; // This will recurse into ACE cargo

_data
