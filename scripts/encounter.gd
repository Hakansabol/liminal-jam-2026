extends Control
class_name Encounter

@export var buttonfab: PackedScene

## list of objects that are culled by cull_children
var cull_list: Array[Control] = []
## Cull the objects listed for culling. useful for progressing state.
func cull_children():
	for a in cull_list:
		a.queue_free()
	cull_list = []

func _ready() -> void:
	GameManager.gpm.encounters.append(self) # register self with the GPM

#
# VIRTUAL METHODS
#

## virtual function.
## called by GPM when the encounter shows up on screen
## set up the buttons to press and/or the combat
func _on_encounter() -> void:
	pass

## spawns a generic button at the position specified with the text specified.
## Calls the method named `method` on the **calling object** when pressed (should be an Encounter)
func spawn_button(x:float,y:float, method: String, text: String = "")->EncButton:
	var n = buttonfab.instantiate() as EncButton
	add_child(n)
	n.global_position = Vector2(x, y) - n.size * 0.5
	n.text = method if not text else text
	n.pressed.connect(func(): call(method)) # link function
	return n

#
# HELPER METHODS
# These are short declarations shared by all Encounter scripts to make writing them more ergonomic.
#

func damage_player(amt: int):
	var gpm = GameManager.gpm
	GameManager.camera.shake(amt*2)
	gpm.set_player_hp(gpm.player_hp - amt)
	
func reset_dialogue():
	GameManager.gpm.dialogue.text = ""

## Must be called at the end of any path or the game will be softlocked (bad!)
func gonext():
	GameManager.gpm.next_encounter()
