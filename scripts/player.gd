extends CharacterBody3D

class_name Player

@export var MOVE_SPEED: float = 5.0
@export var SLOW_SPEED: float = .02

const JUMP_VELOCITY: float = 4.5

@export var POWER: float = 0
@export var POWER_GAIN: float = 10
@export var POWER_MAX: float = 50
@onready var power_bar: ProgressBar = $UI/HBoxContainer/PowerContainer/PowerSlider/PowerBarImg/PowerBar

@export var ROTATION_SPEED: float = 1.5

@export var FISH_SCORE: int = 0
@export var SEALS_SAVED: int = 0
@onready var seals_saved: Label = $UI/VBoxContainer/SealsSaved

# Add Hunger to the player, fish replenish it
# 3 Different Color Fish: Blue, Red, Gold
@export var HUNGER_METER: float = 100.0
@export var HUNGER_DRAIN: float = 1
@export var HUNGER_METER_MAX: float = 240
@onready var hunger_bar: ProgressBar = $UI/HBoxContainer/HungerContainer/HungerSlider/HungerBarImg/HungerBar

@onready var menu_ui: Control = find_child("MenuUI")
@onready var seals_saved_anim: Node3D = $SealsSavedAnim

@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
const POWER_SLIDE_SE = preload("uid://bsdhekqpjloo8")
const NOM_SE = preload("uid://b68yifpht2euy")
const SEAL_SAVED_SE = preload("uid://bx0kw4a63pho")

func _ready():
	$CameraPivot/SpringArm3D.add_excluded_object(self)
	seals_saved_anim.visible = false
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_pressed("esc"):
		get_tree().paused = true
		menu_ui.visible = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	# REG MOVEMENT ON SNOW THEN DISABLED WHEN ON ICE
	## TRADITIONAL MOVEMENT
	#regular_movement()
	#rotate_movement(delta)
	
	## POWER SLIDE MOVEMENT
	power_movement(delta)
	#power_movement_zero_velocity(delta)
	
	#display_labels()
	hunger(delta)
	
	hunger_bar.max_value = HUNGER_METER_MAX
	power_bar.max_value = POWER_MAX
	power_bar.value = POWER
	

func hunger(delta):
	HUNGER_METER -= HUNGER_DRAIN * delta
	hunger_bar.value = HUNGER_METER
	HUNGER_METER = clamp(HUNGER_METER, 0, HUNGER_METER_MAX)
	
	if (HUNGER_METER < -2):
		game_over()
	

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
		POWER = clamp(POWER, 0, POWER_MAX)
		
	if Input.is_action_just_released("ui_accept"):
		direction = (transform.basis * Vector3(0, 0, -1)).normalized()
		audio_player.stream = POWER_SLIDE_SE
		audio_player.play()
		
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


func seal_saved():
	SEALS_SAVED += 1
	audio_player.stream = SEAL_SAVED_SE
	audio_player.play()
	
	seals_saved_anim.find_child("AnimationPlayer").play("PowerTextAction")
	
	if SEALS_SAVED >= 10:
		win_game()
		
	seals_saved.text = str(10 - SEALS_SAVED)

func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
func win_game():
	get_tree().change_scene_to_file("res://scenes/win_screen.tscn")

func _on_resume_btn_pressed():
	menu_ui.visible = false
	get_tree().paused = false


func _on_restart_btn_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_btn_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
