extends StaticBody2D


export var on = true

func _ready():
	$AudioStreamPlayer2D.play()
	if on:
		$AnimationPlayer.play("On")
	else:
		$AnimationPlayer.play("Off")
