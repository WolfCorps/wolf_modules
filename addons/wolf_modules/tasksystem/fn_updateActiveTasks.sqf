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

    // Check if complete
    private _isCompleted = _x call ["completionCondition"];
    
    // If task is not completed, check for fail or cancel conditions
    if (!_isCompleted) then {

        // Check if task is failed
        private _isFailed = _x call ["failureCondition"];
        if (_isFailed) then {
            diag_log ["Task failed", _taskType];
            wolf_tasksystem_activeTasks deleteAt (wolf_tasksystem_activeTasks find _x);
            _x call ["onFail"];
            [_taskID, "FAILED"] call BIS_fnc_taskSetState;
            // No continuation should be triggered for failed tasks
        } else {

            // Check if task is canceled
            private _isCanceled = _x call ["cancellationCondition"];
            if (_isCanceled) then {
                diag_log ["Task canceled", _taskType];
                wolf_tasksystem_activeTasks deleteAt (wolf_tasksystem_activeTasks find _x);
                _x call ["onCancel"];
                [_taskID, "CANCELED"] call BIS_fnc_taskSetState;
                // No continuation should be triggered for canceled tasks
            } 
        };

        // Since the task either failed or was canceled, it should not continue beyond this point
        continue;
    };

    // Task was successfully completed
    diag_log ["Task completed", _taskType];

    // Remove from active list and mark as complete
    wolf_tasksystem_activeTasks deleteAt (wolf_tasksystem_activeTasks find _x);
    _x call ["onComplete"];

    // Continuation should **only** happen for completed tasks
    private _continuation = _x call ["getContinuationType"];
    if (isNil "_continuation") exitWith {}; // No continuation, task fully ends

    (_continuation call wolf_tasksystem_fnc_selectTaskType) params ["_newTaskType", "_targetLocation"];
    if (isNil "_newTaskType") exitWith {}; // Couldn't find a valid continuation task

    [_newTaskType, _targetLocation, _x] call wolf_tasksystem_fnc_startNewTask;

} forEachReversed wolf_tasksystem_activeTasks; // Reversed because we're deleting elements
