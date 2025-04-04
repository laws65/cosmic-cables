extends KinematicBody2D
class_name GroundItem

export var item_representing: Resource setget ,get_item_representing

const display_size := Vector2(12, 12)
const friction = 0.1
const collision_damp = 0.8

var allow_pickup: bool
var picked_up: bool
var velocity: Vector2


func _ready() -> void:
	move_and_slide(Vector2.ZERO)
	call_deferred("move_and_slide", Vector2.ZERO)
	var item_texture = item_representing.icon
	var display := get_node("Display") as Sprite
	display.texture = item_texture
	display.scale = display_size / item_texture.get_size()

	# is resource
	if item_representing.type & 4 > 0:
		$Background.hide()


func _physics_process(delta: float) -> void:
	var col = move_and_collide(velocity * delta)
	if col:
		velocity = velocity.bounce(col.normal) * collision_damp

	velocity = lerp(velocity, Vector2.ZERO, friction)


func get_item_representing() -> Item:
	return item_representing as Item


func pickup() -> void:
	picked_up = true
	$AnimationPlayer.play("pickup")


func _on_AllowPickupDelay_timeout() -> void:
	allow_pickup = true


# For collision with asteroid
func get_mass() -> float:
	return 0.0


# For collision with asteroid
func get_elasticity() -> float:
	return 1.0


func set_pickup_delay(delay: float) -> void:
	allow_pickup = false
	$AllowPickupDelay.stop()
	$AllowPickupDelay.start(delay)
