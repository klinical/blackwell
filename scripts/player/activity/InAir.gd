extends PlayerState

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		player.activity_state_machine.transition_to("Grounded")
		
	player.velocity.y -= player.gravity * delta
