extends Area2D


export var item_representing: Resource setget ,get_item_representing

var display_size := Vector2(16, 16)

var allow_pickup: bool
var picked_up: bool
var velocity: Vector2
var friction = 0.1

func _ready() -> void:
	var item_texture = item_representing.icon

	var display := get_node("Display") as Sprite
	display.texture = item_texture
	display.scale = display_size / item_texture.get_size()


func _physics_process(delta: float) -> void:
	position += velocity * delta
	velocity = lerp(velocity, Vector2.ZERO, friction)
func get_item_representing() -> Item:
	return item_representing as Item


func pickup() -> void:
	picked_up = true
	$AnimationPlayer.play("pickup")


func _on_AllowPickupDelay_timeout() -> void:
	allow_pickup = true
