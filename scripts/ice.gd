extends Node3D

@onready var dynamic_ice: Node3D = find_child("Dynamic")
@onready var static_ice: Node3D = find_child("Static")
@onready var static_collision: CollisionShape3D = static_ice.get_child(0).get_child(0).get_child(0)

@onready var reset_timer: Timer = find_child("ResetTimer")
@onready var spawn_timer: Timer = find_child("SpawnTimer")

@export var spawn_fish: bool = true

const FISH = preload("uid://gnwmqfn4geim")
const RED_FISH = preload("uid://d33pf8y88o66y")
const GOLD_FISH = preload("uid://gt80jt27xf2k")

const BABY_SEAL = preload("uid://brl3f1hdpflm4")

var fish_options: Array = []
var ice_dict: Dictionary = {}

var shattered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for ice: RigidBody3D in dynamic_ice.get_children():
		ice_dict.set(name + "_" + ice.name, ice.transform.origin)
		ice.freeze = true
		ice.add_to_group("Ice")
		ice.sleeping = true
		
	dynamic_ice.visible = false
	reset_timer.timeout.connect(_on_reset_timer_timeout)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	if spawn_fish:
		spawn_timer.wait_time = randf_range(10, 30)
		spawn_timer.start()
	
	fish_options.append(FISH)
	fish_options.append(RED_FISH)
	fish_options.append(GOLD_FISH)
	
func disable_static_ice():
	if static_ice.visible == true:
		static_ice.visible = false
		static_collision.disabled = true
		dynamic_ice.visible = true
		shattered = true


func reset_ice():
	for ice: RigidBody3D in dynamic_ice.get_children():
		ice.transform.origin = ice_dict.get(name + "_" + ice.name)
		ice.rotation = Vector3.ZERO
		ice.freeze = true
		ice.sleeping = true
		
	dynamic_ice.visible = false
	static_ice.visible = true
	static_collision.disabled = false
	shattered = false

func start_timer():
	reset_timer.start(10)

func _on_reset_timer_timeout():
	reset_ice()
	
func _on_spawn_timer_timeout():
	var chance: float = randf()
	
	if chance > .95 and !shattered:
		var pick_fish: PackedScene = null
		if chance >= .995:
			spawn_seal()
		elif chance >= .99:
			pick_fish = fish_options[2]
		elif chance >= .975:
			pick_fish = fish_options[1]
		elif chance >= .95:
			pick_fish = fish_options[0]
		
		if pick_fish != null:
			var fish = pick_fish.instantiate()
			
			get_tree().root.get_child(0).add_child(fish)
			fish.transform.origin = transform.origin + Vector3(randf_range(-5, 5), 1, randf_range(-5, 5))
	
	spawn_timer.wait_time = randf_range(10, 30)
	spawn_timer.start()
	

func spawn_seal():
	pass
	var seal = BABY_SEAL.instantiate()
	get_tree().root.get_child(0).add_child(seal)
	seal.transform.origin = transform.origin + Vector3.UP * 5
	

# Get Static
# Use Static until a Orca hits the ice
# When Ice is hit, after around 10 seconds it'll respawn
# When hit, it uses dynamic ice and shatters with the ones that were hit
# During this static visibility is disabled and CollisionShape3D for static is disabled

# After 10 seconds, the dynamic ice is reset to it's gobal position
# Gobal positions could be stored in array or map with each Ice_Cell
# Dynamic Ice is set back to Freeze mode 
# Static Ice is enabled again for both visibility and collision 
