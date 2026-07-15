extends EncounterCombat

# 
# Encounter: SHADOW SHARK
# Type: COMBAT
# Rarity: common
# 
# you are forced to fight the shark.
# pre-combat options allow you to nerf its damage or its health
#

func _on_encounter() -> void:
	var b1 = spawn_button(-300,0,"kill" ,"kill.")
	cull_list.append(b1)

func kill() -> void:
	cull_children()
	var gpm = GameManager.gpm
	gpm.enemy_max_health = 173
	gpm.enemy_damage_ticks_needed = 180
	gpm.ENEMY_DAMAGE_VALUE = 23
	gpm.start_combat(self)


func _on_end_combat() -> void:
	var b1 = spawn_button(00,400,"gonext", "Continue")
	cull_list.append(b1)
