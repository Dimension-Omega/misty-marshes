extends StaticBody2D


func break() -> void:
	$AnimationPlayer.play("break")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == 'break':
		queue_free()
