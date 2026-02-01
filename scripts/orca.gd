extends Area3D

@export var ORCA_SPEED: float = 20
@export var LEAPING: bool = true
@export var LEAP_HEIGHT: int = 12

@export var ORCA_STATE: ORCA_STATES = ORCA_STATES.FOLLOW
@onready var leap_timer = $LeapTimer

enum ORCA_STATES {FOLLOW, LEAP}

func _ready():
	ORCA_STATE = ORCA_STATES.FOLLOW
	reset_timer()

func _physics_process(delta):
	if ORCA_STATE == ORCA_STATES.LEAP:
		if LEAPING:
			leap(delta)
		else:
			fall(delta)
	else:
		follow()

func leap(delta):
	transform.origin.y += ORCA_SPEED * delta
	
	if LEAP_HEIGHT < transform.origin.y:
		LEAPING = false

func fall(delta):
	transform.origin.y -= ORCA_SPEED / 2 * delta
	
	if -50 > transform.origin.y:
		ORCA_STATE = ORCA_STATES.FOLLOW
		LEAPING = true
		reset_timer()
		
func follow():
	var player: Player = get_tree().root.get_child(0).find_child("Player")
	transform.origin.x = player.transform.origin.x
	transform.origin.z = player.transform.origin.z

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("YOU LOSE")
		#body.queue_free() 
	
	if body.is_in_group("BabySeal") or body.is_in_group("Fish"):
		body.queue_free()


func reset_timer():
	leap_timer.wait_time = randf_range(15, 30)	
	leap_timer.start()
	
func _on_leap_timer_timeout():
	ORCA_STATE = ORCA_STATES.LEAP
