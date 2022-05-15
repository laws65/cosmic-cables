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
	var item_texture = item_representing.icon

	var display := get_node("Display") as Sprite
	display.texture = item_texture
	display.scale = display_size / item_texture.get_size()


func _physics_process(delta: float) -> void:
	print($AnimationPlayer.current_animation)
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
