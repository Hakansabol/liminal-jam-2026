@tool
extends RichTextAnimation
class_name RmlDialogue

func _ready() -> void:
	on_character.connect(_on_on_character)

func get_scene_root() -> Node:
		return get_tree().root.get_child(1)
func wait(seconds: float) -> void:
		await get_tree().create_timer(seconds).timeout

func basic_dialogue(txt: String, delay: float, sound_source: AudioStreamPlayer2D):
	set_bbcode(txt)
	soundbyte = sound_source
	play_speed = 1.0 / delay
	set_progress(0)
	await self.anim_finished
	return

@export var soundbyte: AudioStreamPlayer2D
const character_silence_array: Array[String] = [' ']
func _on_on_character(_idx: int):
	if soundbyte and not ((self as RichTextLabel).get_parsed_text()[_idx]) in character_silence_array:
		soundbyte.play()
