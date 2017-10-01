fnc_maxWidthLengthHeightOf = {
    params ["_object"];
    private ["_bbr", "_p1", "_p2", "_maxWidth", "_maxLength", "_maxHeight"];

    _bbr = boundingBoxReal _object;
    _p1 = _bbr select 0;
    _p2 = _bbr select 1;
    _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
    _maxLength = abs ((_p2 select 1) - (_p1 select 1));
    _maxHeight = abs ((_p2 select 2) - (_p1 select 2));

    [_maxWidth, _maxLength, _maxHeight];
};

fnc_spawnInFrontOf = {
    params ["_object", "_thing", "_directionOffset"];
    private ["_spawnedObject", "_maxs", "_maxWidth", "_pos", "_objectDistanceFromTerrain"];

    if(isNil "_directionOffset") then {
      _directionOffset = 0;
    };
    _spawnedObject = createVehicle [
        _thing,
        getPos _object,
        [],
        0,
        "CAN_COLLIDE"
    ];

    _maxs = [_spawnedObject] call fnc_maxWidthLengthHeightOf;

    _maxWidth = (_maxs select 0) / 2;
    _maxLength = (_maxs select 1) / 2;

    _spawnedObject setVectorUp [0,0,1];
    _spawnedObject setDir ((direction _object) + _directionOffset);

    _pos = _object modelToWorld [0, _maxWidth, 0];

    _objectDistanceFromTerrain = ((getPosATL _object) select 2);
    _spawnedObject setPosATL ([(_pos select 0), (_pos select 1), _objectDistanceFromTerrain]);

    _spawnedObject
};

fnc_attachObjectTo = {
  params ["_objectClass", "_objectToAttachTo", "_inFrontOf"];
  private ["_newObject", "_objPos", "_objDir", "_objectToAttachToZ", "_maxs", "_maxWidth"];

  _newObject = [
      _inFrontOf,
      _objectClass
  ] call fnc_spawnInFrontOf;

  _maxs = [_newObject] call fnc_maxWidthLengthHeightOf;
  _maxWidth = (_maxs select 0);

  _newObject attachTo [_objectToAttachTo, [-_maxWidth + 1, 0, 0]];

  _objPos = getPos _newObject;
  _objDir = getDir _newObject;

  detach _newObject;
  _newObject setDir _objDir;

  _objectToAttachToZ = ((getPos _objectToAttachTo) select 2);
  _newObject setPos [(_objPos select 0), (_objPos select 1), _objectToAttachToZ];

  _newObject
};

fnc_spawnSimpleObjectInFrontOf ={
  params ["_simpleObjectP3DPath", "_inFrontOf", "_directionOffset"];
  private ["_inFrontOfPos", "_object"];

  if(isNil "_directionOffset") then {
    _directionOffset = 0;
  };

  _inFrontOfPos = _inFrontOf getRelPos [4, 0];
  _object = createSimpleObject [_simpleObjectP3DPath, _inFrontOfPos];
  _object setVectorUp [0,0,1];
  _object setPosATL ([(_inFrontOfPos select 0), (_inFrontOfPos select 1), 0]);
  _object setDir (getDir player + _directionOffset);

  _object
};

fnc_constructInitialRampAndBridgeSegment = {
  private ["_initialRamp", "_initialBridgeSegment"];

  _initialRamp = [
      "A3\Structures_F\Training\RampConcrete_F.p3d",
      player,
      180
  ] call fnc_spawnSimpleObjectInFrontOf;

  _initialBridgeSegment = [
      player,
      "Land_Pier_F"
  ] call fnc_spawnInFrontOf;

  _maxs = [_initialRamp] call fnc_maxWidthLengthHeightOf;
  _maxWidth = (_maxs select 0);

  _initialBridgeSegment attachTo [_initialRamp];

  _objPos = getPos _initialBridgeSegment;
  detach _initialBridgeSegment;

  _initialBridgeSegment setDir (getDir player + 90);

  _objectToAttachToZ = ((getPos _initialRamp) select 2) - 1.6;
  _initialBridgeSegment setPos [(_objPos select 0) - (_maxWidth + 2), (_objPos select 1), _objectToAttachToZ];
};

fnc_constructBridgeExtension = {

};

fnc_constructFinalRamp = {

};

player addAction ["Construct/Extend Bridge", {
  player playMove "AinvPknlMstpSnonWrflDr_medic5";
  [] spawn
  {
   sleep 5;
   player playAction "PlayerStand";
   sleep 5;

   _nearestBridgeSegment = ((nearestObjects [player, ["Land_Pier_F"], 25]) select 0);

   if(isNil "_nearestBridgeSegment") then {
     [
         player,
         "Land_Pier_F",
         90
     ] call fnc_spawnInFrontOf;
   } else {
     [
         "Land_Pier_F",
         _nearestBridgeSegment,
         player
     ] call fnc_attachObjectTo;
   };
  };
}];

[] call fnc_constructInitialRampAndBridgeSegment;
