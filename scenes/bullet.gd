extends RigidBody2D

var flushing = false

func _process(delta: float) -> void:
	if flushing:
		$CollisionShape2D/Bullet.scale *= (1 - (4 * delta))
		$".".freeze = true
		if $CollisionShape2D/Bullet.scale.x < 0.01:
			$".".queue_free()

func flush():
	flushing = true	
