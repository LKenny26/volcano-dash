extends Node3D

var time = 0
@onready var Platform2 = $stage4/Platform2
@onready var Platform2Collision = $stage4/Platform2/CollisionShape3D
@onready var Platform4 = $stage4/Platform4
@onready var Platform4Collision = $stage4/Platform4/CollisionShape3D
var platforms 
var collisions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	platforms = [Platform2, Platform4]
	collisions = [Platform2Collision, Platform4Collision]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	time = time + 1
	var i = 0
	for plats in platforms:
		if (time % 3 == 0):
			plats.visible = !plats.visible
			if (plats.visible):
				collisions[i].disabled = false
			else: 
				collisions[i].disabled = true
			i+=1


func _on_collision_shape_3d_tree_entered() -> void:
	print("Winner")
	pass # Replace with function body.


func _on_collision_shape_3d_4_tree_entered() -> void:
	print("winner")
	pass # Replace with function body.
