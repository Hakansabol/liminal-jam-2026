extends Encounter

#
# Encounter: BALL
# Type: Item
# Rarity: 1
#

func _on_encounter() -> void:
	var b1 =spawn_button(-300,0,"touch")
	var b2 = spawn_button(300,0,"eat")
	cull_list.append(b1)
	cull_list.append(b2)

func touch():
	cull_children()
	await GameManager.gpm.simple_dialogue("the ball is smoother than anything you've touched before.", 0.04)

	spawn_button(00,400,"gonext", "Continue")

func eat():
	cull_children()
	await GameManager.gpm.simple_dialogue("The ball was actually cake! You restored 50 health.", 0.04)
	GameManager.gpm.set_player_hp(GameManager.gpm.player_hp + 50)
	
	spawn_button(00,400,"gonext", "Continue")
