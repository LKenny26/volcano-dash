extends Area3D
@export var player: Player

var lava_damage = 10
var rise_speed = 2.0
var player_in_lava = false
var damage_timer = 0.0
var damage_interval = 1.0

@onready var lava_mesh = $MeshInstance3D

func _ready() -> void:
	rise_speed = GameState.lava_speed

func _process(delta: float) -> void:
	# Move the lava up gradually
	lava_mesh.translate(Vector3(0, rise_speed * delta, 0))
	global_transform.origin.y += rise_speed * delta  # Move the collision shape
	
	if player_in_lava:
		if not player.is_invincible:
			player.die()

func _on_body_entered(body: Node3D) -> void:
	if body == player:
		player_in_lava = true
		print("Player has entered lava")

func _on_body_exited(body: Node3D) -> void:
	if body == player:
		player_in_lava = false
		damage_timer = 0.0
		print("Player has exited lava")
