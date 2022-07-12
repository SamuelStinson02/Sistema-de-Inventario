extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED = 225

export(Texture) var ItemTexture
export(String) var item_name
enum type {MISC, EQUIPABLE, CONSUMABLE}
export(type) var item_type
export(String) var item_description

var velocity = Vector2.ZERO

var player = null
var being_picked_up = false

func _ready():
	$Sprite.texture = ItemTexture
	


func _physics_process(delta):
	if being_picked_up == false:
		velocity = velocity.move_toward(Vector2(0, MAX_SPEED), ACCELERATION * delta)
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 4:
			PlayerInventory.add_item(item_name, 1)
			queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)
	$AnimationPlayer.play("Float")

func pick_up_item(body):
	player = body
	being_picked_up = true
