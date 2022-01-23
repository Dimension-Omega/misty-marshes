extends Control

signal complete

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept") or event.is_action_pressed("jump"):
		skip()

func skip() -> void:
	$AnimationPlayer.seek(100, true)
	$AudioStreamPlayer.stop()
	_on_completion()

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name != 'intro': return
	_on_completion()

func _on_completion() -> void:
	var camera : Camera2D = get_tree().get_nodes_in_group('camera')[0]
	camera.current = true
	emit_signal("complete")
	queue_free()
