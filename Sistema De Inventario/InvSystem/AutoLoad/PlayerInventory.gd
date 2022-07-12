extends Node

const NUM_INVENTORY_SLOTS = 20

const SlotClass = preload("res://InvSystem/Inventory/Slot.gd")
const ItemClass = preload("res://InvSystem/Item/Item.gd")

var inventory = {
	0: ["Iron Sword", 1, "Equipable", "ATK: 10"], # Slot index : [iten_name, item_amount, item_type, item_description]
	1: ["Tree Branch", 30, "Misc", "Used for build"], # Slot index : [iten_name, item_amount, item_type, item_description]
	2: ["Slime Potion", 98, "Consumable", "HP: +10"], # Slot index : [iten_name, item_amount, item_type, item_description]
	3: ["Slime Potion", 45, "Consumable", "HP: +10"], # Slot index : [iten_name, item_amount, item_type, item_description]
	}

var equips = {
	0: ["Helmet", 1, "Equipable", "DEF: 5"], # Slot index : [iten_name, item_amount, item_type, item_description]
	1: ["Sword", 1, "Equipable", "ATK: 5"], # Slot index : [iten_name, item_amount, item_type, item_description]
	2: ["Chest", 1, "Equipable", "DEF: 5"], # Slot index : [iten_name, item_amount, item_type, item_description]
	3: ["Shield", 1, "Equipable", "DEF: 5"], # Slot index : [iten_name, item_amount, item_type, item_description]
	4: ["Boots", 1, "Equipable", "DEF: 5"], # Slot index : [iten_name, item_amount, item_type, item_description]
	5: ["Bow", 1, "Equipable", "ATK: 5"], # Slot index : [iten_name, item_amount, item_type, item_description]
	}

#	Funcion para añadir nuevo item al inventario
func add_item(item_name, item_amount):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(Jsondata.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_amount:
				inventory[item][1] += item_amount
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				item_amount = item_amount - able_to_add
	
#	Item doesnt exist so add it to empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_amount]
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return


func update_slot_visual(slot_index, item_name, new_amount):
	var slot = get_tree().root.get_node("/root/World/UI/Inventory/SlotsContainer/Slot_" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_amount)
	else:
		slot.initialize_item(item_name, new_amount)


#	Funcion para añadir un item a un slot vacio
func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.SlotType:
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_amount]
		_:
			equips[slot.slot_index] = [item.item_name, item.item_amount]

#	inventory[slot.slot_index] = [item.item_name, item.item_amount, item.item_type, item.item_description]


#	Funcion para remover un item de un slot
func remove_item(slot: SlotClass):
	match slot.SlotType:
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		_:
			equips.erase(slot.slot_index)
#	inventory.erase(slot.slot_index)


#	Funcion para mergear items del mismo tipo
func add_item_amount(slot: SlotClass, amount_to_add: int):
	match slot.SlotType:
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += amount_to_add
		_:
			equips[slot.slot_index][1] += amount_to_add
#	inventory[slot.slot_index][1] += amount_to_add
