extends Area2D

var racketClass = preload("res://Scripts/Racket.gd")
var racket

func _ready():
	set_process(true)
	racket = racketClass.new(self)
	pass



func _on_PongPlayer_area_entered(area):
	racket.hit(area)
	pass # Replace with function body.
