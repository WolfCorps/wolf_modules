params ["_data", "_pos", "_dir"];

private _veh = (_data get "type") createVehicle _pos;
_veh setPosASL _pos;
_veh setDir _dir;

// This has properties that apply to both the root vehicle, and also everything in ACE cargo. This is recursive!
private _fnc_deserializeCargoVehicle = {
    params ["_data", "_veh"];

    if ((_data get "varName") != "") then {
        _veh setVehicleVarName (_data get "varName");
        missionNamespace setVariable [(_data get "varName"), _veh, true];
    };

    _veh setFuel (_data get "fuel");
    [_veh, (_data get "aceFuel")] call ace_refuel_fnc_setFuel;

    // Damage

    _damageData = (_data get "damage");

    {
        private _hitpointName = _x;
        private _value = (_damageData select 2) select _forEachIndex;
        _veh setHitPointDamage [_hitpointName, _value, false];
    } forEach (_damageData select 0);

    // getAmmoCargo and fuel and repair, for support vehicles?

    // Magazines

    // First remove all magazines
    {
        _x params ["_className", "_turretPath"];
        _veh removeMagazinesTurret [_className, _turretPath];
    } forEach (magazinesAllTurrets _veh);

    // Add back the magazines we saved
    {
        _x params ["_className", "_turretPath", "_ammoCount"];
        _veh addMagazineTurret  [_className, _turretPath, _ammoCount];
    } forEach (_data get "magTurret");

    // Pylons need special handling
    {
        _x params ["_pylonIndex", "_pylonName", "_assignedTurret", "_magazineClass", "_magazineAmmoCount"];
        _veh setPylonLoadout [_pylonIndex, _magazineClass, true, _assignedTurret];
        _veh setAmmoOnPylon [_pylonIndex, _magazineAmmoCount];
    } forEach (_data get "pylons");

    // Inventory

    [_veh, (_data get "inventory")] call wolf_logistics_main_fnc_fillPresetIntoBox;

    // ACE Cargo

    [_veh, _data get "cargoSpace"] call ace_cargo_fnc_setSpace;
    [_veh, _data get "cargoSize"] call ace_cargo_fnc_setSize;

    // First clear whats in cargo by default
    _veh call ace_cargo_fnc_initVehicle; // This requires ace_cargo_vehicleAction, which is only initialized on postInit
    private _aceCargo = _veh getVariable ["ace_cargo_loaded", []];
    private _cargoData = _aceCargo apply {
        [_x, _veh, 1] call ace_cargo_fnc_removeCargoItem;
    };

    {
        // _x is either string, or hashmap

        if (_x isEqualType "") then
        {
            [_x, _veh, 1, true] call ace_cargo_fnc_addCargoItem;
            continue;
        };

        private _cargoVeh = (_x get "type") createVehicle _pos;
        [_x, _cargoVeh] call _fnc_deserializeCargoVehicle;

        [_cargoVeh, _veh, 1, true] call ace_cargo_fnc_addCargoItem;
    } forEach (_data get "cargo");

    //#TODO vehicle TFAR radios

};

[_data, _veh] call _fnc_deserializeCargoVehicle;
