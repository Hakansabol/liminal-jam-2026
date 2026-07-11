extends Encounter

# 
# Encounter: DOG
# Type: Starter
# Rarity: every game lol
# 
# take the dog for easy mode.
# leave the dog for hard mode.
#

func _on_encounter() -> void:
	var b1 =spawn_button(-300,0,"take" ,"Take the dog.")
	var b2 = spawn_button(300,0,"attack","Attack the dog.")
	cull_list.append(b1)
	cull_list.append(b2)

func attack():
	cull_children()
	await GameManager.gpm.simple_dialogue("[red][jit2]That is not a good idea.[][]", 0.04)
	
	var b1 = spawn_button(00,400,"taketwo", "[jit2]Make a better choice.[]")
	cull_list.append(b1)

func taketwo():
	cull_children()
	reset_dialogue()
	var b1 =spawn_button(-300,0,"take" ,"Take the dog.")
	var b2 = spawn_button(300,0,"ignore","[salmon]Ignore[] the dog.")
	cull_list.append(b1)
	cull_list.append(b2)

func ignore():
	cull_children()
	await GameManager.gpm.simple_dialogue("[beat]You will regret this greatly.", 0.04)
	var b1 = spawn_button(00,400,"gonext", "Continue")
	cull_list.append(b1)

func take():
	cull_children()
	await GameManager.gpm.simple_dialogue("[beat]You won't regret this!", 0.04)

	var b1 = spawn_button(00,400,"gonext", "Continue")
	cull_list.append(b1)
