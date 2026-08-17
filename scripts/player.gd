extends Node2D

@export var base_speed: float = 600.0
@export var radius: int = 32
var velocity: Vector2 = Vector2.RIGHT
var speed_multiplier: float = 1.0

func _ready() -> void:
	print("Player: _ready — script=", get_script())
	print("Player: runtime radius =", radius)
	var sprite: Sprite2D = get_node_or_null("Sprite")
	if sprite == null:
		push_error("Player: Sprite child not found. Add a Sprite2D named 'Sprite' as a child of Player.")
	else:
		if not sprite.texture:
			# Create a texture but guard against Image.create failing (width/height == 0)
			var tex := _create_circle_texture(radius, Color(0.2, 0.6, 1.0, 1.0))
			if tex:
				sprite.texture = tex
				sprite.centered = true
			else:
				push_warning("Player: failed to create circle texture; sprite will remain empty.")

	# Try to center player in the viewport (safe guard if viewport not yet initialized)
	var vrect: Rect2 = get_viewport_rect()
	if vrect.size == Vector2.ZERO:
		print("Player: viewport size is zero — viewport may not be initialized yet.")
	else:
		position = Vector2(vrect.size.x * 0.5, vrect.size.y * 0.5)
	velocity = Vector2.RIGHT

func _process(delta: float) -> void:
	# Move horizontally and bounce on screen edges
	position += velocity * base_speed * speed_multiplier * delta

	var view_w: float = get_viewport_rect().size.x
	var half: int = radius

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
	# ensure radius is a positive integer
	var rr: int = int(r)
	if rr < 1:
		push_warning("Player: radius was invalid (" + str(r) + "); falling back to 1")
		rr = 1
	var size: int = rr * 2
	print("Player: creating circle texture size=", size, " (radius=", rr, ")")

	var img: Image = Image.new()
	# create() can fail in some environments; guard against zero-size image
	img.create(size, size, false, Image.FORMAT_RGBA8)
	print("Player: img width,height after create =", img.get_width(), img.get_height())
	if img.get_width() <= 0 or img.get_height() <= 0:
		push_warning("Player: Image.create produced zero-sized image. Using fallback 2x2 texture.")
		var fb: Image = Image.new()
		fb.create(2, 2, false, Image.FORMAT_RGBA8)
		for fy in range(2):
			for fx in range(2):
				fb.set_pixel(fx, fy, color)
			
		return ImageTexture.create_from_image(fb)

	# populate pixels (safe because img has positive size)
	for y in range(size):
		for x in range(size):
			var dx: int = x - rr
			var dy: int = y - rr
			if dx * dx + dy * dy <= rr * rr:
				img.set_pixel(x, y, color)
			else:
				img.set_pixel(x, y, Color(0, 0, 0, 0))

	return ImageTexture.create_from_image(img)
