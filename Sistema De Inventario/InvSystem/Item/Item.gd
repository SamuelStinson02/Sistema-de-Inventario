extends Node2D

var item_name
var item_amount
var item_type
var item_description

func _ready():
	var rand_val = randi() % 3
	if rand_val == 0:
		item_name = "Iron Sword"
	elif rand_val == 1:
		item_name = "Tree Branch"
	else:
		item_name = "Slime Potion"
	
	$ItemTexture.texture = load("res://InvSystem/Assets/ItemsDatabase/" + item_name + ".png")
	var stack_size = int(Jsondata.item_data[item_name]["StackSize"])
	var type = str(Jsondata.item_data[item_name]["Type"])
	var description = str(Jsondata.item_data[item_name]["Description"])
	item_amount = randi() % stack_size + 1
	
	if stack_size == 1:
		$Amount.visible = false
	else:
		$Amount.text = String(item_amount)


func add_item_amount(amount_to_add):
	item_amount += amount_to_add
	$Amount.text = String(item_amount)


func set_item(nm, qt):
	item_name = nm
	item_amount = qt
	$ItemTexture.texture = load("res://InvSystem/Assets/ItemsDatabase/" + item_name + ".png")
	
	var stack_size = int(Jsondata.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Amount.visible = false
	else:
		$Amount.visible = true
		$Amount.text = String(item_amount)
	var type = str(Jsondata.item_data[item_name]["Type"])
	var description = str(Jsondata.item_data[item_name]["Description"])



func decrease_item_amount(amount_to_remove):
	item_amount -= amount_to_remove
	$Amount.text = String(item_amount)
