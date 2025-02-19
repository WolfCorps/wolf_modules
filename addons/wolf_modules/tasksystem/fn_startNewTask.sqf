/*
 * Authors: dedmen
 * Start task
 *
 * Arguments:
 * 0: newTaskType <TaskType struct>
 * 1: targetLocation <TaskLocation struct>
 * 2: previousTask <TaskInstance struct> (optional)
 *
 * Return Value: <NOTHING>
 * Return description <NONE>
 *
 * Example:
 * [params] call wolf_tasksystem_fnc_startNewTask
 *
 * Public: No
 */

params ["_newTaskType", "_targetLocation", "_previousTask"];

// Create the task 
private _newTaskInstance = _newTaskType call ["createTask", [_previousTask, _targetLocation]];
// Add to active 
wolf_tasksystem_activeTasks pushBack _newTaskInstance;

// Start
_newTaskInstance call ["onStart"];