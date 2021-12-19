extends Area2D

func _on_InteractArea_body_entered(body):
	if not body is Player:
		return
	var player = body
	$Icons.visible = true
	player.set_interactable(get_node(".."))

func _on_InteractArea_body_exited(body):
	if not body is Player:
		return
	var player = body
	$Icons.visible = false
	player.set_interactable(null)
