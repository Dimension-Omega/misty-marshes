extends KinematicBody2D

const SPEED := 300
const GRAVITY_ACCELARATION := 1200
const JUMP_VELOCITY := -850
const MAX_DOWN_VELOCITY := 500.0

const BLACK_LAYER := 1
const WHITE_LAYER := 2

var velocity := Vector2.ZERO
var input_velocity := Vector2.ZERO
var up_direction := Vector2.UP
var interactable : Node2D

onready var sprite : Sprite = $PlayerBlack

func _unhandled_input(event) -> void:
	if event.is_action_pressed("jump"):
		if is_instance_valid(interactable) and interactable.is_inside_tree():
			if facing_position(interactable.global_position):
				interactable.interact()
		elif is_on_floor():
			jump()

func _physics_process(delta: float) -> void:
	input_velocity = get_input_velocity()
	set_direction(input_velocity.x)
	velocity.x = input_velocity.x * SPEED
	velocity.y = apply_gravity(velocity.y, delta)
	var remainingVelocity = move_and_slide(velocity, up_direction)
	velocity = remainingVelocity

func jump() -> void:
	velocity.y = JUMP_VELOCITY

func apply_gravity(velocityY: float, delta: float) -> float:
	if velocityY >= MAX_DOWN_VELOCITY:
		return MAX_DOWN_VELOCITY
	return velocityY + GRAVITY_ACCELARATION * delta

func get_input_velocity() -> Vector2:
	return Input.get_vector("left", "right", "down", "up", 0.1)
	
func set_direction(inputVelocityX: float) -> void:
	if abs(inputVelocityX) < 1: return
	sprite.flip_h = inputVelocityX < 0
	#$InteractSensor.scale.x = -1 if inputVelocityX < 0 else 1

# Duality Section
func duality(color: String) -> void:
	var isWhite := color == 'white'
	defer_world_collisions(not isWhite)
	var previousSprite = sprite
	sprite = $PlayerWhite if isWhite else $PlayerBlack
	sprite.flip_h = previousSprite.flip_h

func defer_world_collisions(collideWithBlack: bool) -> void:
	call_deferred('world_collisions', collideWithBlack)

func world_collisions(collideWithBlack: bool) -> void:
	collision_mask &= ~(1 << (WHITE_LAYER if collideWithBlack else BLACK_LAYER))
	collision_mask |= 1 << (BLACK_LAYER if collideWithBlack else WHITE_LAYER)

# Interactable
func _on_InteractSensor_body_entered(body: Node):
	if body.is_in_group('interactable'):
		interactable = body

func _on_InteractSensor_body_exited(body: Node):
	if body == interactable:
		interactable = null

# Etc
func facing_position(pos: Vector2) -> bool:
	var isLeft = sprite.flip_h
	var distance = pos - global_position
	return isLeft and distance.x < 0 or !isLeft and distance.x > 0
