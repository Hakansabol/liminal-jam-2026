extends Control
class_name Encounter

@export var buttonfab: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.gpm.encounters.append(self)

func _on_encounter() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#
# VIRTUAL METHODS
#
func spawn_button(x:float,y:float, method: String):
	var n = buttonfab.instantiate() as EncButton
	add_child(n)
	n.position = Vector2(x, y)
	n.pressed.connect(func(): call(method)) # link function

func pr():
	print("pressed")
