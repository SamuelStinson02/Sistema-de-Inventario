extends CanvasLayer

func _input(event):
	if event.is_action_pressed("inventory"):
		#Switch Awesome!
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
