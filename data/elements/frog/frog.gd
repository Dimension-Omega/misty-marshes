extends KinematicBody2D


func duality(color: String) -> void:
	var _isWhite := color == 'white'
	$AnimationPlayer.play("RESET")

func interact() -> void:
	if $FrogBlack.visible:
		$AnimationPlayer.play("InteractBlack")
