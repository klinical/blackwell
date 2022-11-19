extends PlayerState

func enter(msg: Dictionary = {}) -> void:
	var menu_selection = msg.get("menu")
	if menu_selection == null:
		return
	pass
