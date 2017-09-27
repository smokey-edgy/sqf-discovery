player addAction ["***Open doorz***", {
  _nearestBuildings = nearestObjects [position player, ["building"], 10];
  _nearest = (_nearestBuildings select 0);
  _names = animationNames _nearest;

  {
    _nearest animate [_x, 1, 0.7];
  } forEach _names;
}];

player addAction ["***Close doorz***", {
  _nearestBuildings = nearestObjects [position player, ["building"], 10];
  _nearest = (_nearestBuildings select 0);
  _names = animationNames _nearest;

  {
    _nearest animate [_x, 0, 0.7];
  } forEach _names;
}];
