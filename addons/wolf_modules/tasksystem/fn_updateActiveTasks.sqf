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

    if (_x call ["completionCondition"]) exitWith {
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
    };

    if (_x call ["failureCondition"]) exitWith {
        // Task failed
        diag_log ["Task failed", _taskType];

        // Remove task from active list and execute failure routine
        wolf_tasksystem_activeTasks deleteAt (wolf_tasksystem_activeTasks find _x);
        _x call ["onFail"];
    };

    if (_x call ["cancellationCondition"]) exitWith {
        // Task canceled
        diag_log ["Task canceled", _taskType];

        // Remove task from active list and execute cancellation routine
        wolf_tasksystem_activeTasks deleteAt (wolf_tasksystem_activeTasks find _x);
        _x call ["onCancel"];
    };

} forEachReversed wolf_tasksystem_activeTasks; // Reversed because we're deleting elements
