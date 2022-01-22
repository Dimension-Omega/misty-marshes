extends KinematicBody2D

export var trigger_node : NodePath

var world_color: String

func the_world_is_changing(color: String) -> void:
	var _isWhite := color == 'white'
	$AnimationPlayer.play("RESET")
	world_color = color

func interact() -> void:
	if world_color == 'black':
		$AnimationPlayer.play("InteractBlack")
	else:
		var triggerNode = get_node(trigger_node)
		if is_instance_valid(triggerNode) and triggerNode.is_inside_tree():
			assert(triggerNode.has_method('trigger'))
			triggerNode.trigger()
