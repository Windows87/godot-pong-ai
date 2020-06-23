extends Area2D

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PongPlayer_area_entered(area):
	area.horizontal = -(area.horizontal)
	pass # Replace with function body.
