extends Node2D

var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

func _ready() -> void:
	$TimeToFlushSound.play()
	$Music.play()

func _process(delta: float) -> void:
	pass

func _on_music_finished() -> void:
	$Music.play()

func _on_toilet_body_flushed_toilet(Node2D: Variant) -> void:
	$Toilet/FlushSound.play()
	$Music.stop()

func _on_player_shoot(pos: Vector2) -> void:
	var bullet: RigidBody2D = bullet_scene.instantiate()
	var direction = Vector2.RIGHT.rotated($Player.rotation)
	bullet.position = pos + (direction * 10)
	bullet.linear_velocity = direction * 1000
	add_child(bullet)
	print('player shoot')
