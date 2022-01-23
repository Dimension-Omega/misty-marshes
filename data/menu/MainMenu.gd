extends Control

onready var buttons : Control = $Buttons
onready var levels_button : Button = $Buttons/VBoxContainer/LevelsButton

var last_panel : String = ''

onready var level_buttons = [
	$LevelsPanel/GridContainer/Level1/MarginContainer/HBoxContainer/Level_1,
	$LevelsPanel/GridContainer/Level2/MarginContainer/HBoxContainer/Level_2,
	$LevelsPanel/GridContainer/Level3/MarginContainer/HBoxContainer/Level_3,
]
onready var mute_button = $MuteButton
const AUDIO_MASTER_BUS := 0

var main 

func _ready() -> void:
	var mainGroup = get_tree().get_nodes_in_group('main')
	if mainGroup:
		main = mainGroup[0]
	levels_button.grab_focus()
	if main:
		for i in range(level_buttons.size()):
			var levelButton : Button = level_buttons[i]
			if not levelButton.is_connected("pressed", main, 'load_level_and_set_world'):
				var _conErr = levelButton.connect("pressed", main, 'load_level_and_set_world', [i+1])
	if ProjectSettings.get_setting('application/config/is_html'):
		$Buttons/VBoxContainer/LevelsButton.focus_neighbour_top = "../Credits"
		$Buttons/VBoxContainer/LevelsButton.focus_previous = "../Credits"
		$Buttons/VBoxContainer/Credits.focus_neighbour_bottom = "../LevelsButton"
		$Buttons/VBoxContainer/Credits.focus_next = "../LevelsButton"
		$Buttons/VBoxContainer/Exit.queue_free()
	refresh_mute_button()

func refresh_mute_button() -> void:
	mute_button.text = 'Unmute' if AudioServer.is_bus_mute(AUDIO_MASTER_BUS) else 'Mute'

func _on_Exit_pressed():
	get_tree().quit(0)

func _on_LevelsButton_pressed():
	$LevelsPanel.visible = true
	buttons.visible = false
	last_panel = 'levels'

func _on_Buttons_visibility_changed():
	if buttons.visible:
		var but : Button = levels_button
		if last_panel == 'help':
			but = $Buttons/VBoxContainer/Help
		elif last_panel == 'credits':
			but = $Buttons/VBoxContainer/Credits
		but.grab_focus()

func _on_Credits_pressed():
	$CreditsPanel.visible = true
	buttons.visible = false
	last_panel = 'credits'

func _on_Help_pressed():
	$HelpPanel.visible = true
	buttons.visible = false
	last_panel = 'help'

func _on_MuteButton_pressed():
	AudioServer.set_bus_mute(AUDIO_MASTER_BUS, not AudioServer.is_bus_mute(AUDIO_MASTER_BUS))
	refresh_mute_button()

func _on_LicensesPopupCloseButton_pressed():
	$CreditsPanel/LicensesPopup.visible = false


func _on_ViewLicensesButton_pressed():
	$CreditsPanel/LicensesPopup.popup()
	#$CreditsPanel/LicensesPopup/Panel/RichTextLabel.get_child(0).grab_focus()
