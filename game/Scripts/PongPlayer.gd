extends Area2D

var racketClass = preload("res://Scripts/Racket.gd")
var racket

func _ready():
	set_process(true)
	racket = racketClass.new(self)
	pass

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		racket.walk(-1, delta)

	if Input.is_action_pressed("ui_down"):
		racket.walk(1, delta)	
	pass


func _on_PongPlayer_area_entered(area):
	racket.hit(area)
	pass # Replace with function body.
