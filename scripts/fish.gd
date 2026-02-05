extends Area3D
class_name fish

@export var HUNGER: float = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation.y += 1 * delta

func _on_body_entered(body):
	
	if body.is_in_group("Player"):
		body.FISH_SCORE += 1
		body.HUNGER_METER += HUNGER
		queue_free()
		
