extends Area3D

@export var ORCA_SPEED: float = 20
@export var LEAPING: bool = true
@export var LEAP_HEIGHT: int = 0

func _physics_process(delta):
	if LEAPING:
		leap(delta)
	else:
		fall(delta)

func leap(delta):
	transform.origin.y += ORCA_SPEED * delta
	
	if LEAP_HEIGHT < transform.origin.y:
		LEAPING = false

func fall(delta):
	transform.origin.y -= ORCA_SPEED / 2 * delta
	
	if -20 > transform.origin.y:
		LEAPING = true
		
func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("YOU LOSE")
		#body.queue_free() 
	
	if body.is_in_group("BabySeal") or body.is_in_group("Fish"):
		body.queue_free()
