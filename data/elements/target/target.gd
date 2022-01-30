extends Area2D

func _on_Target_body_entered(body: Node):
	if body.has_meta('player'):
		$AnimationPlayer.play("reached")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == 'reached':
		get_tree().call_group('main', 'on_target_hit')
