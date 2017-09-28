fnc_maxWidthLengthHeightOf = {
    params ["_object"];
    private ["_bbr", "_p1", "_p2", "_maxWidth", "_maxLength", "_maxHeight"];

    _bbr = boundingBoxReal _spawnedObject;
    _p1 = _bbr select 0;
    _p2 = _bbr select 1;
    _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
    _maxLength = abs ((_p2 select 1) - (_p1 select 1));
    _maxHeight = abs ((_p2 select 2) - (_p1 select 2));

    [_maxWidth, _maxLength, _maxHeight];
};

fnc_spawnInFrontOf = {
    params ["_object", "_thing"];
    private ["_spawnedObject", "_maxs", "_maxWidth", "_pos", "_objectHeight"];

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
    _spawnedObject setDir ((direction _object) + 90);

    _pos = _object modelToWorld [0,_maxWidth,0];

    _objectHeight = ((getPosASL _object) select 2) * 2;
    _spawnedObject setPos ([(_pos select 0), (_pos select 1), (_pos select 2) - _objectHeight]);

    _spawnedObject
};

fnc_attachObjectTo = {
  params ["_objectClass", "_objectToAttachTo", "_inFrontOf"];
  private ["_newObject", "_objPos", "_objDir", "_objectToAttachToHeight"];

  _newObject = [
      _inFrontOf,
      _objectClass
  ] call fnc_spawnInFrontOf;

  _newObject attachTo [_objectToAttachTo];

  _objPos = getPos _newObject;
  _objDir = getDir _newObject;

  detach _newObject;
  _newObject setDir _objDir;
  _objectToAttachToHeight = ((getPos _objectToAttachTo) select 2);
  _newObject setPos [(_objPos select 0), (_objPos select 1), _objectToAttachToHeight];

  _newObject
};

[
    player,
    "Land_Pier_F"
] call fnc_spawnInFrontOf;

[
    "Land_Pier_F",
    nearestObject [player, "Land_Pier_F"],
    player
] call fnc_attachObjectTo;
