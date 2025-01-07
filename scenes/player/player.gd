extends CharacterBody2D

signal shoot(pos)

const SPEED: float = 310 
var can_shoot: bool = true

var flushing = false

func flush():
	flushing = true	

func reset():
	pass

func _process(delta: float) -> void:
	if flushing:
		$PlayerImage.scale *= (1 - (4 * delta))
		if $PlayerImage.scale.x < 0.01:
			$".".queue_free()

	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = SPEED * direction.rotated(rotation + (PI / 2))
	move_and_slide()
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("primary action") && can_shoot:
		$ShootSound.play()
		$ShootTimer.start()
		can_shoot = false
		var spawn_positions = $BulletSpawnPositions.get_children()
		var selected = spawn_positions[randi() % spawn_positions.size()]
		shoot.emit(selected.global_position)

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
