extends Area3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation.y += 1 * delta

func _on_body_entered(body):
	print(body)
	
	if body.is_in_group("Player"):
		print("Player")
		body.FISH_SCORE += 1
		queue_free()
		
