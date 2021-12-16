extends KinematicBody2D

enum State {
	IDLE,
	WANDER,
	CHASE
}

export var MAX_SPEED = 40
export var ACCELERATION = 300
export var FRICTION = 200
export var WANDER_TARGET_BUFFER = 4

onready var playerDetectionZone := $PlayerDetectionZone
onready var wanderController: WanderController = $WanderController

var state = State.IDLE
var velocity = Vector2.ZERO
var initial_position = Vector2.ZERO

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	match state:
		State.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				go_to_random_state()
		State.WANDER:
			seek_player()
			
			if wanderController.get_time_left() == 0:
				go_to_random_state()
				
			accelerate_towards_point(wanderController.target_position, delta)
			
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_BUFFER:
				go_to_random_state()
		State.CHASE:
			chase_player(delta)
	velocity = move_and_slide(velocity)
			
func seek_player() -> void:
	velocity = Vector2.ZERO
	if playerDetectionZone.can_see_player():
		state = State.CHASE

func chase_player(delta: float) -> void:
	if !playerDetectionZone.can_see_player():
		state = State.IDLE
	var player = playerDetectionZone.player
	if player != null:
		accelerate_towards_point(player.global_position, delta)
		
func accelerate_towards_point(point: Vector2, delta: float) -> void:
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func go_to_random_state() -> void:
	state = pick_random_state([State.IDLE, State.WANDER])
	wanderController.start_wander_timer(rand_range(1,2))
	
func pick_random_state(state_list: Array) -> int:
	state_list.shuffle()
	return state_list.pop_front()
