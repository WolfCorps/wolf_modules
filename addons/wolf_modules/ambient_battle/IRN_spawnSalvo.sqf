		params["_sound","_pos","_shots","_delay","_volume"];
		sleep _delay;
		for "_i" from 0 to _shots do {
			playSound3D [_sound, nil, false, _pos, _volume, 0, 0]; // play sound
			sleep random [0.02,0.2,0.5];
		};