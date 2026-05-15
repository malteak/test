extends Spatial

# Soviet apartment generator
# Creates all geometry procedurally - no external assets needed

func _ready():
	build_apartment()

func build_apartment():
	# Room dimensions
	var room_w = 8.0
	var room_h = 3.0
	var room_d = 10.0
	
	# Materials
	var wall_mat = create_material(Color(0.85, 0.82, 0.75))      # Yellowish walls
	var floor_mat = create_material(Color(0.45, 0.35, 0.25))     # Dark wood floor
	var ceiling_mat = create_material(Color(0.9, 0.9, 0.88))     # White ceiling
	var wood_mat = create_material(Color(0.55, 0.38, 0.22))      # Brown wood
	var dark_wood = create_material(Color(0.3, 0.2, 0.12))       # Dark furniture
	var metal_mat = create_material(Color(0.6, 0.6, 0.65))       # Metal
	var fabric_mat = create_material(Color(0.55, 0.25, 0.25))    # Red Soviet fabric
	var glass_mat = create_material(Color(0.7, 0.85, 0.9), 0.3)  # Glass
	var tv_mat = create_material(Color(0.15, 0.15, 0.15))        # TV black
	var screen_mat = create_material(Color(0.1, 0.15, 0.3))      # Screen dark
	var white_mat = create_material(Color(0.95, 0.95, 0.95))     # White
	var green_mat = create_material(Color(0.3, 0.55, 0.3))       # Plant green
	
	# === ROOM STRUCTURE ===
	# Floor
	add_box(Vector3(0, -0.05, 0), Vector3(room_w, 0.1, room_d), floor_mat)
	# Ceiling
	add_box(Vector3(0, room_h + 0.05, 0), Vector3(room_w, 0.1, room_d), ceiling_mat)
	# Back wall
	add_box(Vector3(0, room_h/2, -room_d/2), Vector3(room_w, room_h, 0.2), wall_mat)
	# Front wall (with door gap)
	add_box(Vector3(-2.5, room_h/2, room_d/2), Vector3(3.0, room_h, 0.2), wall_mat)
	add_box(Vector3(2.5, room_h/2, room_d/2), Vector3(3.0, room_h, 0.2), wall_mat)
	add_box(Vector3(0, 2.4, room_d/2), Vector3(2.0, 0.6, 0.2), wall_mat) # above door
	# Left wall (with window)
	add_box(Vector3(-room_w/2, room_h/2, -1.5), Vector3(0.2, room_h, 7.0), wall_mat)
	add_box(Vector3(-room_w/2, room_h/2, 3.5), Vector3(0.2, room_h, 3.0), wall_mat)
	add_box(Vector3(-room_w/2, 0.5, 0.5), Vector3(0.2, 1.0, 4.0), wall_mat)   # below window
	add_box(Vector3(-room_w/2, 2.8, 0.5), Vector3(0.2, 0.4, 4.0), wall_mat)   # above window
	# Right wall
	add_box(Vector3(room_w/2, room_h/2, 0), Vector3(0.2, room_h, room_d), wall_mat)
	
	# === WINDOW ===
	add_box(Vector3(-room_w/2 + 0.05, 1.8, 0.5), Vector3(0.1, 1.2, 3.5), glass_mat)
	# Window frame
	add_box(Vector3(-room_w/2, 1.0, -1.3), Vector3(0.25, 0.1, 0.1), wood_mat)
	add_box(Vector3(-room_w/2, 2.6, -1.3), Vector3(0.25, 0.1, 0.1), wood_mat)
	add_box(Vector3(-room_w/2, 1.8, 2.3), Vector3(0.25, 0.1, 0.1), wood_mat)
	
	# === DOOR ===
	add_box(Vector3(0, 1.1, room_d/2), Vector3(0.9, 2.1, 0.1), dark_wood)
	add_box(Vector3(0.35, 1.1, room_d/2 + 0.06), Vector3(0.05, 0.05, 0.05), metal_mat) # handle
	
	# === BASEBOARD ===
	for side in [
		[Vector3(0, 0.05, -room_d/2 + 0.15), Vector3(room_w, 0.12, 0.08)],
		[Vector3(-room_w/2 + 0.15, 0.05, 0), Vector3(0.08, 0.12, room_d)],
		[Vector3(room_w/2 - 0.15, 0.05, 0), Vector3(0.08, 0.12, room_d)],
	]:
		add_box(side[0], side[1], white_mat)
	
	# === SOVIET SOFA ===
	var sofa_x = 2.5
	var sofa_z = -3.5
	# Seat
	add_box(Vector3(sofa_x, 0.35, sofa_z), Vector3(2.4, 0.35, 0.9), fabric_mat)
	# Back
	add_box(Vector3(sofa_x, 0.75, sofa_z - 0.4), Vector3(2.4, 0.7, 0.15), fabric_mat)
	# Armrests
	add_box(Vector3(sofa_x - 1.15, 0.6, sofa_z), Vector3(0.15, 0.5, 0.9), fabric_mat)
	add_box(Vector3(sofa_x + 1.15, 0.6, sofa_z), Vector3(0.15, 0.5, 0.9), fabric_mat)
	# Legs
	for lx in [-1.0, 1.0]:
		for lz in [-0.3, 0.3]:
			add_box(Vector3(sofa_x + lx, 0.08, sofa_z + lz), Vector3(0.08, 0.18, 0.08), dark_wood)
	
	# === SOVIET TV ON STAND ===
	var tv_x = -2.5
	var tv_z = -4.0
	# TV stand legs
	for lx in [-0.35, 0.35]:
		add_box(Vector3(tv_x + lx, 0.35, tv_z), Vector3(0.07, 0.7, 0.5), dark_wood)
	# TV stand shelf
	add_box(Vector3(tv_x, 0.72, tv_z), Vector3(0.9, 0.06, 0.5), dark_wood)
	# TV body (classic boxy Soviet TV)
	add_box(Vector3(tv_x, 1.15, tv_z), Vector3(0.75, 0.6, 0.45), tv_mat)
	# Screen
	add_box(Vector3(tv_x, 1.15, tv_z + 0.23), Vector3(0.58, 0.44, 0.02), screen_mat)
	# Knobs
	add_box(Vector3(tv_x + 0.32, 1.05, tv_z + 0.23), Vector3(0.04, 0.04, 0.04), metal_mat)
	add_box(Vector3(tv_x + 0.32, 1.2, tv_z + 0.23), Vector3(0.04, 0.04, 0.04), metal_mat)
	# Antenna
	add_box(Vector3(tv_x - 0.1, 1.5, tv_z - 0.05), Vector3(0.03, 0.35, 0.03), metal_mat)
	add_box(Vector3(tv_x + 0.1, 1.5, tv_z - 0.05), Vector3(0.03, 0.35, 0.03), metal_mat)
	
	# === DINING TABLE ===
	var tbl_x = -1.0
	var tbl_z = 2.0
	# Tabletop
	add_box(Vector3(tbl_x, 0.77, tbl_z), Vector3(1.6, 0.07, 0.95), wood_mat)
	# Legs
	for lx in [-0.7, 0.7]:
		for lz in [-0.38, 0.38]:
			add_box(Vector3(tbl_x + lx, 0.37, tbl_z + lz), Vector3(0.07, 0.75, 0.07), dark_wood)
	
	# === CHAIRS ===
	for cx in [-0.7, 0.7]:
		add_soviet_chair(Vector3(tbl_x + cx * 1.2, 0, tbl_z), dark_wood, fabric_mat)
	add_soviet_chair(Vector3(tbl_x, 0, tbl_z + 0.85), dark_wood, fabric_mat, true)
	add_soviet_chair(Vector3(tbl_x, 0, tbl_z - 0.85), dark_wood, fabric_mat, true)
	
	# === BOOKSHELF ===
	var shelf_x = room_w/2 - 0.25
	var shelf_z = -2.0
	# Frame
	add_box(Vector3(shelf_x, 1.5, shelf_z), Vector3(0.4, 3.0, 1.8), dark_wood)
	# Shelves
	for sh in [0.3, 0.85, 1.4, 1.95, 2.5]:
		add_box(Vector3(shelf_x, sh, shelf_z), Vector3(0.35, 0.04, 1.75), wood_mat)
	# Books (colorful)
	var book_colors = [Color(0.7,0.2,0.2), Color(0.2,0.4,0.7), Color(0.2,0.6,0.3),
		Color(0.7,0.6,0.1), Color(0.5,0.2,0.6), Color(0.8,0.4,0.1)]
	var bz = -0.8
	for i in range(6):
		var bmat = create_material(book_colors[i])
		add_box(Vector3(shelf_x, 0.6, bz + i * 0.15), Vector3(0.06, 0.22, 0.12), bmat)
		add_box(Vector3(shelf_x, 1.15, bz + i * 0.15), Vector3(0.06, 0.22, 0.12), bmat)
	
	# === FRIDGE ===
	var fridge_x = room_w/2 - 0.35
	var fridge_z = 4.0
	add_box(Vector3(fridge_x, 0.9, fridge_z), Vector3(0.65, 1.8, 0.7), white_mat)
	add_box(Vector3(fridge_x, 0.25, fridge_z), Vector3(0.65, 0.5, 0.7), white_mat)
	add_box(Vector3(fridge_x + 0.3, 0.9, fridge_z + 0.3), Vector3(0.04, 0.15, 0.04), metal_mat)
	add_box(Vector3(fridge_x + 0.3, 0.25, fridge_z + 0.3), Vector3(0.04, 0.08, 0.04), metal_mat)
	
	# === CEILING LAMP ===
	add_box(Vector3(0, room_h - 0.05, 0), Vector3(0.25, 0.1, 0.25), metal_mat)
	add_box(Vector3(0, room_h - 0.2, 0), Vector3(0.4, 0.25, 0.4), glass_mat)
	
	# Add omni light for lamp
	var lamp_light = OmniLight.new()
	lamp_light.translation = Vector3(0, room_h - 0.3, 0)
	lamp_light.light_energy = 1.2
	lamp_light.light_color = Color(1.0, 0.95, 0.8)
	lamp_light.omni_range = 12.0
	lamp_light.shadow_enabled = false  # Disable shadows for performance
	add_child(lamp_light)
	
	# === WINDOW LIGHT ===
	var win_light = OmniLight.new()
	win_light.translation = Vector3(-room_w/2 + 1.5, 1.8, 0.5)
	win_light.light_energy = 0.5
	win_light.light_color = Color(0.85, 0.9, 1.0)
	win_light.omni_range = 8.0
	win_light.shadow_enabled = false
	add_child(win_light)
	
	# === PLANT IN CORNER ===
	var plant_x = -room_w/2 + 0.4
	var plant_z = room_d/2 - 0.5
	add_box(Vector3(plant_x, 0.25, plant_z), Vector3(0.22, 0.5, 0.22), dark_wood)   # pot
	add_box(Vector3(plant_x, 0.65, plant_z), Vector3(0.35, 0.6, 0.35), green_mat)  # plant
	add_box(Vector3(plant_x - 0.1, 0.9, plant_z - 0.05), Vector3(0.08, 0.4, 0.05), green_mat)
	add_box(Vector3(plant_x + 0.1, 0.85, plant_z + 0.05), Vector3(0.08, 0.35, 0.05), green_mat)
	
	# === CARPET ===
	var carpet_mat = create_material(Color(0.6, 0.2, 0.2))
	add_box(Vector3(1.5, 0.01, -1.5), Vector3(4.0, 0.02, 4.0), carpet_mat)


func add_soviet_chair(pos: Vector3, wood: SpatialMaterial, fabric: SpatialMaterial, rotate90: bool = false):
	# Seat
	var seat = add_box(pos + Vector3(0, 0.45, 0), Vector3(0.42, 0.06, 0.42), fabric)
	# Back
	var back_offset = Vector3(0, 0.75, -0.18) if not rotate90 else Vector3(0, 0.75, 0.18)
	add_box(pos + back_offset, Vector3(0.42, 0.5, 0.06), fabric)
	# Legs
	for lx in [-0.17, 0.17]:
		for lz in [-0.17, 0.17]:
			add_box(pos + Vector3(lx, 0.2, lz), Vector3(0.05, 0.42, 0.05), wood)


func add_box(pos: Vector3, size: Vector3, mat: SpatialMaterial) -> StaticBody:
	var body = StaticBody.new()
	body.translation = pos
	
	var mesh_inst = MeshInstance.new()
	var mesh = CubeMesh.new()
	mesh.size = size
	mesh_inst.mesh = mesh
	mesh_inst.material_override = mat
	body.add_child(mesh_inst)
	
	var col = CollisionShape.new()
	var shape = BoxShape.new()
	shape.extents = size / 2
	col.shape = shape
	body.add_child(col)
	
	add_child(body)
	return body


func create_material(color: Color, alpha: float = 1.0) -> SpatialMaterial:
	var mat = SpatialMaterial.new()
	mat.albedo_color = color
	if alpha < 1.0:
		mat.flags_transparent = true
		mat.albedo_color.a = alpha
	# Optimize: no fancy shading
	mat.flags_unshaded = false
	mat.roughness = 0.85
	mat.metallic = 0.0
	return mat
