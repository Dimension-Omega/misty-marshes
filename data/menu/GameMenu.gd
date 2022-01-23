extends Control

const AUDIO_MASTER_BUS := 0

func _ready():
	$Panel/Buttons/VBoxContainer/Continue.grab_focus()
	var isMute : bool = AudioServer.is_bus_mute(AUDIO_MASTER_BUS)
	$Panel/Buttons/VBoxContainer/Mute.text = 'Unmute' if isMute else 'Mute'

func _on_Continue_pressed():
	queue_free()

func _on_Mute_pressed():
	AudioServer.set_bus_mute(AUDIO_MASTER_BUS, not AudioServer.is_bus_mute(AUDIO_MASTER_BUS))
	queue_free()

func _on_Exit_pressed():
	var main = get_node_or_null('/root/Main')
	if not main: 
		printerr('No main scene detected')
		return
	main.back_to_main_menu()
	queue_free()
