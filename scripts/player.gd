extends Node2D

@export var base_speed: float = 600.0
@export var radius: int = 32
var velocity: Vector2 = Vector2.RIGHT
var speed_multiplier: float = 1.0
var _texture_created: bool = false

func _ready() -> void:
	print("Player: _ready — script=", get_script())
	print("Player: runtime radius =", radius)
	# Delay creating the procedural texture until the viewport is initialized (see _process)
	var vrect: Rect2 = get_viewport_rect()
	if vrect.size == Vector2.ZERO:
		print("Player: viewport size is zero — will create texture once viewport is ready.")
	else:
		# If viewport already available, we'll create texture on first _process tick
		print("Player: viewport available at ready:", vrect.size)
	velocity = Vector2.RIGHT

func _process(delta: float) -> void:
	# Ensure the procedural texture is created only after the viewport is ready
	if not _texture_created:
		var vrect: Rect2 = get_viewport_rect()
		if vrect.size != Vector2.ZERO:
			var sprite: Sprite2D = get_node_or_null("Sprite")
			if sprite == null:
				push_error("Player: Sprite child not found. Add a Sprite2D named 'Sprite' as a child of Player.")
			else:
				if not sprite.texture:
					var tex := _create_circle_texture(radius, Color(0.2, 0.6, 1.0, 1.0))
					if tex:
						sprite.texture = tex
						sprite.centered = true
					else:
						push_warning("Player: failed to create circle texture; sprite will remain empty.")
			_texture_created = true

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
		push_warning("Player: Image.create produced zero-sized image. Using fallback 64x64 texture.")
		var fb: Image = Image.new()
		fb.create(64, 64, false, Image.FORMAT_RGBA8)
		for fy in range(64):
			for fx in range(64):
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
