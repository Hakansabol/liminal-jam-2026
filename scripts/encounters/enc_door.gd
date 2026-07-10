extends Encounter

func _on_encounter() -> void:
	spawn_button(-300,0,"touch")
	spawn_button(300,0,"eat")

func touch():
	print("player TOUCHed the DOOR")
	await GameManager.gpm.simple_dialogue("you touched the door. It was cold. Not unlike your own situation.", 0.02)
	GameManager.gpm.next_encounter()
