/*
 * Authors: dedmen
 * Select a possible task according to filter
 *
 * Arguments:
 * 0: Filter - Empty string, or string with taskType classname or array of multiple of these
 *
 * Return Value: <ARRAY> [TaskType struct, TaskLocation struct]
 * Return description <NONE>
 *
 * Example:
 * [params] call wolf_tasksystem_fnc_selectTaskType
 *
 * Public: No
 */

params [["_filter", "", ["", []]]];

// _filter has a couple options 
// Empty string - Any "initial" task type
// string - name of a specific taskType
// TaskType instance - Just return that instance, we already selected what we want... //#TODO not implemented
// Array of string or TaskType instance - select a random one from that array 

if (_filter isEqualTo "") exitWith {
	// Any initial task, try to find one at a unused location

	// Collect all possible locations from all task types 

	// Only tasks that can be initial, not continuation tasks
	private _initialTaskTypes = ((values wolf_tasksystem_taskTypes) select {_x get "canBeInitial"});

	private _possibleLocations = [];
	{
		// _x: TaskType

		//actually isEqualRef would be better here, but pushBackUnique uses isEqualTo internally, probably doesn't matter
		
		_possibleLocations insert [-1, _x get "possibleLocations", true];
	} forEach _initialTaskTypes;

	// Try to filter out locations of already active tasks, to not have multiple tasks starting at same location
	// Find them by iterating wolf_tasksystem_activeTasks, and getting their locations
	private _possibleLocationsExcludingActiveTasks = _possibleLocations - (wolf_tasksystem_activeTasks apply {_x get "location"});
	// We might fail if too many tasks are active, in that case just allow creating a task at a duplicated location
	if (_possibleLocationsExcludingActiveTasks isNotEqualTo []) then { _possibleLocations = _possibleLocationsExcludingActiveTasks; };

	// Select a random location for our new task 
	private _targetLocation = selectRandom _possibleLocations;

	// Now find all possible tasks, that support this location (this can never fail, its atleast one)..
	private _possibleTasks = _initialTaskTypes select {_targetLocation in (_x get "possibleLocations")};

	// ... and select a random one 
	[selectRandom _possibleTasks, _targetLocation]
};

if (_filter isEqualType "") exitWith {
	// Find specific type by its name
	private _newTaskType = wolf_tasksystem_taskTypes get _filter;
	diag_log ["continuation task", _newTaskType get "taskType"];
	if (isNil "_newTaskType") exitWith {[nil, nil]};
	private _targetLocation = selectRandom (_newTaskType get "possibleLocations");
	diag_log ["continuation task", _targetLocation];
	[_newTaskType, _targetLocation]
};

if (_filter isEqualType []) exitWith {

	_possibleTypes = (_filter apply { _x call wolf_tasksystem_fnc_selectTaskType; });

	// Find specific type by its name
	selectRandom _possibleTypes // A random one of all the possibilities
};

[nil, nil]; // Huh?