extends KinematicBody2D

class_name Player

export (int) var speed = 75

var velocity = Vector2()
var direction = "Front"
var footstep_cooldown_active = false
var interactable = null

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

	if Input.is_action_just_pressed("interact") and interactable != null:
		interactable.interact(self)

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)

func play_footstep():
	if velocity == Vector2.ZERO or footstep_cooldown_active:
		return
	Global.get_random_child($Footsteps).play()
	$FootstepCooldown.start()
	footstep_cooldown_active = true

func _on_FootstepCooldown_timeout():
	footstep_cooldown_active = false

func set_interactable(entity):
	interactable = entity
