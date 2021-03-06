extends Node2D
class_name Player

export(String, FILE, "*.tscn") var brick_path

var _current_position: Vector2
var _grid: Node2D
var _current_brick: Brick
var _generator: Generator
var _player_slots: Node2D
var _exploding: bool = false
var _handle_input: bool = true


func setup(start_position: Vector2, grid: Node2D, generator: Generator) -> void:
	_current_position = start_position
	_grid = grid
	_generator = generator


func disable_input() -> void:
	_handle_input = false


func _ready() -> void:
	_player_slots = get_parent().get_parent().find_node("PlayerSlots")
	_current_brick = _generator.pick_brick()
	for block in _current_brick.get_block_models():
		_grid.add_child(block)
	_player_slots.set_player_position(_current_position.y)
	_player_slots.set_player_color(_current_brick.get_blocks_color())


func _process(delta: float) -> void:
	_manage_input()


func _manage_input() -> void:
	if not _handle_input:
		return
	if Input.is_action_just_pressed("ui_left"):
		_current_position = _grid.move("left", _current_position)
		_player_slots.set_player_position(_current_position.y)
		_grid.update_player_proj()
	if Input.is_action_just_pressed("ui_right"):
		_current_position = _grid.move("right", _current_position)
		_grid.update_player_proj()
		_player_slots.set_player_position(_current_position.y)
	if Input.is_action_just_pressed("game_rotate"):
		_current_brick.rotate()
		_grid.update_player_proj()
	if Input.is_action_just_pressed("ui_accept"):
		if _exploding:
			return
		_grid.shoot_brick(_current_brick, _current_position.y)
		var exploding_brick = _current_brick
		exploding_brick.explode()
		_exploding = true
		yield(exploding_brick, "exploded")
		if not _handle_input:
			return
		_current_brick = _generator.pick_brick()
		_exploding = false
		for block in _current_brick.get_block_models():
			_grid.add_child(block)
		_grid.update_player_proj()
		_player_slots.set_player_color(_current_brick.get_blocks_color())
