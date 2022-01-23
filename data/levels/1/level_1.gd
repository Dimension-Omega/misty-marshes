extends Node2D

var secret_found : bool = false

func _ready():
	$Cinematic/Villain/AnimationPlayer.play("laugh")
	$Cinematic/Camera2D.current = true

func duality(_color: String) -> void:
	#var toWhite : bool = color == 'white'
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'laugh':
		$Cinematic.queue_free()
		var camera = get_node_or_null('/root/Main/Camera2D')
		if camera:
			camera.current = true
