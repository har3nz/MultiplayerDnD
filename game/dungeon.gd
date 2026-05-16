extends Node2D

@export var _dimensions: Vector2i = Vector2i(7, 5)
@export var _start: Vector2i = Vector2i(0,3)

var dungeon: Array

func _ready() -> void:
    _init_dungeon()
    _print_dungeon()

func _init_dungeon() -> void:
    for x in _dimensions.x:
        dungeon.append([])
        for y in _dimensions.y:
            dungeon[x].append(0)

func _place_entrance() -> void:
    if _start.x < 0 or _start.x >= _dimensions.x:
        _start.x = randi_range(0, _dimensions.x - 1)
    if _start.y < 0 or _start.y >= _dimensions.y:
        _start.y = randi_range(0, _dimensions.y - 1)
    dungeon[_start.x][_start.y] = "S"

func _print_dungeon() -> void:
    var dungeon_as_string: String = ""
    for y in range(_dimensions.x):
        for x in _dimensions.x:
            dungeon_as_string += "[" + str(dungeon[x][y]) + "]"
        dungeon_as_string += "\n"
    print(dungeon_as_string)
