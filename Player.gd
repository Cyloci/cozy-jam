extends KinematicBody2D

export (int) var speed = 100

var velocity = Vector2()
var direction = "Front"

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
		direction = "Right"
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		direction = "Left"
	if Input.is_action_pressed("down"):
		velocity.y += 1
		direction = "Front"
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		direction = "Back"
	velocity = velocity.normalized() * speed
	$AnimationPlayer.play("Walk" + direction)

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
