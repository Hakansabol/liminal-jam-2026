extends Camera2D
class_name RmlCamera

@export var effects: Array = []
@export var flash_white_sprite: Sprite2D

class smoothing_effect:
	var effect_name: String
	var smoothing_type: String # static, pulse, decay
	var strength: float
	var time: float
	var time_elapsed: float

	func _init(n: String, t: String, strength_of_effect: float, time_len: float) -> void:
		self.effect_name = n
		self.smoothing_type = t
		self.strength = strength_of_effect
		self.time = time_len
		self.time_elapsed = 0


func shake(strength: float):
	effects.push_back(smoothing_effect.new("shake", "pulse", strength, 5))

func flash_white_decaying(opacity: float, duration: float):
	effects.push_back(smoothing_effect.new("flash_white", "no_smooth", opacity, duration))

func flash_white_decaying_fr_fr(opacity: float, duration: float):
	effects.push_back(smoothing_effect.new("flash_white", "linear", opacity, duration))

func _ready() -> void:
	if not GameManager:
		print("No game manager found! Add one as an autoload to register singletons!")
	else:
		GameManager.camera = self

var last_displacement: Vector2 = Vector2(0, 0)
func _process(delta: float) -> void:
	var shake_amt: float = 0
	var flash_white: float = 0

	# push all the numbers into the effects
	for i in range(effects.size()-1, -1, -1):
		# Grab the data from the iterator
		var eff: smoothing_effect = effects[i] as smoothing_effect
		var value: float = 0

		# !!! Apply smoothing (numerical decay) types. If you don't do this, the effect will not fade away, instead just disappearing (if this is intended, use "no_smooth" type)
		if eff.smoothing_type == "pulse":
			value = eff.strength * pow(0.9, (eff.time_elapsed / eff.time) * 500)
		elif eff.smoothing_type == "linear":
			value = eff.strength * (1- eff.time_elapsed / eff.time)
		elif eff.smoothing_type == "no_smooth":
			value = eff.strength
		else:
			print("bad smoothing name")

		# !!! Apply the effects here. If you don't do this, the effects won't visually appear at all.
		if eff.effect_name == "shake":
			shake_amt += value
		elif eff.effect_name == "flash_white":
			flash_white = max(flash_white, value)
		else:
			print("bad effect name")

		# Clear the effect out of the list once it decays. If you don't do this, the list will continue to grow and consume memory and loop cycles every frame.
		if eff.time_elapsed > eff.time:
			effects.pop_at(i)

		eff.time_elapsed += delta
	
	# !!! apply all the effects
	# Screen shake
	var new_displacement: Vector2 = Vector2(randf_range(-shake_amt,shake_amt), randf_range(-shake_amt,shake_amt))
	global_position = global_position - last_displacement + new_displacement
	last_displacement = new_displacement

	# flash
	if flash_white_sprite:
		flash_white_sprite.self_modulate.a = flash_white
