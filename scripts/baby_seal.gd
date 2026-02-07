extends RigidBody3D


@onready var audio_player = $AudioStreamPlayer3D

const ARF_1 = preload("uid://dmckkbwoej6k3")
const ARF_2 = preload("uid://cpxynt00ked4o")

const ARFS_SE: Array = [ARF_1, ARF_2]

func play_arf():
	audio_player.stream = ARFS_SE.pick_random()
	audio_player.play()

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		play_arf()
