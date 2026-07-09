extends RmlEntity
class_name Player

## Default godot player controller
## Gravity-based movement
## Override _move() !!

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var character_body: CharacterBody2D

func _ready() -> void:
	super._ready()
	character_body = (self as CollisionObject2D) as CharacterBody2D

func _physics_process(delta: float) -> void:
	_move(delta)

func _move(delta: float) -> void:
	# Add the gravity.
	if not character_body.is_on_floor():
		character_body.velocity += character_body.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and character_body.is_on_floor():
		character_body.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		character_body.velocity.x = direction * SPEED
	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, SPEED)

	character_body.move_and_slide()

func _on_death():
	print("I AM VERY DEAD!!!!")
