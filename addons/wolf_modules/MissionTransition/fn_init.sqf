


// Save medical state

["CBA_loadoutGet", {
    params ["_unit", "_loadout", "_extendedInfo"];
    _extendedInfo set ["wolf_medicalState", [_unit] call ace_medical_fnc_serializeState];
}] call CBA_fnc_addEventHandler;

["CBA_loadoutSet", {
    params ["_unit", "_loadout", "_extendedInfo"];
    private _medicalState = _extendedInfo getOrDefault ["wolf_medicalState", []];
    if (_medicalState isNotEqualTo []) then {
        [player, _medicalState] call ace_medical_fnc_deserializeState;
    };
}] call CBA_fnc_addEventHandler;

// TFAR LR radio settings

["CBA_loadoutGet", {
    params ["_unit", "_loadout", "_extendedInfo"];

    private _backpackLR = player call TFAR_fnc_backpackLr;
    if (isNil "_backpackLR") exitWith {};

    private _lrSettings = _backpackLR call TFAR_fnc_getLrSettings;
    _extendedInfo set ["wolf_tfar_lrRadio", _lrSettings];
}] call CBA_fnc_addEventHandler;

["CBA_loadoutSet", {
    params ["_unit", "_loadout", "_extendedInfo"];

    private _lrSettings = _extendedInfo getOrDefault ["wolf_tfar_lrRadio", []];
    if (_lrSettings isNotEqualTo []) then {
        private _backpackLR = player call TFAR_fnc_backpackLr; // We must find this now, loadout itself was already applied
        [_backpackLR, _lrSettings] call TFAR_fnc_setLrSettings;
    };
}] call CBA_fnc_addEventHandler;

// TFAR SR radio settings

["CBA_loadoutGet", {
    params ["_unit", "_loadout", "_extendedInfo"];

    private _radios = player call TFAR_fnc_radiosList; //#TODO sort them by name, then we at least don't mess up types if we have more than 2 radios and the order switches on restore
    private _radioSettings = _radios apply {_x call TFAR_fnc_getSwSettings};

    _extendedInfo set ["wolf_tfar_srRadio", _radioSettings];

    // Replace the radios in the loadout array, with prototype versions

    // https://github.com/michail-nikolaev/task-force-arma-3-radio/blob/master/addons/core/functions/fnc_loadoutReplaceProcess.sqf
    private _cfgWeapons = configFile >> "CfgWeapons"; //So we don't resolve every time in loop
    // iterate through each container
    {
        private _content = _x;
        // iterate through each item of the container
        {
            private _item = _x;
            private _index = _forEachIndex; // This is just a way to bypass HEMTT's lint
            if (_x isEqualType []) then {
                _content = _x;
                _index = 0;
                _item = _content select 0;
            };

            private _class = _cfgWeapons >> _item;

            // if the item is an actual radio, not a radio prototype nor common item
            if ((isClass _class) && {isNumber (_class >> "tf_radio")}) then {
                // erase the content value with parent prototype
                // systemChat str ["TFAR", "replace", _class, _index, getText (_class >> "tf_parent")];
                _content set [_index, getText (_class >> "tf_parent")];
            };
        } forEach _content;
    } forEach [
        if ((_loadout select 3) isEqualTo []) then {[]} else {(_loadout select 3) select 1}, // uniform content
        if ((_loadout select 4) isEqualTo []) then {[]} else {(_loadout select 4) select 1}, // vest content
        if ((_loadout select 5) isEqualTo []) then {[]} else {(_loadout select 5) select 1}, // backpack content
        _loadout select 9             // assigned items
    ];



}] call CBA_fnc_addEventHandler;

["CBA_loadoutSet", {
    params ["_unit", "_loadout", "_extendedInfo"];

    private _srSettings = _extendedInfo getOrDefault ["wolf_tfar_srRadio", []];
    if (_srSettings isNotEqualTo []) then {

        [
            "TFAR_event_OnRadiosReceived",
            {
                params ["_requestedUnit", "_newRadios"];
                _thisArgs params ["_srSettings"];

                // We now have all radios, apply the settings.
                // The order should still match? At least one linked and one inventory radio will work, if there are more we probably mess up
                private _radios = _newRadios;

                {
                    private _radio = _radios select _forEachIndex;
                    //systemChat str ["srRadioApply", _radio, _x];
                    [_radio, _x] call TFAR_fnc_setSwSettings;
                } forEach _srSettings;

                ["TFAR_event_OnRadiosReceived", _thisId] call CBA_fnc_removeEventHandler;
            },
            [_srSettings]
        ] call CBA_fnc_addEventHandlerArgs;


        [false] call TFAR_fnc_requestRadios; // Replace prototypes by instantiated radios
        // We know we requested all radios in one go.
        // So the response should also only be one, which we handle (in the handler above)
    };
}] call CBA_fnc_addEventHandler;
