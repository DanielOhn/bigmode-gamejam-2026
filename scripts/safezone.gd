extends Area3D

func _on_body_entered(body):
	print(body)
	if body.is_in_group("BabySeal"):
		var player: Player = get_tree().root.get_child(0).find_child("Player")
		
		player.SEALS_SAVED += 1
		body.queue_free()
		print("baby seal saved :)")
