extends KinematicBody2D

export var trigger_node : NodePath

func duality(color: String) -> void:
	var _isWhite := color == 'white'
	$AnimationPlayer.play("RESET")

func interact() -> void:
	if $FrogBlack.visible:
		$AnimationPlayer.play("InteractBlack")
	else:
		var triggerNode = get_node(trigger_node)
		if is_instance_valid(triggerNode) and triggerNode.is_inside_tree():
			assert(triggerNode.has_method('trigger'))
			triggerNode.trigger()
