extends Node2D


func _ready() -> void:
	Engine.time_scale = 0.3


func _exit_tree() -> void:
	Engine.time_scale = 1


func get_score_counter() -> Node:
	return $ScoreCounter


func get_camera() -> Node:
	return $GameCamera
