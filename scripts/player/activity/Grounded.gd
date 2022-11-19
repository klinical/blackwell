extends PlayerState

func physics_update(delta: float) -> void:
	player.velocity.x = 0
	player.velocity.z = 0
	
	if Input.is_action_pressed("walk_forward"):
		var new_v = -player.transform.basis.z.normalized() * player.SPEED
		new_v.y = player.velocity.y
		player.velocity = new_v
		
	if Input.is_action_pressed("walk_backward"):
		var new_v = player.transform.basis.z.normalized() * player.SPEED
		new_v.y = player.velocity.y
		player.velocity = new_v
		
		
	if not player.is_on_floor():
		player.activity_state_machine.transition_to("InAir")


	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
		player.activity_state_machine.transition_to("InAir")
