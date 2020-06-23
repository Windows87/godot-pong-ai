extends Node

var vel = 250
var player

func _init(playerNode):
	player = playerNode
	
func walk(direction, delta):
	if player.position.y < 65 and direction == -1:
		return
	
	if player.position.y > 535 and direction == 1:
		return	
		
	player.position += Vector2(0, direction) * vel * delta
	pass

func hit(ball):
	ball.horizontal = -ball.horizontal
	
	var paddleCenter = player.position.y + (110/2)
	var d = paddleCenter - player.position.y
	
	ball.bounce(d)
	pass
