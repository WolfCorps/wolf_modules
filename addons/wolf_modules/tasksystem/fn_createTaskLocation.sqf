/*
 * Authors: dedmen
 * Create task location
 *
 * Arguments:
 * 0: Location <ARRAY> position in ATL format or <STRING> marker name
 * 1: Name <STRING>
 *
 * Return Value: <TaskLocation struct>
 * Return description <NONE>
 *
 * Example:
 * [params] call wolf_tasksystem_fnc_createTaskLocation
 *
 * Public: No
 */


params ["_location", "_name"];
// _location is [x,y,z] in ATL format, or a string of a marker name

createHashMapObject [wolf_tasksystem_decl_TaskLocation, [_location, _name]];