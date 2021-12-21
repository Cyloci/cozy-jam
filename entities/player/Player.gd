extends KinematicBody2D

class_name Player

export (int) var speed = 75

var velocity = Vector2()
var direction = "Front"
var footstep_cooldown_active = false
var interactable = null
var playing_animation = false

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
	if not playing_animation:
		$AnimationPlayer.play("Walk" + direction)

	if Input.is_action_just_pressed("interact") and interactable != null:
		interactable.interact_with(self)

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
	if Global.state.give_sugar_event:
		Global.state.give_sugar_event = false
		playing_animation = true
		$AnimationPlayer.play("GiveItem")
	if Global.state.give_items_event:
		Global.state.give_items_event = false
		playing_animation = true
		$ChocoberryParticle.amount = 10
		$MarshmallowParticle.amount = 10
		$CrackerParticle.amount = 10
		$ChocoberryParticle.emitting = true
		$MarshmallowParticle.emitting = true
		$CrackerParticle.emitting = true
		Global.remove_item(Global.Item.CHOCOBERRY, 10)
		Global.remove_item(Global.Item.CRACKER, 10)
		Global.remove_item(Global.Item.MARSHMALLOW, 10)
		$AudioStreamPlayer.play()
		yield(get_tree().create_timer(1), "timeout")
		$ChocoberryParticle.emitting = false
		$MarshmallowParticle.emitting = false
		$CrackerParticle.emitting = false
		playing_animation = false

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

func emit_sugar():
	$SugarParticle.emitting = true
	yield(get_tree().create_timer(0.2), "timeout")
	$SugarParticle.emitting = false

func emit_marshmallow():
	$MarshmallowParticle.emitting = true
	yield(get_tree().create_timer(0.2), "timeout")
	$MarshmallowParticle.emitting = false

func give_sugar():
	Global.remove_item(Global.Item.SUGAR, 2)

func recieve_marshmallow():
	Global.add_item(Global.Item.MARSHMALLOW)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "GiveItem" or anim_name == "GiveItems":
		playing_animation = false
