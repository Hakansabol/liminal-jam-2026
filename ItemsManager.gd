extends GridContainer
class_name ItemsManager

@export var item_prefabs: Array[PackedScene] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.iman = self

# 0: maxhp+
# 1: 

var max_items = 9
func add_item(id: int) -> bool:
	if get_children().size() >= max_items:
		return false
	var obj = (item_prefabs[id]).instantiate()
	add_child(obj)
	return true

func get_count_of(id: int) -> int:
	var ans = 0
	for a in get_children():
		if a as ItemScript:
			if (a as ItemScript).id == id:
				ans += 1
	return ans

func use_item_by_id(id: int):
	var gpm = GameManager.gpm
	print("item used: " + str(id))

	if id == 0: # increase max hp by <missing hp> without healing.
		var missing_hp = gpm.player_max_hp - gpm.player_hp
		GameManager.gpm.set_player_max_hp(GameManager.gpm.player_max_hp + missing_hp)
		GameManager.gpm.set_player_hp(GameManager.gpm.player_hp - missing_hp)
