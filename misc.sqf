// Afghan Civilian animations:
// AmovPercMwlkSnonWnonDl -> Confident
// AmovPercMwlkSnonWnonDfr -> Cautious
// HubStandingUC_move1 -> Observing
// HubWave_move1 -> Waving
// _nearest setVariable ['bis_disabled_Door_1',0,false];
_nearestBuildings = nearestObjects [position player, ["building"], 10];
_nearest = (_nearestBuildings select 0);
_names = animationNames _nearest;

hint format ["names %1", _names];
_building animate ["Door_1_rot", 1, true];
