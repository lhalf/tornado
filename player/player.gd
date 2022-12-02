extends CharacterBody3D

const SPEED = 10
const LEAN_DIVIDER = 2
const VEL_LERP = 0.05
const ROT_LERP = 0.05

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		$camera_pivot.rotate_y(-event.relative.x * 0.005)
		$camera_pivot/spring_arm.rotate_x(-event.relative.y * 0.005)
		$camera_pivot/spring_arm.rotation.x = clamp($camera_pivot/spring_arm.rotation.x, -PI/4, -PI/4)

func _physics_process(_delta):
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, $camera_pivot.rotation.y)
	
	if direction:
		#rotate_towards(direction)
		move_towards(direction)
	else:
		#rotate_towards(Vector3.ZERO)
		move_towards(Vector3.ZERO)
	
	rotate_towards(get_floor_normal())
	move_and_slide()

func rotate_towards(direction):
	rotation.x = lerp(rotation.x, direction.z/LEAN_DIVIDER, ROT_LERP)
	rotation.z = lerp(rotation.z, -direction.x/LEAN_DIVIDER, ROT_LERP)

func move_towards(direction):
	velocity.x = lerp(velocity.x, direction.x * SPEED, VEL_LERP)
	velocity.z = lerp(velocity.z, direction.z * SPEED, VEL_LERP)
