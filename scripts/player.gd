extends CharacterBody3D

class_name Player

@export var MOVE_SPEED: float = 5.0
@export var SLOW_SPEED: float = .02

const JUMP_VELOCITY: float = 4.5

@export var POWER: float = 0
@export var POWER_GAIN: float = 10
@export var ROTATION_SPEED: float = 1.5

@export var FISH_SCORE: int = 0
@export var SEALS_SAVED: int = 0

# Add Hunger to the player, fish replenish it
# 3 Different Color Fish: Blue, Red, Gold
@export var HUNGER_METER: float = 100.0
@export var HUNGER_DRAIN: float = 1


@onready var power_display: HBoxContainer = find_child("UI").find_child("VBoxContainer").find_child("PowerDisplay")
@onready var velocity_display: HBoxContainer = find_child("UI").find_child("VBoxContainer").find_child("VelocityDisplay")
@onready var score_display: HBoxContainer = find_child("UI").find_child("VBoxContainer").find_child("ScoreDisplay")
@onready var seal_display: HBoxContainer = find_child("UI").find_child("VBoxContainer").find_child("SealDisplay")
@onready var hunger_display: HBoxContainer = find_child("UI").find_child("VBoxContainer").find_child("HungerDisplay")

func _ready():
	$CameraPivot/SpringArm3D.add_excluded_object(self)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	# REG MOVEMENT ON SNOW THEN DISABLED WHEN ON ICE
	## TRADITIONAL MOVEMENT
	#regular_movement()
	#rotate_movement(delta)
	
	## POWER SLIDE MOVEMENT
	power_movement(delta)
	#power_movement_zero_velocity(delta)
	
	display_labels()
	hunger(delta)

func hunger(delta):
	HUNGER_METER -= HUNGER_DRAIN * delta
	
	if (HUNGER_METER < -2):
		game_over()
	
func display_labels():
	power_display.find_child("PowerUpdate").text = str(POWER)
	velocity_display.find_child("VelocityUpdate").text = str(velocity)
	score_display.find_child("ScoreUpdate").text = str(FISH_SCORE)
	seal_display.find_child("SealUpdate").text = str(SEALS_SAVED)
	hunger_display.find_child("HungerUpdate").text = str(HUNGER_METER)

#func regular_movement():
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#
	#if direction:
		#velocity.x = direction.x * MOVE_SPEED
		#velocity.z = direction.z * MOVE_SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, 1)
		#velocity.z = move_toward(velocity.z, 0, 1)
#
	#move_and_slide()
#
#func rotate_movement(delta):
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction = (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
	#
	#player_rotation(delta)
	#
	#if direction:
		#velocity.x = direction.x * MOVE_SPEED
		#velocity.z = direction.z * MOVE_SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SLOW_SPEED)
		#velocity.z = move_toward(velocity.z, 0, SLOW_SPEED)
#
	#move_and_slide()

func power_movement(delta):
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = Vector3.ZERO
	 
	if Input.is_action_pressed("ui_accept"):
		POWER += POWER_GAIN * delta
		POWER = clamp(POWER, 0, 100)
		
	if Input.is_action_just_released("ui_accept"):
		direction = (transform.basis * Vector3(0, 0, -1)).normalized()
		
	player_rotation(delta)
	
	if direction:
		velocity.x += direction.x * POWER
		velocity.z += direction.z * POWER
		POWER = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SLOW_SPEED)
		velocity.z = move_toward(velocity.z, 0, SLOW_SPEED)
		
	move_and_slide()

func player_rotation(delta):
	if Input.is_action_pressed("ui_right"):
		rotation.y -= ROTATION_SPEED * delta
	if Input.is_action_pressed("ui_left"):
		rotation.y += ROTATION_SPEED * delta

func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
