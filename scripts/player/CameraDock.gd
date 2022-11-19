extends Marker3D

const ZOOM_RATE_Z: float = 0.4
const ZOOM_RATE_Y: float = 0.3

@onready var initial_y_basis: Basis = basis
@onready var initial_x_basis: Basis = get_node("GimbalX").basis
@onready var zoom_level: float = 10


func reset() -> void:
	basis = initial_y_basis
	$GimbalX.basis = initial_x_basis
	
func increment_zoom(amt: int):
	if zoom_level + amt > 20:
		return
	if zoom_level + amt < 0:
		return
	
	zoom_level += amt
	_adjust_for_zoom()
	
func _adjust_for_zoom() -> void:
	$GimbalX/Camera3D.position.z = zoom_level * ZOOM_RATE_Z
	$GimbalX/CameraMarker.position.z = zoom_level * ZOOM_RATE_Z
	
	$GimbalX/Camera3D.position.y = zoom_level * ZOOM_RATE_Y
	$GimbalX/CameraMarker.position.y = zoom_level * ZOOM_RATE_Y

func _physics_process(delta: float) -> void:
	# Get the global "space" so that raycasts use global position and not relative
	var space_state = get_world_3d().direct_space_state
	# marker represents the camera at max distance, not the actual camera pos
	# since the camera may be closer due to a collision
	var marker_pos = $GimbalX/CameraMarker.global_position
	
	# Create the raycast from the player to the camera marker which is the
	# maximum distance the camera can be at any time
	var cast_params = PhysicsRayQueryParameters3D.create(global_position, marker_pos)
	cast_params.exclude = [owner]
	var cast_result = space_state.intersect_ray(cast_params)
	
	var collision_point = cast_result.get("position")
	if collision_point != null:
		# get the direction from the collision point and the players position
		var heading = (global_position - collision_point).normalized()

#		# place the camera at the collision point, moved 0.02 in the direction
		# of the player to prevent clipping
		$GimbalX/Camera3D.global_position = collision_point + (heading * 1.02)
		# ground clipping hack
		$GimbalX/Camera3D.global_position.y += 0.01
	else:
		# the actual camera position
		var camera_pos = $GimbalX/Camera3D.global_position
		
		var camera_distance = global_transform.origin.distance_to(camera_pos)
		var marker_distance = global_transform.origin.distance_to(marker_pos)
		
		# camera not at max distance? move it there relative to the gimbal point
		if camera_distance < marker_distance:
			$GimbalX/Camera3D.position = $GimbalX/CameraMarker.position
