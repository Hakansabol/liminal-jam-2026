@icon("res://rmlibf_godot/editor_assets/rml_asset_entity.png")
extends CollisionObject2D
class_name RmlEntity

func get_scene_root() -> Node:
	return get_tree().root.get_child(1)
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

enum Team {
	Player = 1,
	Enemy = 2,
	Ally = 4,
	Neutral = 8
}

@warning_ignore("enum_variable_without_default")
@export var team: Team
@export var MAX_HEALTH: float
@export var current_health: float

func _ready() -> void:
	current_health = MAX_HEALTH
	if team == 0:
		printerr("No team set on object: " + name + "! Behavior will be incorrect!")

func _damage(health: int):
	current_health -= health

	if current_health <= 0:
		_on_death()

func _on_death():
	queue_free()
