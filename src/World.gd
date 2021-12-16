extends Node2D

const Player = preload("res://src/Actors/Player/Player.tscn")
const Exit = preload("res://src/World/ExitDoor.tscn")
const Enemy = preload("res://src/Actors/Enemies/Enemy.tscn")

const grid_size = 32

export var borders := Rect2(1, 1, 38, 21)
export var starting_position := Vector2(ceil(38 / 2), ceil(21 / 2))
export var steps := 200
export var use_random_seed = true
export var map_seed := 'A seed'
export var min_room_size := 2
export var max_room_size := 4
export var enemy_spawn_chance := 0.5
export var enemy_spawn_distance := 5

onready var tileMap = $TileMap

func _ready() -> void:
	randomize_map()
	generate_level()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		reload_level()
		generate_level()

func generate_level():
	var walker = Walker.new(starting_position, borders, min_room_size, max_room_size)
	var map = walker.walk(steps)
	
	spawn_player(map)
	spawn_enemies(walker)
	spawn_exit(walker)

	walker.queue_free()
	
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)

func randomize_map():
	if use_random_seed:
		randomize()
	else:
		seed(map_seed.hash())

func spawn_player(map: Array):
	var player = Player.instance()
	add_child(player)
	player.position = map.front() * grid_size

func spawn_exit(walker: Walker):
	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.get_end_room().position * grid_size
	exit.connect("leaving_level", self, "reload_level")
	
func spawn_enemies(walker: Walker):
	var rooms = walker.rooms.duplicate(true)
	var player: Player = get_tree().current_scene.get_node("Player")
	for room in rooms:
		if chance(enemy_spawn_chance):
			var enemy = Enemy.instance()
			enemy.position = room.position * grid_size
			if enemy.position.distance_to(player.position) > enemy_spawn_distance * grid_size:
				add_child(enemy)
	

func chance(perc: float) -> bool:
	return randf() >= perc


func reload_level() -> void:
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
