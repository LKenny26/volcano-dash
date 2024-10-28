extends Area3D
@export var player: Player

var lava_damage = 10
var rise_speed = 1.0
var player_in_lava = false
var damage_timer = 0.0
var damage_interval = 1.0

@onready var lava_mesh = $MeshInstance3D

func _process(delta: float) -> void:
	# Move the lava up gradually
	lava_mesh.translate(Vector3(0, rise_speed * delta, 0))
	global_transform.origin.y += rise_speed * delta  # Move the collision shape
	
	if player_in_lava:
		get_tree().reload_current_scene()
		
		damage_timer += delta
		if damage_timer >= damage_interval:
			if player.has_method("apply_damage"):
				if player.player_health > 0:
					player.apply_damage(lava_damage)
					damage_timer = 0.0
				else:
					get_tree().reload_current_scene()

func _on_body_entered(body: Node3D) -> void:
	if body == player:
		player_in_lava = true
		print("Player has entered lava")

func _on_body_exited(body: Node3D) -> void:
	if body == player:
		player_in_lava = false
		damage_timer = 0.0
		print("Player has exited lava")
