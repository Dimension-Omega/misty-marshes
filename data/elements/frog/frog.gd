extends KinematicBody2D

export var trigger_node : NodePath

var world_color : String
var is_triggered : bool = false

func the_world_is_changing(color: String) -> void:
	var _isWhite := color == 'white'
	$AnimationPlayer.play("RESET")
	world_color = color
	set_white_sprite(is_triggered)

func interact() -> void:
	if world_color == 'black':
		$AnimationPlayer.play("InteractBlack")
	else:
		is_triggered = not is_triggered
		set_white_sprite(is_triggered)
		var triggerNode = get_node(trigger_node)
		if is_instance_valid(triggerNode) and triggerNode.is_inside_tree():
			assert(triggerNode.has_method('trigger'))
			triggerNode.trigger()

func set_white_sprite(isTriggered: bool) -> void:
	$FrogWhite.visible = not isTriggered
	$FrogWhiteTriggered.visible = isTriggered
