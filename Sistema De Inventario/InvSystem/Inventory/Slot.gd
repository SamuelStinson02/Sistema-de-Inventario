extends Panel

#	Textures
var default_tex = preload("res://InvSystem/Assets/item_slot_default_background.png")
var empty_tex = preload("res://InvSystem/Assets/item_slot_empty_background.png")

#	Styles
var default_style : StyleBoxTexture = null 
var empty_style : StyleBoxTexture = null 

var ItemClass = preload("res://InvSystem/Item/Item.tscn") #Preload the scene will have the items
var item = null
var slot_index

enum SlotType {INVENTORY, HELMET, CHEST, BOOTS, SWORD, SHIELD, BOW}
var slot_type = null

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	refresh_style()
"""	if randi() % 2 == 0:
		item = ItemClass.instance()
		add_child(item)"""



#	Funcion para actualizar el estado de los slots
func refresh_style():
	if item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)


#	Funcion para coger items de los slots
func pick_from_slot():
	remove_child(item)
	var inventory_node = find_parent("UI")
	inventory_node.add_child(item)
	item = null
	refresh_style()


#	Funcion para poner items dentro del slot
func put_into_slot(new_item):
	item = new_item
	item.position = Vector2.ZERO
	var inventory_node = find_parent("UI")
	inventory_node.remove_child(item)
	add_child(item)
	refresh_style()


func initialize_item(item_name, item_amount):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_amount)
	else:
		item.set_item(item_name, item_amount)
	refresh_style()

