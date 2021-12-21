extends StaticBody2D

var depleted = false

func can_interact_with(_player):
	if Global.state.head_elf_state < 2 or depleted:
		return
	$Icons.visible = true

func interact_with(_player):
	if Global.state.head_elf_state < 2 or depleted:
		return
	$AnimationPlayer.play("Shake")

func stop_interaction_with(_player):
	$Icons.visible = false

func emit_particle():
	$Particles2D.emitting = true
	yield(get_tree().create_timer(0.2), "timeout")
	$Particles2D.emitting = false

func pickup_item():
	Global.add_item(Global.Item.CHOCOBERRY)
	depleted = true
	$Icons.visible = false
