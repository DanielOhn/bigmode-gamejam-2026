extends Area3D

func _on_body_entered(body):
	if body.is_in_group("BabySeal"):
		var player: Player = get_tree().root.get_child(0).find_child("Player")
		
		player.seal_saved()
		body.queue_free()
