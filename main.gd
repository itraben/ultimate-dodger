extends Node2D

func _ready() -> void:
	print("--- DEBUG: Main._ready ---")
	print("Self:", self, " script:", get_script())
	print("Current scene via SceneTree:", get_tree().get_current_scene())

	var main_scene_setting = ProjectSettings.get("application/run/main_scene")
	print("Project setting application/run/main_scene =", main_scene_setting)

	var vrect = get_viewport_rect()
	print("Viewport rect:", vrect, " size:", vrect.size)

	for child in get_children():
		var s = ""
		if child.get_script() != null:
			s = str(child.get_script())
		print("Child:", child.name, " type:", child.get_class(), " script:", s, " pos:", child.position if child.has_method("position") else "N/A")

	_print_tree(self, 0)

	_create_test_sprite(vrect.size * 0.5)

func _print_tree(node: Node, indent: int) -> void:
	var pad = "  ".repeat(indent)  # use repeat(), not Python-style multiplication
	print(pad + "- " + node.name + " (" + node.get_class() + ") script=" + str(node.get_script()))
	for c in node.get_children():
		_print_tree(c, indent + 1)

func _create_test_sprite(pos: Vector2) -> void:
	var size := 200
	var img := Image.new()
	img.create(size, size, false, Image.FORMAT_RGBA8)
	# set pixels directly (no lock/unlock)
	var color := Color(1.0, 0.0, 1.0, 1.0)
	for y in range(size):
		for x in range(size):
			img.set_pixel(x, y, color)
	var tex := ImageTexture.create_from_image(img)

	var s := Sprite2D.new()
	s.texture = tex
	s.position = pos
	add_child(s)
	print("Added test Sprite2D at", pos)
