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
	// Check if complete
	private _isCompleted = _x call ["completionCondition"];
	if (!_isCompleted) then { continue; }; // Don't care about uncompleted tasks

	diag_log ["task completed", (_x get "taskType") get "taskType"];

	// Task is completed, remove it from active, finish it, check for continuation 
	wolf_tasksystem_activeTasks deleteAt (wolf_tasksystem_activeTasks find _x);
	_x call ["onComplete"];

	// Continuation? 
	private _continuation = _x call ["getContinuationType"];

	if (isNil "_continuation") then { continue; }; // No continuation, we're done with this

	(_continuation call wolf_tasksystem_fnc_selectTaskType) params ["_newTaskType", "_targetLocation"];

	if (isNil "_newTaskType") then { continue; }; // Couldn't find anything to continue with

	[_newTaskType, _targetLocation, _x] call wolf_tasksystem_fnc_startNewTask;
} forEachReversed wolf_tasksystem_activeTasks; // Reversed because we're deleting elements