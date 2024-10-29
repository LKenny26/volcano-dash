extends CharacterBody3D
class_name Player

@onready var head = $Head
@onready var standing_collision = $StandingCollisionShape
@onready var crouching_collision = $CrouchingCollisionShape # disabled on start
@onready var ray_cast = $RayCast3D # will use to check if there's an obj above the user while crouching
@onready var running_sound: AudioStreamPlayer3D = $RunningSound
@onready var sfx_lava: AudioStreamPlayer3D = $SFX_Lava
@onready var sfx_jump: AudioStreamPlayer3D = $SFX_Jump
@onready var sfx_cave: AudioStreamPlayer3D = $SFX_Cave


var curr_speed = 20.0 # will change based on if player is walking/sprinting/crouching
const walk_speed = 20.0 # default speed
const sprint_speed = 30.0 # speed when player sprints
const crouch_speed = 10.0 # speed when player crouches
const jump_velocity = 15.0
const mouse_sense = 0.25 # mouse sensitivity
var crouch_height = -0.75 # height camera will go down by while player is crouching
var lerp_speed = 10.0 # helps "transition" between movements look smoother
var player_health = 100
var is_invincible = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # "hides" mouse cursor so it can't be seen
	is_invincible = GameState.nux_mode_enabled
	print("Player ready. Invincibility status:", is_invincible)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: # checks if player is moving mouse
		rotate_y(-deg_to_rad(event.relative.x * mouse_sense)) # lets player move camera left and right
		head.rotate_x(-deg_to_rad(event.relative.y * mouse_sense)) # lets player move camera up and down
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89)) # locks player rotation when looking up and down
		
	if event.is_action_pressed("escape")	:
		$PauseMenu.pause()

func _physics_process(delta: float) -> void:
	# sets gravity
	var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") 
	
	# sets speed when player is crouching (player can't sprint while crouching)
	if Input.is_action_pressed("crouch"):
		curr_speed = crouch_speed
		head.position.y = lerp(head.position.y, crouch_height, delta*lerp_speed)
		standing_collision.disabled = true # turn off standing collision shape
		crouching_collision.disabled = false # turn on crouching collision shape
	# checks if there's an object above the player while they're crouching
	elif !ray_cast.is_colliding():
		head.position.y = lerp(head.position.y, 0.0, delta*lerp_speed) # original camera height
		standing_collision.disabled = false # turn on standing collision shape
		crouching_collision.disabled = true # turn off crouching collision shape
		if Input.is_action_pressed("sprint"):
			curr_speed = sprint_speed
			running_sound.pitch_scale = randf_range(1.0, 1.2)
			var tween = get_tree().create_tween()
			tween.tween_property($Head/Camera3D, "fov", 100, 0.5)
		else:
			curr_speed = walk_speed
			running_sound.pitch_scale = randf_range(0.65, 0.75)
			var tween = get_tree().create_tween()
			tween.tween_property($Head/Camera3D, "fov", 70, 0.5)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		sfx_jump.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * curr_speed
		velocity.z = direction.z * curr_speed
	else:
		velocity.x = move_toward(velocity.x, 0, curr_speed)
		velocity.z = move_toward(velocity.z, 0, curr_speed)
		running_sound.play()
		
	move_and_slide()
	
	# Vary sound effects
	sfx_lava.pitch_scale = randf_range(0.5, 1.2)
	
func apply_damage(damage_amount: int) -> void:
	if not is_invincible:
		player_health -= damage_amount
		print("Player health: %d" % player_health)
		if player_health <= 0:
			die()
			
func die() -> void:
	print("Player died!")
	get_tree().reload_current_scene()
