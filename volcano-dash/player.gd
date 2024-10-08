extends Node3D

var sens = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Function to move camera around according to mouse movement
func _input(event: InputEvent) -> void:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * sens))
			$FIRST.rotate_x(deg_to_rad(-event.relative.y * sens))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
