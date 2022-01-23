extends Area2D

export var trigger_node : NodePath
export var only_on_black : bool = false
export var only_on_white : bool = false

var is_on : bool = false

onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	if only_on_black:
		$SwitchOff.add_to_group('black')
		$SwitchOn.add_to_group('black')
	if only_on_white:
		$SwitchOff.add_to_group('white')
		$SwitchOn.add_to_group('white')

func the_world_is_changing(color: String) -> void:
	set_to(is_on)
	if (only_on_black and color == 'black') or (only_on_white and color == 'white'):
		collision_shape.set_deferred('disabled', false)
	elif (only_on_black and color != 'black') or (only_on_white and color != 'white'):
		collision_shape.set_deferred('disabled', true)
		set_to(is_on)

func interact() -> void:
	set_to(not is_on)
	var triggerNode = get_node_or_null(trigger_node)
	if is_instance_valid(triggerNode) and triggerNode.is_inside_tree():
		assert(triggerNode.has_method('trigger'))
		triggerNode.trigger()

func set_to(on: bool) -> void:
	$SwitchOff.visible = not on
	$SwitchOn.visible = on
	is_on = on
