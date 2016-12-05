SE_fnc_nearestRoad = {
  params ["_xPos", "_yPos"];
  private ["_distances", "_nearestRoad"];

  _distances = [100, 500, 1000, 2000, 5000, 10000, 50000];

  {
    scopeName "findingNearestRoad";

    _nearestRoad = [_xPos, _yPos] nearRoads _x select 0;
    if (!isNil "_nearestRoad") then {
      breakOut "findingNearestRoad";
    }
  } forEach _distances;

  position _nearestRoad
};

SE_fnc_villagerWalkingDownTheRoad = {
  params ["_xPos", "_yPos"];
  private ["_villagerGroup", "_leader", "_nearestRoad", "_wp"];

  _villagerGroup = [[_xPos, _yPos], Civilian, ["Afghan_Civilian1"]] call BIS_fnc_spawnGroup;
  _leader = leader _villagerGroup;

  _nearestRoad = ([_xPos, _yPos] call SE_fnc_nearestRoad);

  _wp = _villagerGroup addWaypoint [_nearestRoad, 0];
  _wp setWaypointSpeed "LIMITED";
  _wp setWaypointType "MOVE";
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
