extends StaticBody2D

func can_interact_with(_player):
	$Icons.visible = true

func interact_with(_player):
	print ("Hey, I'm a tree")

func stop_interaction_with(_player):
	$Icons.visible = false
