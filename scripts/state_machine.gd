class_name StateMachine
extends Node

signal transitioned(state_name)

@export var initial_state := NodePath()

@onready var state: State = get_node(initial_state) as State

func _ready() -> void:
	# Wait for owner node to perform its _ready
	await owner.ready
	# Set each state's state machine ref to this
	for child in get_children():
		child = child as State
		child.state_machine = self as StateMachine
	
	# Enter the initial state
	state.enter()

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)
	
func _process(delta) -> void:
	state.update(delta)
	
func _physics_process(delta) -> void:
	state.physics_update(delta)
	
func transition_to(target_state: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state):
		return
	
	# Call the current state's cleanup method
	state.exit()
	# Assign the current state to the new target state
	state = get_node(target_state)
	# Perform that state's setup
	state.enter(msg)
	# Transition is finished
	emit_signal("transitioned", state.name)
