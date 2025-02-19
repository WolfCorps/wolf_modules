/*
 * Authors: dedmen
 * Create task type
 *
 * Arguments:
 * 0: task type <TaskType struct>
 *
 * Return Value: <NONE>
 * Return description <NONE>
 *
 * Example:
 * [params] call wolf_tasksystem_fnc_registerTaskType
 *
 * Public: No
 */


params ["_newTaskType"];

// assert "taskType" in (_newTaskType get "#type")

wolf_tasksystem_taskTypes set [_newTaskType get "taskType", _newTaskType];