extends StateMachine

func toggle(menu: String) -> void:
	if state.name == "Active":
		transition_to("Inactive")
	else:
		transition_to("Active", { "menu": menu })
