extends Node


var world_color : String = 'black'

var levels : Dictionary = {
	'2': {
		'scene': "res://data/levels/2/level_2.tscn"
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = true
	load_level(2)
	yield(get_tree().create_timer(0.1), 'timeout')
	set_world(world_color)

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.echo or not event.pressed: return
	if event.scancode == KEY_1:
		set_world('black')
	elif event.scancode == KEY_2:
		set_world('white')
	elif event.scancode == KEY_0:
		set_world('white' if world_color == 'black' else 'black')

func set_world(color: String) -> void:
	assert(color in ['white', 'black'])
	var whiteNodes = get_tree().get_nodes_in_group('white')
	var blackNodes = get_tree().get_nodes_in_group('black')
	var toWhite : bool = color == 'white'
	for whiteNode in whiteNodes:
		print('white: ', whiteNode.name)
		whiteNode.visible = toWhite
	for blackNode in blackNodes:
		print('black: ', blackNode.name)
		blackNode.visible = not toWhite
	
	get_tree().call_group('duality', 'duality', color)
	world_color = color

func set_level(levelNumber: int) -> void:
	free_level()
	yield(get_tree().create_timer(0.1), "timeout")
	load_level(levelNumber)

func free_level() -> void:
	for child in $Scene.get_children():
		child.queue_free()

func load_level(levelNumber: int) -> void:
	var levelString = str(levelNumber)
	assert(levels.has(levelString))
	var levelRes = load(levels[levelString].scene)
	var newLevel = levelRes.instance()
	$Scene.add_child(newLevel)
