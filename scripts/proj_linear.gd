extends RmlProjectile
class_name RmlProjectileLinear

@export_group("Linear Projectile")
@export var acceleration: Vector2 ## The 2D acceleration this projectile will experience per second. Non-deterministic if modified to invoke in _process().
@export_group("")

var velocity: Vector2 ## The current 2D velocity. Projectiles may use acc, vel, both, or neither. They should still function.
var lifetime: float ## The time this projectile will live for.
var delay: float ## The delay (in seconds) is the length of the period when the projectile is spawned but not active. It will not move, accelerate, or register collision events during this period. Useful for attacks that require precursors to telegraph more fairly to the player.
func initialize(_src: RmlEntity, vel: Vector2, life: float, del: float = 0):
	velocity = vel
	lifetime = life
	delay = del

func _physics_process(delta: float) -> void:
	velocity += acceleration * delta
	lifetime -= delta
	if delay > 0:
		delay -= delta
		return

	position += velocity * delta
	if lifetime < 0:
		queue_free()
