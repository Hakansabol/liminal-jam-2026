extends Node
class_name GameplayManager

@export var dialogue: RmlDialogue
@export var soundbyte: AudioStreamPlayer2D
func simple_dialogue(text: String, delay: float):
	await dialogue.basic_dialogue(text, delay, soundbyte)

func _init() -> void:
	GameManager.gpm = self

func _ready() -> void:
	play_game()

var encounters: Array[Encounter] = []

func play_game():
	next_encounter()

var encounter_id = -1
func next_encounter():
	# disable last encounter
	if encounter_id >= 0 and encounter_id < encounters.size():
		encounters[0].visible = false
		dialogue.text = ""

	# enable next encounter
	encounter_id += 1
	if encounter_id >= encounters.size():
		return

	var e = encounters[encounter_id]
	e.visible = true
	e._on_encounter()
