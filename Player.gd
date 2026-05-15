extends KinematicBody

# Movement settings
export var walk_speed = 4.0
export var gravity = -20.0
export var jump_force = 7.0
export var mouse_sensitivity = 0.002
export var touch_sensitivity = 0.004

var velocity = Vector3.ZERO
var is_on_floor_cached = false

# Touch camera control
var touch_start = Vector2.ZERO
var camera_touch_id = -1

onready var camera = $CameraHolder/Camera
onready var camera_holder = $CameraHolder

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Mouse look (PC)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_holder.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_holder.rotation.x = clamp(camera_holder.rotation.x, -1.2, 1.2)
	
	# Touch camera look (right side of screen)
	if event is InputEventScreenTouch:
		if event.pressed and event.position.x > get_viewport().size.x * 0.4:
			camera_touch_id = event.index
			touch_start = event.position
		elif not event.pressed and event.index == camera_touch_id:
			camera_touch_id = -1
	
	if event is InputEventScreenDrag and event.index == camera_touch_id:
		rotate_y(-event.relative.x * touch_sensitivity)
		camera_holder.rotate_x(-event.relative.y * touch_sensitivity)
		camera_holder.rotation.x = clamp(camera_holder.rotation.x, -1.2, 1.2)
	
	# Escape to release mouse
	if event is InputEventKey and event.pressed and event.scancode == KEY_ESCAPE:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var dir = Vector3.ZERO
	
	# Keyboard input
	if Input.is_action_pressed("move_forward"):
		dir -= transform.basis.z
	if Input.is_action_pressed("move_back"):
		dir += transform.basis.z
	if Input.is_action_pressed("move_left"):
		dir -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		dir += transform.basis.x
	
	# Joystick input from HUD
	var joystick = get_node_or_null("/root/Main/HUD/Joystick")
	if joystick and joystick.is_pressed:
		var jdir = joystick.get_value()
		dir -= transform.basis.z * jdir.y
		dir += transform.basis.x * jdir.x
	
	# Normalize and apply speed
	if dir.length() > 0:
		dir = dir.normalized()
	
	velocity.x = dir.x * walk_speed
	velocity.z = dir.z * walk_speed
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y < 0:
			velocity.y = -0.5
	
	# Jump
	if (Input.is_action_just_pressed("jump")) and is_on_floor():
		velocity.y = jump_force
	
	# Check jump button from HUD
	var jump_btn = get_node_or_null("/root/Main/HUD/JumpButton")
	if jump_btn and jump_btn.is_pressed() and is_on_floor():
		velocity.y = jump_force
	
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, deg2rad(46))
