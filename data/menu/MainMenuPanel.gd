extends Control

export var on_visible_focus : NodePath

func _on_Panel_visibility_changed() -> void:
	if visible:
		on_visible()

func _on_BackButton_pressed():
	visible = false
	owner.get_node('Buttons').visible = true

func on_visible() -> void:
	get_node(on_visible_focus).grab_focus()
	var mainNodes = get_tree().get_nodes_in_group('main')
	if mainNodes:
		var main = mainNodes[0]
		for i in range(1, 4):
			show_achievements(str(i), main.levels[str(i)].completed, main.levels[str(i)].secret_found)

func show_achievements(level: String, completed: bool, secretFound: bool) -> void:
	var achievementsPath = 'GridContainer/Level' + level + '/MarginContainer/HBoxContainer/Achievements/'
	get_node(achievementsPath + 'Completed').visible = completed
	get_node(achievementsPath + 'SecretFound').visible = secretFound
