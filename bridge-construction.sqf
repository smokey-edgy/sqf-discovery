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

  [_initialRamp] call fnc_drawBoundingBox;

  _initialBridgeSegment = [
      player,
      "Land_Pier_F",
      90,
      10,
      -1.2
  ] call fnc_spawnInFrontOf;

  [_initialBridgeSegment, "Destroy Bridge Segment"] call fnc_addDestroyActionTo;
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

  [_finalBridgeSegment, "Destroy Bridge Segment"] call fnc_addDestroyActionTo;

  _maxs = [_finalBridgeSegment] call fnc_maxWidthLengthHeightOf;
  _maxWidth = (_maxs select 0);

  _finalRamp = [
      "A3\Structures_F\Training\RampConcrete_F.p3d",
      player,
      360,
      _maxWidth + 3
  ] call fnc_spawnSimpleObjectInFrontOf;

  [_finalRamp, "Destroy Ramp"] call fnc_addDestroyActionTo;
};

fnc_drawBoundingBox = {
  params ["_object"];

  _object call {
      private ["_obj","_bb","_bbx","_bby","_bbz","_arr","_y","_z"];
      _obj = _this;
      _bb = {
          _bbx = [_this select 0 select 0, _this select 1 select 0];
          _bby = [_this select 0 select 1, _this select 1 select 1];
          _bbz = [_this select 0 select 2, _this select 1 select 2];
          _arr = [];
          0 = {
              _y = _x;
              0 = {
                  _z = _x;
                  0 = {
                      0 = _arr pushBack (_obj modelToWorld [_x,_y,_z]);
                  } count _bbx;
              } count _bbz;
              reverse _bbz;
          } count _bby;
          _arr pushBack (_arr select 0);
          _arr pushBack (_arr select 1);
          _arr
      };
      bbox = boundingBox _obj call _bb;
      bboxr = boundingBoxReal _obj call _bb;
      addMissionEventHandler ["Draw3D", {
          for "_i" from 0 to 7 step 2 do {
              drawLine3D [
                  bbox select _i,
                  bbox select (_i + 2),
                  [0,0,1,1]
              ];
              drawLine3D [
                  bboxr select _i,
                  bboxr select (_i + 2),
                  [0,1,0,1]
              ];
              drawLine3D [
                  bbox select (_i + 2),
                  bbox select (_i + 3),
                  [0,0,1,1]
              ];
              drawLine3D [
                  bboxr select (_i + 2),
                  bboxr select (_i + 3),
                  [0,1,0,1]
              ];
              drawLine3D [
                  bbox select (_i + 3),
                  bbox select (_i + 1),
                  [0,0,1,1]
              ];
              drawLine3D [
                  bboxr select (_i + 3),
                  bboxr select (_i + 1),
                  [0,1,0,1]
              ];
          };
      }];
  };
};

fnc_addDestroyActionTo = {
  params ["_object", "_actionText"];
  private ["_trigger", "_bbr", "_p1", "_p2", "_x1", "_x2", "_y1", "_y2", "_z1", "_z2"];

  _bbr = boundingBoxReal _object;
  _p1 = _bbr select 0;
  _p2 = _bbr select 1;
  _x1 = _p1 select 0;
  _y1 = _p1 select 1;
  _x2 = _p2 select 0;
  _y2 = _p2 select 1;
  _z1 = _p1 select 2;
  _z2 = _p2 select 2;

  _triggerPosition = _object modelToWorld [_x2, _y1 + ((_y2 - _y1) / 2), _z2];

  _trigger = createTrigger ["EmptyDetector", _triggerPosition];
  _trigger setTriggerArea  [5, 5, 45, false];
  _trigger setTriggerActivation ["ANY", "PRESENT", true];
  _trigger setTriggerStatements ["{isPlayer _x} count thisList > 0;", "
   player addAction [""" + _actionText + """, {
     _inFrontOfPlayer = player getRelPos [10, 0];
     _nearestObj = nearestObject [_inFrontOfPlayer, """ + typeOf _object + """];
     player playMove ""AinvPknlMstpSnonWrflDr_medic5"";
     [_nearestObj, (_this select 3)] spawn {
       sleep 5;
       player playAction ""PlayerStand"";
       sleep 5;
       deleteVehicle (_this select 0);
       _actionIds = actionIDs player;
       _actionIdsCount = count _actionIds;
       player removeAction (_actionIds select (_actionIdsCount - 1));
       deleteVehicle (_this select 1);
     };
   }, thisTrigger];
  ", "
    _actionIds = actionIDs player;
    _actionIdsCount = count _actionIds;
    player removeAction (_actionIds select (_actionIdsCount - 1));
  "];

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
     _newBridgeSegment = [
         "Land_Pier_F",
         _nearestBridgeSegment,
         player
     ] call fnc_attachObjectTo;
     [_newBridgeSegment, "Destroy Bridge Segment"] call fnc_addDestroyActionTo;
   };
 };
}];

player addAction ["Complete Bridge", {
  player playMove "AinvPknlMstpSnonWrflDr_medic5";
  [] spawn {
   sleep 5;
   player playAction "PlayerStand";
   sleep 5;

   [] call fnc_constructFinalRampAndBridgeSegment;
 };
}];
