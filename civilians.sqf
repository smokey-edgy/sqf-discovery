SE_fnc_nearestRoad = {
  params ["_xPos", "_yPos"];
  private ["_distances", "_nearestRoad"];

  _distances = [5, 10, 100, 500, 1000, 2000, 5000, 10000, 50000];

  {
    scopeName "findingNearestRoad";

    _nearestRoad = [_xPos, _yPos] nearRoads _x select 0;
    if (!isNil "_nearestRoad") then {
      breakOut "findingNearestRoad";
    };
  } forEach _distances;

  _nearestRoad
};

SN_fnc_moveUnit = {
  params ["_unit", "_anim"];

  _unit disableAI "ANIM";

  while{alive _unit} do{
	   _unit playMove _anim;
	    waitUntil{animationState _unit != _anim};
  };
};

SE_fnc_aPointDownTheRoad = {
  params ["_roadToStartOn"];
  private ["_somewhereDownTheRoad", "_i"];

  _somewhereDownTheRoad = roadsConnectedTo _roadToStartOn select 0;

  for "_i" from 0 to 25 do {
    _somewhereDownTheRoad = roadsConnectedTo _somewhereDownTheRoad select 0;
  };

  _somewhereDownTheRoad
};

SE_fnc_villagerWalkingDownTheRoad = {
  params ["_xPos", "_yPos"];
  private ["_villagerGroup", "_leader", "_nearestRoad", "_aPointDownTheRoad", "_wp"];

  _nearestRoad = ([_xPos, _yPos] call SE_fnc_nearestRoad);

  _villagerGroup = [position _nearestRoad, Civilian, ["Afghan_Civilian1"]] call BIS_fnc_spawnGroup;
  _leader = leader _villagerGroup;

  _aPointDownTheRoad = ([_nearestRoad] call SE_fnc_aPointDownTheRoad);

  _wp = _villagerGroup addWaypoint [position _aPointDownTheRoad, 0];
  _wp setWaypointSpeed "LIMITED";
  _wp setWaypointType "MOVE";

  _wp = _villagerGroup addWaypoint [position _nearestRoad, 0];
  _wp setWaypointSpeed "LIMITED";
  _wp setWaypointType "CYCLE";
};

_xPos = position player select 0;
_yPos = position player select 1;

([_xPos, _yPos] call SE_fnc_villagerWalkingDownTheRoad);


SE_fnc_strayDogWonderingAround = {};
SE_fnc_villagerWalkingDog = {};
SE_fnc_villagerWorkingInField = {};
SE_fnc_villagerSittingAtHome = {};
SE_fnc_villagerWatchingFromRoadside = {};
SE_fnc_villagerWatchingFromField = {};
SE_fnc_villagerWatchingInTheBush = {};
SE_fnc_villagerLoitering = {};
SE_fnc_villagerNervous = {};
SE_fnc_villagerWaving = {};
