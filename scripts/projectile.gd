@icon("res://rmlibf_godot/editor_assets/rml_asset_projectile.png")
extends Area2D
class_name RmlProjectile

# Most basic projectile script, a static object that detects collisions.

# Target mask, to be ANDed with the team of the hit collider to determine if they register the collision
@export_group("Basic Projectile")
@export var target_mask: int = 9
@export var damage: float = 1.0
@export_group("")

var hit_list: Array = []
var initialized: bool = false
func _ready() -> void:
	body_shape_entered.connect(_on_body_shape_entered)
	initialized = true

func _draw() -> void:
	if not initialized:
		print("object not initialized!! " + name)

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	# try to cast the body to an entity
	var enemy: RmlEntity = body as RmlEntity
	if enemy == null:
		return

	_on_hit(enemy)

func _on_hit(body: RmlEntity):
	if body.team & target_mask > 0:
		body._damage(damage)
	pass
