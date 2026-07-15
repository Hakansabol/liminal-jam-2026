extends Button
class_name ItemScript

@export var id: int = -1

func _ready() -> void:
	if id == -1:
		print("An item was initialized with an unset id!")

func _pressed() -> void:
	GameManager.iman.use_item_by_id(id)
	queue_free()
