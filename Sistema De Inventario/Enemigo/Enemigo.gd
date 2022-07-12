extends KinematicBody2D

var healt = 100
var damage = 100

onready var drop_point = get_parent().get_node("Drop")

func take_damage(damage):
	healt -= damage
	if healt <= 0:
		healt = 0
		morir()


func morir():
	drop_point.enemy_drop(self.position)
	queue_free()


func _on_HurtArea_body_entered(body):
	if body.is_in_group("player"):
		take_damage(damage)
