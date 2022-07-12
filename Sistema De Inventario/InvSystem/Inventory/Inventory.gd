extends Node2D

const SlotClass = preload("res://InvSystem/Inventory/Slot.gd")

onready var inventory_slots = $SlotsContainer
onready var equip_slots = $EquipSlots.get_children()

onready var label_name = $Background/ItemName
onready var label_description = $Background/ItemDescription

var holding_item = null

func _ready():
	var slot = inventory_slots.get_children()
	for i in range(slot.size()):
		slot[i].connect("gui_input", self, "slot_gui_input", [slot[i]])
		slot[i].slot_index = i
		slot[i].slot_type = SlotClass.SlotType.INVENTORY
	
	for i in range(equip_slots.size()):
		equip_slots[i].connect("gui_input", self, "slot_gui_input", [equip_slots[i]])
		equip_slots[i].slot_index = i
	equip_slots[0].slot_type = SlotClass.SlotType.HELMET
	equip_slots[1].slot_type = SlotClass.SlotType.SWORD
	equip_slots[2].slot_type = SlotClass.SlotType.CHEST
	equip_slots[3].slot_type = SlotClass.SlotType.SHIELD
	equip_slots[4].slot_type = SlotClass.SlotType.BOOTS
	equip_slots[5].slot_type = SlotClass.SlotType.BOW
	
	initialize_inventory()
	initialize_equips()


func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])


func initialize_equips():
	for i in range(equip_slots.size()):
		if PlayerInventory.equips.has(i):
			equip_slots[i].initialize_item(PlayerInventory.equips[i][0], PlayerInventory.equips[i][1])



#	Funcion para controlar el input en el inventario 
func slot_gui_input(event: InputEvent, slot : SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if holding_item != null:
				if !slot.item:
					left_click_empty_slot(slot)
				else: 
				#	If diferent item swap
					if holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)


func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
	get_data()


func able_to_put_into_slot(slot: SlotClass):
	if holding_item == null:
		return true
	var holding_item_category = Jsondata.item_data[holding_item.item_name]["Category"]
	
	if slot.slot_type == SlotClass.SlotType.HELMET:
		return holding_item_category == "Helmet"
	elif slot.slot_type == SlotClass.SlotType.SWORD:
		return holding_item_category == "Sword"
	elif slot.slot_type == SlotClass.SlotType.CHEST:
		return holding_item_category == "Chest"
	elif slot.slot_type == SlotClass.SlotType.SHIELD:
		return holding_item_category == "Shield"
	elif slot.slot_type == SlotClass.SlotType.BOOTS:
		return holding_item_category == "Boots"
	elif slot.slot_type == SlotClass.SlotType.BOW:
		return holding_item_category == "Bow"
	return true
		


func get_data():
	if holding_item == null:
		label_name.text = "Name"
		label_description.text = "Description"
	else:
		var holding_item_name = Jsondata.item_data[holding_item.item_name]["Name"]
		label_name.text = holding_item_name
		var holding_item_description = Jsondata.item_data[holding_item.item_name]["Description"]
		label_description.text = holding_item_description


#Funcion para colocar el item seleccionado en el slot
func left_click_empty_slot(slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(holding_item, slot)
		slot.put_into_slot(holding_item)
		holding_item = null


func left_click_different_item(event: InputEvent, slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(holding_item, slot)
		var temp_item = slot.item
		slot.pick_from_slot()
		temp_item.global_position = event.global_position
		slot.put_into_slot(holding_item)
		holding_item = temp_item


func left_click_same_item(slot: SlotClass):
	if able_to_put_into_slot(slot):
		var stack_size = int(Jsondata.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_amount
		if able_to_add >= holding_item.item_amount:
			PlayerInventory.add_item_amount(slot.holding_item, slot.item_amount)
			slot.item.add_item_amount(holding_item.item_amount)
			holding_item.queue_free()
			holding_item = null
		else:
			PlayerInventory.add_item_amount(slot, able_to_add)
			slot.item.add_item_amount(able_to_add)
			holding_item.decrease_item_amount(able_to_add)


func left_click_not_holding(slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot)
		holding_item = slot.item
		slot.pick_from_slot()
		holding_item.global_position = get_global_mouse_position()
