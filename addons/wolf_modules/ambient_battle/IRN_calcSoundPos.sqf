		params ["_center","_dist","_headPos"];
		_posP = getPosASL player;	//getpos player
		_posC = getPosASL _center;	//getpos of center
		_direction = _posC vectorDiff _posP; //get desired positon of selfiestick headgear
		//TODO add safeguard for players that manage to get very far away
		if (vectorMagnitude _direction < _dist) then { //if center is closer than _dist, set pos directly at center
			_headPos = _posC;
		} else { //else set in direction of center at _dist meters away
			_dirNorm = vectorNormalized _direction;
			_direction = _dirNorm vectorMultiply _dist;
			_headPos = _posP vectorAdd _direction;
		};
		_headPos