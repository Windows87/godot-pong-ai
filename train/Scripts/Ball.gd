extends Area2D

var initialVel = 300
var vel = initialVel
var horizontal = 1
var vertical = 0
var k

func _ready():
	set_process(true)
	pass

func run(delta):
	position += Vector2(horizontal, vertical) * vel * delta
	pass

func restart(newHorizontal):
	horizontal = newHorizontal
	vertical = 0
	position = Vector2(512, 280)

func bounce(d):
	vertical += d * -0.01

func _process(delta):
	#if position.x >= 926:
	#if position.x <= 82:
	#	vel = 0
	
	if position.y <= 30:
		bounce(-30)

	if position.y >= 570:
		bounce(30)
		
	if position.x <= 0:
		get_node("..").onBotHit(k)
		restart(1)

	if position.x >= 1024:
		get_node("..").onPlayerHit(k)
		restart(-1)
		
	
	run(delta)
	pass
