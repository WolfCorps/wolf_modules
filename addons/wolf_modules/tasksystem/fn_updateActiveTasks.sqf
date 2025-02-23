/*
 * Authors: dedmen
 * Update all running tasks, check if condition is fulfilled, start continuation if present
 *
 * Arguments: <NONE>
 *
 * Return Value: <NOTHING>
 * Return description <NONE>
 *
 * Example:
 * [params] call wolf_tasksystem_fnc_updateActiveTasks
 *
 * Public: No
 */

{
    // _x: TaskInstance
    private _taskID = _x get "taskID";
    private _taskType = (_x get "taskType") get "taskType";

    if (_x call ["completionCondition"]) then {
        // Task completed
        diag_log ["Task completed", _taskType];

        // Remove task from active list and execute completion routine
        wolf_tasksystem_activeTasks deleteAt (wolf_tasksystem_activeTasks find _x);
        _x call ["onComplete"];

        // Check for continuation task
        private _continuation = _x call ["getContinuationType"];
        if (!isNil "_continuation") then {
            (_continuation call wolf_tasksystem_fnc_selectTaskType) params ["_newTaskType", "_targetLocation"];
            if (!isNil "_newTaskType") then {
                [_newTaskType, _targetLocation, _x] call wolf_tasksystem_fnc_startNewTask;
            };
        };

    } else if (_x call ["failureCondition"]) then {
        // Task failed
        diag_log ["Task failed", _taskType];
        wolf_tasksystem_activeTasks deleteAt (wolf_tasksystem_activeTasks find _x);
        _x call ["onFail"];
        [_taskID, "FAILED"] call BIS_fnc_taskSetState;

    } else if (_x call ["cancellationCondition"]) then {
        // Task canceled
        diag_log ["Task canceled", _taskType];
        wolf_tasksystem_activeTasks deleteAt (wolf_tasksystem_activeTasks find _x);
        _x call ["onCancel"];
        [_taskID, "CANCELED"] call BIS_fnc_taskSetState;
    };

} forEachReversed wolf_tasksystem_activeTasks; // Reversed because we're deleting elements
