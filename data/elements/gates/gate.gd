tool
extends KinematicBody2D

enum EPosition {HORIZONTAL = 0, VERTICAL = 1}
export(EPosition) var initial_pos = EPosition.HORIZONTAL setget set_initial_pos

var gate_position : int

# Called when the node enters the scene tree for the first time.
func _ready():
	set_gate_position(initial_pos, true)

func trigger() -> void:
	set_gate_position(EPosition.HORIZONTAL if gate_position == EPosition.VERTICAL else EPosition.VERTICAL)

func set_gate_position(gatePosition: int, instant: bool = false) -> void:
	$AnimationPlayer.play("horizontal" if gatePosition == EPosition.HORIZONTAL else "vertical")
	if instant:
		$AnimationPlayer.seek(2, true)
	else:
		$AudioStreamPlayer.play()
	gate_position = gatePosition
	
func set_initial_pos(value: int) -> void:
	initial_pos = value
	rotation_degrees = -90 if initial_pos == EPosition.VERTICAL else 0
