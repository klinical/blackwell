extends PlayerState

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y -= player.gravity * delta
		
