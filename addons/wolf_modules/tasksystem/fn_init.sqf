/*
TaskLocation structure:
{
	constructor: {
		// _location: Array or String - [X,Y,Z] ATL position, or string containing map marker name
		params ["_location", "_name"];
	},
	position: [x,y,z] ATL,
	name: "Display Name of the location"
}
*/
wolf_tasksystem_decl_TaskLocation = [
	["#create", { 
		params ["_location", "_name"];

		if (_location isEqualType "") then {
			// Location is a map marker name
			_self set ["position", getMarkerPos _location];
		} else {
			// Location is XYZ coordinate
			_self set ["position", _location];
		};
		
		_self set ["name", _name]
	}]
];


/*
TaskType structure
{
	taskType: "typeName",
	canBeInitial: true, // Whether this can be a start task, if false then it can only be started via a continuation
	possibleLocations: [TaskLocation structure, ...], // Multiple possible locations for this task

	// This is set to automatically launch a new task once this one is finished
	// For example a dropoff task, that should be started after a delivery task
	// The new task will receive the ID of the previous task
	// Can be empty string to be "any type of task". Leave un-set to not have a continuation task
	continuationType: "taskType name" or TaskInstance or nil,

	createTask: {
		// _previousTask: TaskInstance (optional) - Instance of the previous task, that this task is supposed to be a followup for
		// _targetLocation: TaskLocation - One of the locations that was listed in the possibleLocations entry
		params ["_previousTask", "_targetLocation"];


		// Returns Task Instance structure
	},
	onStart: {
		// Create BIS_fnc_task, tell user the task has started
	},
	completionCondition: {
		// Condition whether task is completed, is called regularly
		// Must return true or false
	},
	onComplete: {
		// Called when task is completed. Should set the BIS_fnc_task to completed
	},
}
*/
wolf_tasksystem_decl_TaskType = [
	["#type", "taskType"],
	["taskType", ""],
	["canBeInitial", true],
	["possibleLocations", []],
	["getContinuationType", { }],
	["createTask", { }],
	["onStart", { }],
	["completionCondition", { true }],
	["onComplete", { }]
	["failureCondition", { true }],
	["onFail", { }],
	["cancellationCondition", { true }], 
	["onCancel", { }]
];


/*
TaskInstance structure
{
	taskType: TaskType structure,
	taskID: "Unique Task ID used for bis_fnc_task*"
	location: [x,y,z] or "mapMarkerName",

	
	// This is set to automatically launch a new task once this one is finished
	// For example a dropoff task, that should be started after a delivery task
	// The new task will receive the ID of the previous task
	// Can be empty string to be "any type of task". Leave un-set to not have a continuation task
	continuationType: "taskType name" or TaskInstance,


	// Some parameters can overwrite the ones defined in tasktype. For their types look at the TaskType structure definition above
	continuationType: nil,
	start: {},
	completionCondition: {}
	onComplete: {}
}
*/
wolf_tasksystem_decl_TaskInstance = [
	["taskType", nil], // Reference to TaskType structure
	["taskID", ""], // Will be set by constructor

	["#create", { 
		// Generate a new task id, it must be unique, to accomplish that we simply hash some data that is always different
		private _timeHash = hashValue [systemTimeUTC, diag_tickTime];
		_self set ["taskID", format["task_%1", _timeHash]];
	 }],

	// It is possible to override these with custom ones, by default we just forward the call to the taskType
	["getContinuationType", { call ((_self get "taskType") get "getContinuationType"); }],
	["onStart", { call ((_self get "taskType") get "onStart"); }],
	["completionCondition", { call ((_self get "taskType") get "completionCondition"); }],
	["onComplete", { call ((_self get "taskType") get "onComplete"); }],
	["failureCondition", { call ((_self get "taskType") get "failureCondition"); }],
	["onFail", { call ((_self get "taskType") get "onFail"); }],
	["cancellationCondition", { call ((_self get "taskType") get "cancellationCondition"); }],
	["onCancel", { call ((_self get "taskType") get "onCancel") }]
];

wolf_tasksystem_activeTasks = [];
wolf_tasksystem_taskTypes = createHashMap;
