params [["_ctrl", controlNull]];

if (!is3DENPreview) exitWith {ctrlDelete _ctrl};

uiNamespace setVariable ["wolf_unitRecordButton", _ctrl];

if (missionNamespace getVariable ["wolf_unitCaptureRunning", false]) then
{
    _ctrl ctrlSetText "End Unit Recording";

    hint "Capture paused.";
    wolf_unitCapturePaused = true;
    _ctrl ctrlAddEventHandler ["Destroy", {
        if (missionNamespace getVariable ["wolf_unitCaptureRunning", false]) then { // Might've been ended while in menu
            wolf_unitCapturePaused = false;
            hint "Resuming capture...";
        };
    }];
}

