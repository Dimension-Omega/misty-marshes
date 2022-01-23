extends Control

func _ready():
	$Panel/Buttons/VBoxContainer/Continue.grab_focus()

func _on_Continue_pressed():
	queue_free()

func _on_Mute_pressed():
	queue_free()

func _on_Exit_pressed():
	var main = get_node_or_null('/root/Main')
	if not main: 
		printerr('No main scene detected')
		return
	main.back_to_main_menu()
	queue_free()
