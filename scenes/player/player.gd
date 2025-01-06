extends CharacterBody2D

signal shoot(pos)

const SPEED: float = 340 
var can_shoot: bool = true

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = SPEED * direction
	move_and_slide()
	
	look_at(get_global_mouse_position())
	
	print(rotation)

	if Input.is_action_pressed("primary action") && can_shoot:
		$ShootSound.play()
		$ShootTimer.start()
		can_shoot = false
		var spawn_positions = $BulletSpawnPositions.get_children()
		var selected = spawn_positions[randi() % spawn_positions.size()]
		shoot.emit(selected.global_position)

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
