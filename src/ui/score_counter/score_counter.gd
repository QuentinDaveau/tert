extends Node2D
class_name ScoreCounter

signal wheel_final_stop(final_score)

export(NodePath) var _music_player_path
export(bool) var _is_demo = false

var _speed: float = 0.0
var _total_score: float = 0.0
var _damp: float = 200.0
var _wheels: Array = []
var _braking: bool = false
var _done: bool = false
var _music_player: Node
var _music_step: int = 0


func _ready() -> void:
	if _music_player_path:
		_music_player = get_node(_music_player_path)
	for child in get_children():
		if child is ScoreWheel:
			_wheels.append(child)


func _process(delta: float) -> void:
	if _is_demo:
		return
	
	var floored_score = floor(_total_score / 128)
	_total_score += _speed * delta
	
	if (_total_score / 128) - floored_score > 1:
		if _speed / 1280 > 3:
			$ClickSound.pitch_scale = 1.56
		else:
			$ClickSound.pitch_scale = 1 + pow(_speed / (1280 * 4), 2)
		$ClickSound.play()
	
	if _speed > 0:
		_speed -= (_damp + (_speed / 5)) * delta
		if _speed < 0:
			_speed = 0;
	for wheel in _wheels:
		wheel.set_cursor(fmod((_total_score / pow(10, wheel.decimal)), 1280))
	$SparkParticles.set_speed(_speed)
	
	if _braking and not _done:
		if _speed <= 0:
			_done = true
			emit_signal("wheel_final_stop", floor(_total_score / 128))
	
	if _music_player:
		_define_music_step()


func _define_music_step() -> void:
	if _speed < 200.0:
		if _music_step == 0:
			return
		_music_step = 0
		_music_player.update_step(_music_step)
	elif _speed >= 200.0 and _speed < 500:
		if _music_step == 1:
			return
		_music_step = 1
		_music_player.update_step(_music_step)
	elif _speed >= 500.0 and _speed < 800:
		if _music_step == 2:
			return
		_music_step = 2
		_music_player.update_step(_music_step)
	elif _speed >= 800.0 and _speed < 1100:
		if _music_step == 3:
			return
		_music_step = 3
		_music_player.update_step(_music_step)
	elif _speed >= 1100.0 and _speed < 1400:
		if _music_step == 4:
			return
		_music_step = 4
		_music_player.update_step(_music_step)
	elif _speed >= 1400.0:
		if _music_step == 5:
			return
		_music_step = 5
		_music_player.update_step(_music_step)


func add_speed(speed: float) -> void:
	_speed += speed


func brake() -> void:
	_braking = true
	_damp += 300.0
