extends CanvasLayer

var fps_label: Label

func _ready():
	fps_label = $FPSLabel
	# Draw joystick visuals
	var joystick = $Joystick
	_draw_joystick(joystick)

func _process(_delta):
	if fps_label:
		fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func _draw_joystick(joystick):
	# Base circle background
	var base = joystick.get_node("Base")
	var base_bg = ColorRect.new()
	base_bg.color = Color(1, 1, 1, 0.15)
	base_bg.rect_min_size = Vector2(180, 180)
	base_bg.rect_position = Vector2(0, 0)
	base.add_child(base_bg)
	
	# Knob visual
	var knob = base.get_node("Knob")
	var knob_bg = ColorRect.new()
	knob_bg.color = Color(1, 1, 1, 0.4)
	knob_bg.rect_min_size = Vector2(60, 60)
	knob_bg.rect_position = Vector2(0, 0)
	knob.add_child(knob_bg)
	
	# Jump button label
	var jump_btn = $JumpButton
	var jump_label = Label.new()
	jump_label.text = "JUMP"
	jump_label.rect_position = Vector2(-20, -15)
	jump_label.add_color_override("font_color", Color(1, 1, 1, 0.8))
	jump_btn.add_child(jump_label)
