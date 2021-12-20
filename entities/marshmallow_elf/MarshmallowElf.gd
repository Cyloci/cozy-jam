extends KinematicBody2D

func _ready():
	$AnimationPlayer.play("WalkLeft")

func can_interact_with(_player):
	$Icons.visible = true

func interact_with(_player):
	$DialogueBox.show()

func stop_interaction_with(_player):
	$Icons.visible = false
	$DialogueBox.hide()
