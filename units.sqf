SE_fnc_walkCivilianToNearestRoad = {

  _civs = [position player, Civilian, ["Afghan_Civilian1"]] call BIS_fnc_spawnGroup;
  _leader = leader _civs;

  _nearestRoad = position _leader nearRoads 100 select 0;

  _wp = _civs addWaypoint [position _nearestRoad, 0];
  _wp setWaypointSpeed "LIMITED";
  _wp setWaypointType "MOVE";

};

(call SE_fnc_walkCivilianToNearestRoad);
