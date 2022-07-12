extends Position2D

export(PackedScene) var item_drop

func enemy_drop(position):
	var drop = item_drop.instance()
	get_tree().get_nodes_in_group("world")[0].add_child(drop)
	drop.global_position = Vector2(rand_range(0.1, 400), rand_range(0.1, 200))


func _on_Timer_timeout():
	enemy_drop(position)
