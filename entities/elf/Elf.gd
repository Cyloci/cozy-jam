extends KinematicBody2D

enum {
	IDLE,
	WANDER,
	TALKING,
}

export var MAX_SPEED = 10

const WANDER_RANGE = 15
const WANDER_TARGET_RANGE = 4

onready var start_position = global_position
onready var target_position = global_position
onready var state = IDLE
onready var wander_timer = $WanderTimer
onready var animation = $AnimationPlayer
onready var dialogue_box = get_node_or_null("DialogueBox")

var velocity = Vector2.ZERO
var is_interactable = false

var colors = [
	Color("ff1010"),
	Color("ff8010"),
	Color("fff340"),
	Color("8eff40"),
	Color("00fdd9"),
	Color("2391f1"),
	Color("6014e9"),
	Color("ff00d7"),
]

func _ready():
	animation.play("WalkRight")
	$Clothes.modulate = colors[randi() % colors.size()]

func _physics_process(_delta):
	match state:
		IDLE:
			velocity = Vector2.ZERO
			if wander_timer.time_left == 0:
				wander_timer.wait_time = randf() * 3 + 2
				wander_timer.start()
		WANDER:
			var direction = global_position.direction_to(target_position)
			velocity = move_and_slide(direction * MAX_SPEED)
			if global_position.distance_to(target_position) <= WANDER_TARGET_RANGE:
				state = IDLE
		TALKING:
			pass
	if velocity.x > 0:
		animation.play("WalkRight")
	elif velocity.x < 0:
		animation.play("WalkLeft")

func _on_WanderTimer_timeout():
	if state == TALKING:
		return
	var random_delta_vector = Vector2(
		rand_range(-WANDER_RANGE, WANDER_RANGE),
		rand_range(-WANDER_RANGE, WANDER_RANGE)
	)
	target_position = start_position + random_delta_vector
	state = WANDER

func can_interact_with(_player):
	if dialogue_box:
		$Icons.visible = true

func interact_with(_player):
	if dialogue_box:
		dialogue_box.show()
	state = TALKING

func stop_interaction_with(_player):
	$Icons.visible = false
	if dialogue_box:
		dialogue_box.hide()
	state = IDLE
