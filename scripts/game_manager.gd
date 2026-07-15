extends Node

var camera: RmlCamera
var player: Player
var timer: SpeedrunTimer

var gpm: GameplayManager
var iman: ItemsManager

#
# HELPFUL FUNCTIONS TO CALL FROM ANYWHERE AT ANY TIME
#

var self_destruct_comp = preload("res://rmlibf_godot/prefabs/c_self_destruct.tscn") 
## Self destruct an object on a timer
func self_destruct_obj(n: Node, time: float):
	var sd = self_destruct_comp.instantiate()
	(sd as RmlSelfDestruct).remaining_life = time
	n.add_child(sd)


var toast_text = preload("res://rmlibf_godot/prefabs/toasty_dialogue.tscn") 
## Simple text popup
func toast(pos: Vector2, text: String, lifetime: float = 10000.0, prefab: RmlDialogue = null):
	var t = (prefab if prefab != null else (toast_text as RmlDialogue)).instantiate() as RmlDialogue
	t.basic_dialogue(text, 0.016, null)
	get_tree().root.add_child(t)
	t.global_position = pos - Vector2(250, 0)
	self_destruct_obj(t, lifetime)

## Simple wait function 
## MAKE SURE YOU ACTUALLY `await ` IT!
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS ## ignore game pauses
