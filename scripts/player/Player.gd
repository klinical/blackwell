class_name Player
extends CharacterBody3D


@onready var menu_state_machine: StateMachine = get_node("MenuStateMachine")
@onready var combat_state_machine: StateMachine = get_node("CombatStateMachine")
@onready var activity_state_machine: StateMachine = get_node("ActivityStateMachine")
@onready var last_mouse = get_viewport().get_mouse_position()

const Y_AXIS = Vector3(0, 1, 0)
const X_AXIS = Vector3(1, 0, 0)

const LOOK_SENSITIVITY: int = 1
const LOOK_SPEED = 2 * PI
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var free_look: bool = false


func _ready() -> void:
	await get_tree().root.ready
	$GimbalY/GimbalX/Camera3D.look_at(camera_target(), Vector3.UP)


func _process(delta) -> void:
	if delta < 0:
		print("WARNING: DELTA IS A NEGATIVE VALUE ON PLAYER")
	if Input.is_action_just_released("scroll_down"):
		$GimbalY.increment_zoom(1)
	if Input.is_action_just_released("scroll_up"):
		$GimbalY.increment_zoom(-1)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		$CharacterPane.visible = !$CharacterPane.visible
	
	if activity_state_machine.state.name == "Frozen":
		# continue with whatever velocity there still is
		move_and_slide()
		return
		
	if Input.is_action_pressed("rotate_left"):
		transform.basis = transform.basis.rotated(Y_AXIS, 0.05)
	if Input.is_action_pressed("rotate_right"):
		transform.basis = transform.basis.rotated(Y_AXIS, -0.05)

	if Input.is_action_pressed("right_click"):
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		# adjust the camera while holding right click
		camera_adjust(mouse_pos, delta)
	elif last_mouse != Vector2.ZERO:
		last_mouse = Vector2.ZERO
	if Input.is_action_pressed("scroll_button"):
		# toggle free look mode
		free_look = !free_look

	# perform computed movement
	move_and_slide()


func equip(item, slot: String) -> void:
	match (slot):
		"weapon":
			$CharacterPane/VBoxContainer3/PrimarySlot.texture = item.sprite
	pass

func camera_adjust(mouse_pos: Vector2, delta: float) -> void:
	# last_mouse is a zero vector if the player has not moved their camera yet
	# no adjustment needed
	if last_mouse == Vector2.ZERO:
		last_mouse = mouse_pos
	else:
		# we can compare the new mouse position to the previous values
		# and adjust our camera based on the changes
		# if there is no change, there is nothing to do
		if mouse_pos == last_mouse:
			return
			
		# scale the sensitivity using a 1920x1080 screen as a reference point
		var scale_rate = Vector2(1920, 1080) / (get_viewport().size as Vector2)
		var rot_strength_x = ((last_mouse.x - mouse_pos.x) / 320) * scale_rate.x
		var rot_strength_y = ((last_mouse.y - mouse_pos.y) / 180) * scale_rate.y
			
		var target = camera_target()
		var rot_x = rot_strength_x * LOOK_SPEED * LOOK_SENSITIVITY
		var rot_y = ((rot_strength_y * LOOK_SPEED) / 4) * LOOK_SENSITIVITY
		
		$GimbalY/GimbalX.rotate_object_local(X_AXIS, rot_y)
		
		# free look allows the player to rotate the camera independent of the
		# players body 
		if free_look:
			$GimbalY.rotate_object_local(Y_AXIS, rot_x)
		else:
			# rotate the player, since camera is relative it will rotate along
			# proportional to the player
			transform.basis = transform.basis.rotated(Y_AXIS, rot_x)
			
		# finally, set the last_mouse to the position used for this adjustment
		last_mouse = mouse_pos


func camera_target() -> Vector3:
	var t = position
	t.y += 2
	
	return t


func reset_camera() -> void:
	$GimbalY.reset()

