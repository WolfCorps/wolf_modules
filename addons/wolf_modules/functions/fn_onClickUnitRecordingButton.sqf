
// BIS_fnc_unitCapture
// - Don't copy whole array every iteration
// - Don't abort on Esc, only pause
private _fnc_unitCapture = {
    params ["_unit", "_inputFPS"];

    hint "Capturing...";

    private _sleepTime = 1 / _inputFPS;
    private _timeStart = time;

    wolf_unitCaptureRunning = true;
    wolf_unitCapturePaused = false;
    wolf_unitCaptureData = [];
    wolf_unitCaptureLastTick = time - _sleepTime;
    uiNamespace setVariable ["wolf_unitCaptureLastVehicle", vehicleVarName vehicle player];

    _handle = [{
        params ["_args", "_handle"];
        _args params ["_unit", "_sleepTime", "_timeStart"];

        if (!wolf_unitCaptureRunning || !(alive _unit)) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
            hint "Capture ended";

            uiNamespace setVariable ["wolf_unitCaptureLastData", wolf_unitCaptureData];

            add3DENEventHandler ["OnMissionPreviewEnd", {
                [] spawn {
                    sleep 2;
                    systemChat format ["returned, capture %1 / %2", count (uiNamespace getVariable "wolf_unitCaptureLastData"), (uiNamespace getVariable "wolf_unitCaptureLastVehicle")];

                    // Find the vehicle we recorded
                    // Spawn trigger
                    // Put our capture playback, into triggers onActivation script

                    private _allObjects = all3DENEntities select 0;
                    private _vehName = uiNamespace getVariable "wolf_unitCaptureLastVehicle";
                    _allObjects = _allObjects select {((_x get3DENAttribute "name") select 0) == _vehName};

                    private _pos = getPosASL (_allObjects select 0);

                    private _trig = create3DENEntity ["Trigger", "EmptyDetectorArea10x10", _pos];
                    _trig set3DENAttribute ["onActivation", format ["[%1, %2] spawn BIS_fnc_unitPlay", _vehName, uiNamespace getVariable "wolf_unitCaptureLastData"]];

                    uiNamespace setVariable ["wolf_unitCaptureLastData", nil];
                };

                remove3DENEventHandler ["OnMissionPreviewEnd", _thisEventHandler];
            }];


        };

        if (wolf_unitCapturePaused) exitWith {}; // Not recording at the moment

        private _deltaT = time - wolf_unitCaptureLastTick;
        if (_deltaT < _sleepTime) exitWith {}; // Not yet time for frame
        wolf_unitCaptureLastTick = time;

        // Capture frame

        private _timeCur = time - _timeStart;	//< Time from the begining of this script (start of the script is 0)
        hintSilent format ["Capturing... Frame %1 time %2", count wolf_unitCaptureData, _timeCur];

        wolf_unitCaptureData pushBack [_timeCur, (getPosASL _unit), vectorDir _unit, vectorUp _unit, velocity _unit];
    }, 0, [_unit, _sleepTime, _timeStart]] call CBA_fnc_addPerFrameHandler;
};

_ctrl = uiNamespace getVariable "wolf_unitRecordButton";

if (missionNamespace getVariable ["wolf_unitCaptureRunning", false]) then {
    // Stop running capture
    wolf_unitCaptureRunning = false;
    _ctrl ctrlSetText "Start Unit Recording";

    // Save
    copyToClipboard str wolf_unitCaptureData;
    hint "Recording ended.";
} else {
    // Start capture
    [vehicle player, 50] call _fnc_unitCapture;
    _ctrl ctrlSetText "End Unit Recording";
}


