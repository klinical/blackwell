extends PlayerState

func enter(msg: Dictionary = {}) -> void:
	player.activity_state_machine.transition_to("Grounded")
