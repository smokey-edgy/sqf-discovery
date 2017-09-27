SE_fnc_civilianWalkingToNearestRoad = {

  _civs = [position player, Civilian, ["Afghan_Civilian1"]] call BIS_fnc_spawnGroup;
  _leader = leader _civs;
  _nearestRoad = position _leader nearRoads 100 select 0;

  _wp = _civs addWaypoint [position _nearestRoad, 0];
  _wp setWaypointSpeed "LIMITED";
  _wp setWaypointBehaviour "CARELESS";
  _wp setWaypointType "MOVE";
};

SN_fnc_moveUnit = {
  _unit = _this select 0;
  _anim = _this select 1;

  _unit disableAI "ANIM";

  while{alive _unit} do{
	   _unit playMove _anim;
	    waitUntil{animationState _unit != _anim};
  };
};

SE_fnc_civilianWalkingDog = {
  _civs = [position player, Civilian, ["Afghan_Civilian1"]] call BIS_fnc_spawnGroup;
  _leader = leader _civs;

  _dog = _civs createUnit ["Fin_random_F", position _leader, [], 5, "CAN_COLLIDE"];
  _dog setVariable ["BIS_fnc_animalBehaviour_disable", true];

  0 = [_dog, _leader] spawn {
  	params ["_dog", "_leader"];

  	_dog playMove "Dog_Run";

  	while {alive _dog} do
  	{
  		_dog moveTo position player;
  		sleep 0.5;
  	};
  };

  _nearestRoad = position _leader nearRoads 100 select 0;

  _nearestHouse = nearestBuilding position _leader;

  _wp2 = _civs addWaypoint [position _nearestHouse, 0];
  _wp2 setWaypointSpeed "LIMITED";
  _wp2 setWaypointType "MOVE";

([_leader, "AmovPercMwlkSnonWnonDfr"] call SN_fnc_moveUnit);

};

(call SE_fnc_civilianWalkingToNearestRoad);
