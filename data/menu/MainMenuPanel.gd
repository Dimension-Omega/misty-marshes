extends Control

export var on_visible_focus : NodePath

func _on_Panel_visibility_changed() -> void:
	if visible:
		get_node(on_visible_focus).grab_focus()

func _on_BackButton_pressed():
	visible = false
	owner.get_node('Buttons').visible = true
