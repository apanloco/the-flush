extends Node2D

var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
var player_scene: PackedScene = preload("res://scenes/player/player.tscn")

var flushing: bool = false
var FLUSH_FORCE_START: float = 500
var FLUSH_FORCE_MODIFIER: float = 0.27
var FLUSH_MAX_FORCE: float = 250000
var flush_force: float

func start() -> void:
	$TimeToFlushSound.play()
	$Music.play()
	flushing = false
	var player = player_scene.instantiate()
	add_child(player)
	player.reset()
	player.position = Vector2(100, 100)
	player.scale = Vector2(0.5, 0.5)
	player.connect("shoot", Callable(self, "_on_player_shoot"))

func _ready() -> void:
	start()

func _process(delta: float) -> void:
	if flushing:
		var toilet_position = $Toilet.position
		for bullet: RigidBody2D in $Bullets.get_children():
			bullet.linear_damp = 10
			var direction = (toilet_position - bullet.position).normalized()
			if flush_force > FLUSH_MAX_FORCE:
				flush_force = FLUSH_MAX_FORCE
			var force = direction * flush_force
			bullet.apply_force(force)
		flush_force *= (1.0 + (FLUSH_FORCE_MODIFIER * delta))

func _on_music_finished() -> void:
	$Music.play()

func _on_toilet_body_flushed_toilet(node: Node2D) -> void:
	print('node type: ', node.get_class())
	print('node ', node)
	if node is RigidBody2D:
		node.flush()
	if node is CharacterBody2D:
		$Toilet/FlushSound.play()
		$Music.stop()
		flushing = true
		flush_force = FLUSH_FORCE_START
		print('flush force', flush_force)
		node.flush()
		$RestartTimer.start()

func _on_player_shoot(pos: Vector2) -> void:
	var bullet: RigidBody2D = bullet_scene.instantiate()
	var direction = Vector2.RIGHT.rotated($Player.rotation)
	bullet.position = pos + (direction * 10)
	bullet.linear_velocity = direction * 2000
	$Bullets.add_child(bullet)
	print('player shoot')

func _on_restart_timer_timeout() -> void:
	start()
