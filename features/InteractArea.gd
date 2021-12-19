extends Area2D

onready var parent_node = get_node("..")

func _on_InteractArea_body_entered(body):
	if not body is Player:
		return
	var player = body
	parent_node.can_interact_with(player)
	player.set_interactable(parent_node)

func _on_InteractArea_body_exited(body):
	if not body is Player:
		return
	var player = body
	parent_node.stop_interaction_with(player)
	player.set_interactable(null)
