extends CanvasLayer

func _ready():
	hide()

func is_shown():
	return $NinePatchRect.visible

func show():
	$NinePatchRect.visible = true
	
func hide():
	$NinePatchRect.visible = false

func display(name, text):
	$NinePatchRect/Name.text = name
	$NinePatchRect/Text.text = text
