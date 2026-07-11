extends Node
class_name GameplayManager

@export var dialogue: RmlDialogue
@export var soundbyte: AudioStreamPlayer2D
func simple_dialogue(text: String, delay: float):
	await dialogue.basic_dialogue(text, delay, soundbyte)

var player_hp: int = 100
var player_max_hp: int = 100

func _init() -> void:
	GameManager.gpm = self

func _ready() -> void:
	for a in encounters:
		a.visible = false
	play_game()

@export var health_bar : TextureProgressBar
## set player hp
## clamped. If set to zero, you die.
## also updates the health bar
func set_player_hp(amt: int):
	player_hp = clampi(amt, 0, player_max_hp)
	var rtio = (player_hp as float) / (player_max_hp as float)
	health_bar.value = rtio * health_bar.max_value
	if amt <= 0:
		die()
func die():
	print("YOU DIE")

## set player max hp
## also applies healing and damage as necessary
func set_player_max_hp(amt: int):
	var prev = player_max_hp
	player_max_hp = amt
	if amt > prev:
		set_player_hp(player_hp + (amt - prev)) # heal when gaining maxhp
	player_hp = clampi(player_hp, 0, player_max_hp) # reclamp hp when losing maxhp.
	

var encounters: Array[Encounter] = []

func play_game():
	set_player_hp(player_max_hp)
	next_encounter()

var encounter_id = -1
func next_encounter():
	print(encounters)
	# disable last encounter
	if encounter_id >= 0 and encounter_id < encounters.size():
		encounters[encounter_id].visible = false
		dialogue.text = ""

	# enable next encounter
	encounter_id += 1
	if encounter_id >= encounters.size():
		return

	var e = encounters[encounter_id]
	e.visible = true
	e._on_encounter()
