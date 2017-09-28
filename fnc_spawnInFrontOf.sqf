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
    private ["_spawnedObject", "_maxs", "_maxWidth", "_maxHeight", "_pos", "_objectHeight"];

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

[
    player,
    "Land_Pier_F"
] call fnc_spawnInFrontOf;

_start = nearestObject [player, "Land_Pier_F"];

_obj = [
    player,
    "Land_Pier_F"
] call fnc_spawnInFrontOf;

_obj attachTo [_start];

_objPos = getPos _obj;
_objDir = getDir _obj;
detach _obj;
_obj setDir _objDir;
_startHeight = ((getPos _start) select 2);
_obj setPos [(_objPos select 0), (_objPos select 1), _startHeight];
