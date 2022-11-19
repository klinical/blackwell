extends PlayerState

func enter(msg: Dictionary = {}) -> void:
	var menu_selection = msg.get("menu")
	if menu_selection == null:
		player.activity_state_machine.transition_to("Grounded")
	else:
		player.activity_state_machine.transition_to("Frozen")
	pass
