extends Node


var world_color : String = 'black'

var levels : Dictionary = {
	'2': {
		'scene': "res://data/levels/2/level_2.tscn"
	}
}

onready var tween : Tween = $Tween
onready var timer : Timer = $Timer

const USING_CUSTOM_CHANGES : bool = false
const DEFAULT_CHANGE_WORLD_DURATION := 0.2
const EXTRA_COYOTE_TIME := 0.08
const WHITE := Color.white
const TRANSPARENT := Color(1, 1, 1, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = true
	load_level(2)
	yield(get_tree().create_timer(0.05), 'timeout')
	set_world_with_modulate(world_color, 0)

func _unhandled_input(event) -> void:
	if event.is_action_pressed("duality"):
		set_world('white' if world_color == 'black' else 'black')

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.echo or not event.pressed: return
	if event.scancode == KEY_1:
		set_world('black')
	elif event.scancode == KEY_2:
		set_world('white')
	elif event.scancode == KEY_I:
		get_tree().call_group('interactable', 'interact')
	elif event.scancode == KEY_0:
		set_world('white' if world_color == 'black' else 'black')

func set_world(color: String) -> void:
	assert(color in ['white', 'black'])
	set_world_with_modulate(color, DEFAULT_CHANGE_WORLD_DURATION)

func set_world_with_visibility(color: String) -> void:
	var whiteNodes = get_tree().get_nodes_in_group('white')
	var blackNodes = get_tree().get_nodes_in_group('black')
	var toWhite : bool = color == 'white'
	for whiteNode in whiteNodes:
		#print('white: ', whiteNode.name)
		whiteNode.visible = toWhite
	for blackNode in blackNodes:
		#print('black: ', blackNode.name)
		blackNode.visible = not toWhite
	get_tree().call_group('duality', 'the_world_is_changing', color)
	get_tree().call_group('duality', 'duality', color)
	world_color = color

func set_world_with_modulate(color: String, duration: float) -> void:
	var whiteNodes = get_tree().get_nodes_in_group('white')
	var blackNodes = get_tree().get_nodes_in_group('black')
	var toWhite : bool = color == 'white'
	
	var _tweenRemoveError = tween.remove_all()

	for whiteNode in whiteNodes:
		#print('white: ', whiteNode.name)
		set_world_element(whiteNode, toWhite, duration)
	for blackNode in blackNodes:
		#print('black: ', blackNode.name)
		set_world_element(blackNode, not toWhite, duration)
	
	# print('The world is changing to ', color)
	get_tree().call_group('duality', 'the_world_is_changing', color)
	world_color = color
	var _tweenStartError = tween.start()
	
	timer.start(duration + EXTRA_COYOTE_TIME)
	if not timer.is_connected("timeout", self, '_on_Timer_timeout'):
		var _connErr = timer.connect("timeout", self, '_on_Timer_timeout')

func set_world_element(element: Node, toWhite: bool, duration: float) -> void:
	element.visible = true
	var dur := duration
	var delay : float = 0
	if USING_CUSTOM_CHANGES:
		if element is CustomChange:
			dur = element.duration
			delay = element.delay
		elif element.owner is CustomChange:
			dur = element.owner.duration
			delay = element.owner.delay
	var _err = tween.interpolate_property(element, 'modulate', element.modulate, WHITE if toWhite else TRANSPARENT, dur, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)

func _on_Timer_timeout() -> void:
	# print('Called duality() with ', world_color)
	get_tree().call_group('duality', 'duality', world_color)

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
