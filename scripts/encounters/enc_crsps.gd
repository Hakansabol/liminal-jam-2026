extends Encounter

#
# Encounter: CRSPS
# Type: Item
# Rarity: 1
#

func _on_encounter() -> void:
	var b1 =spawn_button(-300,0,"eat")
	var b2 = spawn_button(300,0,"touch")
	cull_list.append(b1)
	cull_list.append(b2)

func touch():
	cull_children()
	await GameManager.gpm.simple_dialogue("You take the Crsps.", 0.04)

	GameManager.iman.add_item(0)

	spawn_button(00,400,"gonext", "Continue")

func eat():
	cull_children()
	await GameManager.gpm.simple_dialogue("You ravenously consume the Crsps. Your health bar is increased and restored.", 0.04)
	GameManager.gpm.set_player_max_hp(GameManager.gpm.player_max_hp + 20)
	GameManager.gpm.set_player_hp(GameManager.gpm.player_max_hp)
	
	spawn_button(00,400,"gonext", "Continue")
