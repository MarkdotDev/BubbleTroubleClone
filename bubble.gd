extends RigidBody2D

var size = 3 # 3 = large, 2 = medium, 1 = small
const SPLIT_FORCE = 200
const BOUNCE_FORCE = -300

func _ready() -> void:
	add_to_group("bubbles")
	call_deferred("setup_bubble_size")
	GameManager.register_bubble()

	gravity_scale = 0.8
	
	var physics_material = PhysicsMaterial.new()
	physics_material.bounce = 1.0
	physics_material.friction = 0.0
	physics_material_override = physics_material
	
	linear_damp = 0.0

func setup_bubble_size() -> void:
	var scale_factor = size * 0.5
	scale = Vector2(scale_factor, scale_factor)
	mass = size * 2

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("arrows"):
		body.queue_free()
		split()

func split() -> void:
	GameManager.on_bubble_pop(size)
	
	if size > 1:
		call_deferred("spawn_smaller_bubbles")

	queue_free()
	GameManager.deregister_bubble()

func spawn_smaller_bubbles() -> void:
	for i in range(2):
		var new_bubble = load("res://bubble.tscn").instantiate()
		new_bubble.size = size - 1
		new_bubble.position = position
		new_bubble.linear_velocity = Vector2(SPLIT_FORCE if i == 0 else -SPLIT_FORCE, BOUNCE_FORCE)
		get_parent().add_child(new_bubble)
		GameManager.register_bubble()
