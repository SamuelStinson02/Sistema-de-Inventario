extends Position2D

export(PackedScene) var item_drop

func enemy_drop(position):
	var drop = item_drop.instance()
	get_tree().get_nodes_in_group("world")[0].add_child(drop)
	drop.global_position = position
