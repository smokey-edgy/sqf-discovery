fnc_spawnInFrontOf = {
    params ["_object", "_thing"];
    private ["_spawnedObject","_bbr","_p1","_p2", "_maxLength"];

    _spawnedObject = createVehicle [
        _thing,
        getPos _object,
        [],
        0,
        "CAN_COLLIDE"
    ];

    _bbr = boundingBoxReal _spawnedObject;
    _p1 = _bbr select 0;
    _p2 = _bbr select 1;
    _maxLength = abs ((_p2 select 1) - (_p1 select 1)) / 2;

    _spawnedObject setVectorUp [0,0,1];
    _spawnedObject setDir (direction _object);

    _spawnedObject setPos (_object modelToWorld [0,_maxLength,0]);
};

[
    player,
    "Land_Pier_small_F"
] call fnc_spawnInFrontOf;
