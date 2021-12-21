extends CanvasLayer

func _process(_delta):
	$NinePatchRect/NumCrackers.text = str(Global.get_num_items(Global.Item.CRACKER))
	$NinePatchRect/NumChocoBerries.text = str(Global.get_num_items(Global.Item.CHOCOBERRY))
	$NinePatchRect/NumSugar.text = str(Global.get_num_items(Global.Item.SUGAR))
	$NinePatchRect/NumMarshmallows.text = str(Global.get_num_items(Global.Item.MARSHMALLOW))
