extends KinematicBody2D


export var left_limit : NodePath
export var right_limit : NodePath

onready var left_target : Node2D = get_node(left_limit)
onready var right_target : Node2D = get_node(right_limit)

var velocity : Vector2
var world_color : String
var is_triggered : bool = false

const SPEED := 400
const BASE_SCALE := 0.7
const UP_VECTOR := Vector2.UP
const SNAP_VECTOR := Vector2.DOWN * 100
const REACHED_TARGET_DISTANCE := 10.0
const INTERACTABLE_LAYER := 11

func _physics_process(_delta: float) -> void:
	if has_reached_target(velocity.x):
		set_physics_process(false)
		velocity.x = 0
	var _rem = move_and_slide_with_snap(velocity, SNAP_VECTOR, UP_VECTOR)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == 'boulder':
			collision.collider.break()
			set_physics_process(false)

func the_world_is_changing(color: String) -> void:
	var isWhite := color == 'white'
	world_color = color
	if isWhite:
		collision_layer &= ~ (1 << INTERACTABLE_LAYER)
		set_physics_process(false)
	else:
		collision_layer |= 1 << INTERACTABLE_LAYER

func interact() -> void:
	if world_color == 'white': return
	var playerGroup = get_tree().get_nodes_in_group('player')
	var direction = -1
	if not playerGroup:
		direction = sign(randf() - 0.5)
	else:
		var player = playerGroup[0]
		var dist = player.global_position - global_position
		direction = -sign(dist.x)
	velocity = Vector2(direction, 0) * SPEED
	$MooseBlack.scale.x = direction
	$MooseWhite.scale.x = direction * BASE_SCALE
	set_physics_process(true)
	

func has_reached_target(velocityX: float) -> bool:
	var target : Node2D = left_target
	if velocityX > 0:
		target = right_target
	var distanceFromTarget = abs(target.global_position.x - global_position.x)
	return  distanceFromTarget < REACHED_TARGET_DISTANCE
