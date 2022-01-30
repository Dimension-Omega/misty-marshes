extends Button

func _ready() -> void:
	var _err = connect("focus_exited", self, '_on_focus_exited')
	var _err2 = connect("pressed", self, '_on_button_pressed')
	var _err3 = connect("mouse_entered", self, "_on_mouse_entered")

func _on_focus_exited() -> void:
	get_tree().call_group('main', 'ui_button_focus_exited')
	
func _on_button_pressed() -> void:
	get_tree().call_group('main', 'ui_button_pressed')

func _on_mouse_entered() -> void:
	grab_focus()
