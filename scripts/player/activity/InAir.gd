extends PlayerState

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		player.activity_state_machine.transition_to("Grounded")
		
	print(player.velocity)
	print(player.is_on_floor())
	player.velocity.y -= player.gravity * delta
