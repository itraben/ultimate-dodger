extends Node2D

@export var base_speed: float = 600.0
@export var radius: int = 32
var velocity: Vector2 = Vector2.RIGHT
var speed_multiplier: float = 1.0

func _ready() -> void:
	print("Player: _ready — script=", get_script())
	var sprite = get_node_or_null("Sprite")
	if sprite == null:
		push_error("Player: Sprite child not found. Add a Sprite2D named 'Sprite' as a child of Player.")
	else:
		if not sprite.texture:
			sprite.texture = _create_circle_texture(radius, Color(0.2, 0.6, 1.0, 1.0))
			sprite.centered = true

	# Try to center player in the viewport (safe guard if viewport not yet initialized)
	var vrect = get_viewport_rect()
	if vrect.size == Vector2.ZERO:
		print("Player: viewport size is zero — viewport may not be initialized yet.")
	else:
		position = Vector2(vrect.size.x * 0.5, vrect.size.y * 0.5)
	velocity = Vector2.RIGHT

func _process(delta: float) -> void:
	# Move horizontally and bounce on screen edges
	position += velocity * base_speed * speed_multiplier * delta

	var view_w := get_viewport_rect().size.x
	var half := radius

	if view_w > 0:
		if position.x - half < 0:
			position.x = half
			velocity.x = abs(velocity.x)
		elif position.x + half > view_w:
			position.x = view_w - half
			velocity.x = -abs(velocity.x)

func set_speed_multiplier(m: float) -> void:
	speed_multiplier = m

# Helper to create a circular placeholder texture (no external asset required)
func _create_circle_texture(r: int, color: Color) -> ImageTexture:
	var size := int(r * 2)
	var img := Image.new()
	img.create(size, size, false, Image.FORMAT_RGBA8)
	# set pixels directly (no lock/unlock in Godot 4)
	for y in range(size):
		for x in range(size):
			var dx := x - r
			var dy := y - r
			if dx * dx + dy * dy <= r * r:
				img.set_pixel(x, y, color)
			else:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
	return ImageTexture.create_from_image(img)
