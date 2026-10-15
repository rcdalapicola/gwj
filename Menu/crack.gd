extends Area2D

@onready var tilemap: TileMapLayer = $"../TileMapLayer"
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var particle_scene: PackedScene
@export var ellipse_radius_x := 400
@export var ellipse_radius_y := 200
@export var crack_position: Vector2
@export var pulse_interval: float = 1.5
@export var pulse_duration: float = 1.0
@export var ring_max_progress: float = 0.25
@export var ring_color: Color = Color(0.2, 1.0, 0.3, 1.0)
@export var ring_width: float = 0.01

@onready var circle: CollisionShape2D = $CollisionShape2D
@onready var ring_sprite: Sprite2D = $RingSprite

func remove_collision_in_circle():
	var radius = circle.shape.radius
	var radius_sqrd = radius*radius
	var center = circle.global_position

	var min = center - Vector2(radius, radius)
	var max = center + Vector2(radius, radius)

	var min_cell = tilemap.local_to_map(tilemap.to_local(min))
	var max_cell = tilemap.local_to_map(tilemap.to_local(max))

	var tile_size = Vector2(tilemap.tile_set.tile_size)


	for x in range(min_cell.x, max_cell.x + 1):
		for y in range(min_cell.y, max_cell.y + 1):

			var cell = Vector2i(x, y)

			var world_pos = tilemap.to_global(tilemap.map_to_local(cell))

			if world_pos.distance_squared_to(center) <= radius_sqrd:

				var source_id = tilemap.get_cell_source_id(cell)
				var alternate_id = tilemap.get_cell_alternative_tile(cell)
				var atlas_coords = tilemap.get_cell_atlas_coords(cell)

				if source_id == 0 and alternate_id == 0:
					tilemap.set_cell(cell, source_id, atlas_coords, 1)

func random_point_on_ellipse(center: Vector2, radius_x: float, radius_y: float) -> Vector2:
	var t = randf() * TAU
	var x = radius_x * cos(t)
	var y = radius_y * sin(t)
	return center + Vector2(x, y)
	
func spawn_particle():
	var pos = random_point_on_ellipse(global_position, ellipse_radius_x, ellipse_radius_y)

	var p = particle_scene.instantiate()
	get_tree().current_scene.add_child(p)

	p.global_position = pos
	p.set_target(crack_position)

func _ready():
	remove_collision_in_circle()
	await get_tree().process_frame
	
	_setup_ring_shader()

func _setup_ring_shader():
	if not ring_sprite:
		return
	
	var shader = Shader.new()
	shader.code = """
	shader_type canvas_item;
	uniform float pulse_progress : hint_range(0, 1);
	uniform float max_progress : hint_range(0, 1);
	uniform vec4 ring_color : source_color;
	uniform float ring_width : hint_range(0, 0.1);
	uniform float ring_radius;
	uniform vec2 texture_size;
	uniform float pulse_interval;
	uniform float pulse_duration;
	uniform float global_time;
	
	void fragment() {
		vec2 center = texture_size / 2.0;
		vec2 uv = UV * texture_size;
		float d = length(uv - center);
		
		float max_r = ring_radius * max_progress;
		
		// Calculate pulse progress from global time (synced across all cracks)
		float cycle_time = mod(global_time, pulse_interval);
		float progress = clamp(cycle_time / pulse_duration, 0.0, 1.0);
		
		float current_progress = progress * max_r;
		float w = max_r * ring_width;
		
		float alpha = step(current_progress - w, d) * step(d, current_progress + w);
		float fade = 1.0 - smoothstep(0.85, 1.0, progress);
		
		// Hide ring when pulse hasn't started (progress near 0)
		float visible = step(0.01, progress);
		
		COLOR = ring_color * alpha * fade * visible;
	}
	"""
	
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	
	# Get texture size
	var tex_size = Vector2(0, 0)
	if ring_sprite.texture:
		tex_size = ring_sprite.texture.get_size() * ring_sprite.scale
	
	# Set initial parameters
	shader_material.set_shader_parameter("max_progress", ring_max_progress)
	shader_material.set_shader_parameter("ring_color", ring_color)
	shader_material.set_shader_parameter("ring_width", ring_width)
	shader_material.set_shader_parameter("ring_radius", circle.shape.radius)
	shader_material.set_shader_parameter("texture_size", tex_size)
	shader_material.set_shader_parameter("pulse_interval", pulse_interval)
	shader_material.set_shader_parameter("pulse_duration", pulse_duration)
	shader_material.set_shader_parameter("global_time", 0.0)
	
	ring_sprite.material = shader_material
	ring_sprite.centered = true
	ring_sprite.modulate = Color(1, 1, 1, 1)
	ring_sprite.visible = true
	
	# Debug: print ring info
	print("Crack ring setup: radius=", circle.shape.radius, " max_progress=", ring_max_progress, " max_r=", circle.shape.radius * ring_max_progress, " ring_width=", ring_width, " tex_size=", tex_size)

func _process(delta: float):
	if ring_sprite and ring_sprite.material:
		ring_sprite.material.set_shader_parameter("global_time", Time.get_ticks_msec() / 1000.0)

func _exit_tree():
	pass
