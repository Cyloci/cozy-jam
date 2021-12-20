extends CanvasLayer

func _process(_delta):
	$NinePatchRect/NumCrackers.text = str(Global.items[Global.Item.CRACKER])
	$NinePatchRect/NumChocoBerries.text = str(Global.items[Global.Item.CHOCOBERRY])
	$NinePatchRect/NumSugar.text = str(Global.items[Global.Item.SUGAR])
	$NinePatchRect/NumMarshmallows.text = str(Global.items[Global.Item.MARSHMALLOW])
