extends KinematicBody2D

const SPEED := 300
const GRAVITY_ACCELARATION := 1200
const JUMP_VELOCITY := -850
const MAX_DOWN_VELOCITY := 500.0
const COYOTE_TIME := 0.1

const BLACK_LAYER := 1
const WHITE_LAYER := 2

var velocity := Vector2.ZERO
var input_velocity := Vector2.ZERO
var airtime : float = 0
var time_since_last_jump : float = 0
var up_direction := Vector2.UP
var interactable : Node2D
var available_interactables : Array = []

onready var sprite : Sprite = $PlayerBlack

func _unhandled_input(event) -> void:
	if event.is_action_pressed("jump"):
		if can_interact(interactable):
				interactable.interact()
		elif can_jump():
			jump()

func can_jump() -> bool:
	return is_on_floor() or (airtime < COYOTE_TIME and time_since_last_jump > COYOTE_TIME)

func _physics_process(delta: float) -> void:
	input_velocity = get_input_velocity()
	set_direction(input_velocity.x)
	velocity.x = input_velocity.x * SPEED
	velocity.y = apply_gravity(velocity.y, delta)
	var remainingVelocity = move_and_slide(velocity, up_direction)
	velocity = remainingVelocity
	time_since_last_jump += delta
	if is_on_floor():
		if airtime > 0: print(airtime)
		airtime = 0
	else:
		airtime += delta
	
	interactable = select_interactable(available_interactables)

func jump() -> void:
	velocity.y = JUMP_VELOCITY
	time_since_last_jump = 0

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
func the_world_is_changing(color: String) -> void:
	var isWhite := color == 'white'
	var previousSprite = sprite
	sprite = $PlayerWhite if isWhite else $PlayerBlack
	sprite.flip_h = previousSprite.flip_h
	defer_world_collisions(color == 'black', true, false)

func duality(color: String) -> void:
	#defer_world_collisions(not isWhite)
	defer_world_collisions(color == 'black', false, true)

func defer_world_collisions(collideWithBlack: bool, onlyAdd: bool = false, onlyRemove: bool = false) -> void:
	call_deferred('world_collisions', collideWithBlack, onlyAdd, onlyRemove)

func world_collisions(collideWithBlack: bool, onlyAdd: bool = false, onlyRemove: bool = false) -> void:
	if not onlyAdd:
		collision_mask &= ~(1 << (WHITE_LAYER if collideWithBlack else BLACK_LAYER))
	if not onlyRemove:
		collision_mask |= 1 << (BLACK_LAYER if collideWithBlack else WHITE_LAYER)

# Interactable
func _on_InteractSensor_body_entered(body: Node):
	add_interactable(body)

func _on_InteractSensor_body_exited(body: Node):
	remove_interactable(body)

func _on_InteractSensor_area_entered(area: Area2D):
	add_interactable(area)

func _on_InteractSensor_area_exited(area: Area2D):
	remove_interactable(area)

func add_interactable(node: Node2D) -> void:
	if node.is_in_group('interactable'):
		available_interactables.append(node)

func remove_interactable(node: Node2D) -> void:
	if node in available_interactables:
		available_interactables.erase(node)

func select_interactable(interactables: Array) -> Node2D:
	if not interactables:
		return null
	var facingInteractables := []
	for availableInteractable in interactables:
		if can_interact(availableInteractable):
			facingInteractables.append(availableInteractable)
	if not facingInteractables:
		return interactables[0] # we don't care as it won't interact, only prevent jump
	if facingInteractables.size() == 1:
		return facingInteractables[0]
	
	return return_closest_node(facingInteractables)

func can_interact(node: Node2D) -> bool:
	if not is_instance_valid(node) or not node.is_inside_tree():
		return false
	return facing_position(node.global_position) or node.is_in_group('always interactable')

func return_closest_node(nodes: Array) -> Node2D:
	var minDist : float = INF
	var closestNode : Node2D = null
	for node in nodes:
		var dist = global_position.distance_squared_to(node.global_position)
		if dist < minDist:
			minDist = dist
			closestNode = node
	return closestNode
# Etc
func facing_position(pos: Vector2) -> bool:
	var isLeft = sprite.flip_h
	var distance = pos - global_position
	return isLeft and distance.x < 0 or !isLeft and distance.x > 0
