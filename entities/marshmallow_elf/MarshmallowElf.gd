extends KinematicBody2D

func _ready():
	$AnimationPlayer.play("WalkLeft")

func can_interact_with(_player):
	$Icons.visible = true

func interact_with(_player):
	if $DialogueBox.is_shown():
		$DialogueBox.hide()
	else:
		$DialogueBox.display(name, Global.get_message(name))
		$DialogueBox.show()
		$AudioStreamPlayer.play()

func stop_interaction_with(_player):
	$Icons.visible = false
	$DialogueBox.hide()
