extends Control

var is_pressed = false
var touch_index = -1
var joystick_start = Vector2.ZERO
var joystick_current = Vector2.ZERO
var dead_zone = 10.0
var max_radius = 60.0

onready var base = $Base
onready var knob = $Base/Knob

func _ready():
	# Make joystick semi-transparent
	modulate.a = 0.6

func _input(event):
	if event is InputEventScreenTouch:
		# Only capture touches on left half of screen
		if event.pressed and event.position.x < get_viewport().size.x * 0.4:
			if touch_index == -1:
				touch_index = event.index
				is_pressed = true
				joystick_start = event.position
				joystick_current = event.position
				# Move joystick base to touch position
				base.rect_global_position = joystick_start - base.rect_size / 2
		elif not event.pressed and event.index == touch_index:
			touch_index = -1
			is_pressed = false
			joystick_current = joystick_start
			knob.rect_position = base.rect_size / 2 - knob.rect_size / 2
	
	if event is InputEventScreenDrag and event.index == touch_index:
		joystick_current = event.position
		var diff = joystick_current - joystick_start
		if diff.length() > max_radius:
			diff = diff.normalized() * max_radius
		knob.rect_position = base.rect_size / 2 - knob.rect_size / 2 + diff

func get_value() -> Vector2:
	if not is_pressed:
		return Vector2.ZERO
	var diff = joystick_current - joystick_start
	if diff.length() < dead_zone:
		return Vector2.ZERO
	return diff.normalized() * min(diff.length() / max_radius, 1.0)
