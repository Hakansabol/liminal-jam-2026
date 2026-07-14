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
	GameManager.gpm.start_combat()
