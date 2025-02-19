/*
 * Authors: dedmen
 * Select a random task at random location and start it
 *
 * Arguments: <NONE>
 *
 * Return Value: <NOTHING>
 * Return description <NONE>
 *
 * Example:
 * [params] call wolf_tasksystem_fnc_createRandomTask
 *
 * Public: No
 */

("" call wolf_tasksystem_fnc_selectTaskType) params ["_newTaskType", "_targetLocation"];

if (isNil "_newTaskType") exitWith {}; // Couldn't find anything to start?

[_newTaskType, _targetLocation, nil] call wolf_tasksystem_fnc_startNewTask;