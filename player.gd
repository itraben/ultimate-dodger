extends Node2D

@export var slow_multiplier: float = 0.5
@export var fast_multiplier: float = 1.5

var is_slow: bool = false
@onready var player := get_node_or_null("Player")
@onready var toggle_button := get_node_or_null("CanvasLayer/Control/ToggleButton")

func _ready() -> void:
	print("Main: _ready — self=", self, " script=", get_script())
	if not has_method("_apply_mode"):
		push_error("Main: _apply_mode() not found. Make sure scripts/main.gd is attached to this node.")
		return

	if player == null:
		push_error("Main: Player node not found at path 'Player'.")
	if toggle_button == null:
		push_error("Main: ToggleButton not found at 'CanvasLayer/Control/ToggleButton'. UI may be missing.")
	else:
		var cb := Callable(self, "on_toggle_pressed")
		if not toggle_button.is_connected("pressed", cb):
			toggle_button.connect("pressed", cb)

	_apply_mode()

func on_toggle_pressed() -> void:
	is_slow = not is_slow
	_apply_mode()

func _apply_mode() -> void:
	var m := slow_multiplier if is_slow else fast_multiplier
	if player and player.has_method("set_speed_multiplier"):
		player.set_speed_multiplier(m)
	else:
		push_warning("Main: Player is missing or does not implement set_speed_multiplier.")
	_update_button_text()

func _update_button_text() -> void:
	if toggle_button:
		toggle_button.text = "SLOW: ON" if is_slow else "SLOW: OFF"
