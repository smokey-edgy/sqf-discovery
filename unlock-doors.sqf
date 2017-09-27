_nearestBuildings = nearestObjects [position player, ["building"], 10];
_nearest = (_nearestBuildings select 0);
_names = animationNames _nearest;

hint format ["names %1", _names];

{
  _nearest animate [_x, 1, 0.2];
} forEach _names;
