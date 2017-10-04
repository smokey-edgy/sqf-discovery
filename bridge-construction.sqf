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
    params ["_object", "_thing", "_directionOffset", "_distanceAhead", "_elevation"];
    private ["_spawnedObject", "_maxs", "_maxWidth", "_pos", "_objectDistanceFromTerrain"];

    if(isNil "_directionOffset") then {
      _directionOffset = 0;
    };

    if(isNil "_distanceAhead") then {
      _distanceAhead = 0;
    };

    if(isNil "_elevation") then {
      _elevation = 0;
    };

    _spawnedObject = createVehicle [
        _thing,
        (getPos _object),
        [],
        0,
        "CAN_COLLIDE"
    ];

    _maxs = [_spawnedObject] call fnc_maxWidthLengthHeightOf;

    _maxWidth = (_maxs select 0) / 2;
    _maxLength = (_maxs select 1) / 2;

    _spawnedObject setVectorUp [0,0,1];
    _spawnedObject setDir ((direction _object) + _directionOffset);

    _pos = _object modelToWorld [0, _maxWidth + _distanceAhead, 0];

    _spawnedObject setPos ([(_pos select 0), (_pos select 1), (_pos select 2) + _elevation]);

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
  params ["_simpleObjectP3DPath", "_inFrontOf", "_directionOffset", "_distanceAhead"];
  private ["_inFrontOfPos", "_object"];

  if(isNil "_directionOffset") then {
    _directionOffset = 0;
  };

  if(isNil "_distanceAhead") then {
    _distanceAhead = 0;
  };

  _inFrontOfPos = _inFrontOf getRelPos [4 + _distanceAhead, 0];
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
      "Land_Pier_F",
      90,
      10,
      -1.2
  ] call fnc_spawnInFrontOf;

};

fnc_constructBridgeExtension = {

};

fnc_constructFinalRampAndBridgeSegment = {
  private ["_finalRamp", "_finalBridgeSegment", "_maxs", "_maxWidth"];

  _nearestBridgeSegment = ((nearestObjects [player, ["Land_Pier_F"], 25]) select 0);

  _finalBridgeSegment = [
      "Land_Pier_F",
      _nearestBridgeSegment,
      player
  ] call fnc_attachObjectTo;

  _maxs = [_finalBridgeSegment] call fnc_maxWidthLengthHeightOf;
  _maxWidth = (_maxs select 0);

  _finalRamp = [
      "A3\Structures_F\Training\RampConcrete_F.p3d",
      player,
      360,
      _maxWidth + 3
  ] call fnc_spawnSimpleObjectInFrontOf;

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
     [] call fnc_constructInitialRampAndBridgeSegment;
   } else {
     [
         "Land_Pier_F",
         _nearestBridgeSegment,
         player
     ] call fnc_attachObjectTo;
   };
 };
}];

player addAction ["Complete Bridge", {
  player playMove "AinvPknlMstpSnonWrflDr_medic5";
  [] spawn
  {
   sleep 5;
   player playAction "PlayerStand";
   sleep 5;

   [] call fnc_constructFinalRampAndBridgeSegment;

 };
}];
