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
	end_combat()
	for a in encounters:
		a.visible = false
	play_game()

#
# SEQUENCING
#
## Auto-generated list of encounters the player will encounter. Can be mutated.
var encounters: Array[Encounter] = []

## Starts the game. Runs in _ready().
func play_game():
	set_player_hp(player_max_hp)
	next_encounter()

var encounter_id = -1
## Advances to the next encounter, probably :P
func next_encounter():
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

#
# HEALTH & COMBAT
#
## the player's health bar
@export var health_bar : TextureProgressBar
## set player max hp
## also applies healing and damage as necessary
func set_player_max_hp(amt: int):
	var prev = player_max_hp
	player_max_hp = amt
	if amt > prev:
		set_player_hp(player_hp + (amt - prev)) # heal when gaining maxhp
	player_hp = clampi(player_hp, 0, player_max_hp) # reclamp hp when losing maxhp.
	update_player_hp_bar()
## set player hp
## clamped. If set to zero, you die.
## also updates the health bar
func set_player_hp(amt: int):
	player_hp = clampi(amt, 0, player_max_hp)
	update_player_hp_bar()
	if amt <= 0:
		die()
func update_player_hp_bar():
	var rtio = (player_hp as float) / (player_max_hp as float)
	health_bar.value = rtio * health_bar.max_value
	cbt_player_hp_dial_current.bbcode = str(player_hp)
	cbt_player_hp_dial_max.bbcode = str(player_max_hp)
func die():
	print("YOU DIE")

func _physics_process(delta: float) -> void:
	combat_tick()

@export var combat_hud: Control
@export var cbt_enemy_time_slider: TextureProgressBar
@export var cbt_enemy_damage_dial: RicherTextLabel
@export var cbt_enemy_health_value: RicherTextLabel
@export var cbt_enemy_health_bar: TextureProgressBar
@export var cbt_player_time_slider: TextureProgressBar
@export var cbt_player_damage_dial_left: RicherTextLabel
@export var cbt_player_damage_dial_right: RicherTextLabel
@export var cbt_player_hp_dial_current: RicherTextLabel
@export var cbt_player_hp_dial_max: RicherTextLabel

var enemy: EncounterCombat = null
var enemy_max_health = 300
var enemy_health = 0
func start_combat(src: EncounterCombat):
	enemy = src
	combat_hud.visible = true
	player_damage_ticks = player_damage_ticks_needed
	player_damage_value = 0
	enemy_damage_ticks = enemy_damage_ticks_needed
	set_enemy_health(enemy_max_health)
func end_combat():
	combat_hud.visible = false
	if enemy:
		enemy._on_end_combat()
var player_damage_ticks : int = 0 # decreases then resets
var player_damage_ticks_needed : int = 30
var player_damage_value_per : int = 10 # decreases over time
var player_damage_value : int = 0 # increases over time
func getpdvp() -> int:
	return maxi(player_damage_value_per - (player_damage_value / 50), 0)

var enemy_damage_ticks : int = 0 # decreases then resets
var enemy_damage_ticks_needed : int = 60
var ENEMY_DAMAGE_VALUE : int = 3

func combat_tick():
	if not combat_hud.visible:
		return

	enemy_damage_ticks -= 1
	if enemy_damage_ticks <= 0:
		enemy_attack()
		enemy_damage_ticks = enemy_damage_ticks_needed
	cbt_enemy_time_slider.value = (1 - (enemy_damage_ticks as float) / (enemy_damage_ticks_needed as float)) * 100

	player_damage_ticks -= 1
	if player_damage_ticks <= 0:
		player_damage_ticks = player_damage_ticks_needed
		player_damage_value += getpdvp()
	cbt_player_time_slider.value = (1 - (player_damage_ticks as float) / (player_damage_ticks_needed as float)) * 100
	
	# player attacks hud
	cbt_player_damage_dial_left.bbcode = str(getpdvp())
	cbt_player_damage_dial_right.bbcode = str(player_damage_value)
	cbt_enemy_damage_dial.bbcode = str(ENEMY_DAMAGE_VALUE)
	
func player_attack():
	print("attacked for " + str(player_damage_value) + " damage")
	set_enemy_health(enemy_health - player_damage_value)
	player_damage_value = 0

func enemy_attack():
	set_player_hp(player_hp - ENEMY_DAMAGE_VALUE)

func set_enemy_health(n: int):
	enemy_health = n
	cbt_enemy_health_bar.value = ((enemy_health as float) / (enemy_max_health as float)) * cbt_enemy_health_bar.max_value
	cbt_enemy_health_value.bbcode = str(enemy_health)

	if enemy_health < 0:
		end_combat()
