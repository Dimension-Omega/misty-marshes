extends Control

signal complete

func _ready() -> void:
	$StartGameButton.grab_focus()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("jump") and $AnimationPlayer.is_playing():
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


func _on_StartGameButton_pressed():
	$AnimationPlayer.play("intro")
	$StartGameButton.visible = false
