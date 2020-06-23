extends Area2D

var racketClass = preload("res://Scripts/Racket.gd")

var NN = preload("res://Scripts/Neural Network/Brain.gd")
var Matrix = preload("res://Scripts/Neural Network/Matrix.gd")

var weightsIH = [[0, 0, 0], [0, 0, 0]]
var weightsHO = [[0, 0], [0, 0]]

var biasH = [[0], [0]]
var biasO = [[0], [0]]

var nn
var racket
var k

var points = 0
var lose = 0
var lessThan05 = 0

func init(newWeightsIH, newWeightsHO, newBiasH, newBiasO):
	weightsIH = newWeightsIH
	weightsHO = newWeightsHO
	
	biasH = newBiasH
	biasO = newBiasO
	
	racket = racketClass.new(self)
	nn = NN.new({
		"input_nodes": 3,
		"hidden_nodes": 6,
		"output_nodes": 2,
		
		"weights_ih": Matrix.new(weightsIH),
		"weights_ho": Matrix.new(weightsHO),
		
		"bias_h": Matrix.new(biasH),
		"bias_o": Matrix.new(biasO)
	})
	
	set_process(true)
	pass

func _process(delta):
	var ball
	
	#print(get_node("..").balls)
	
	for i in get_node("..").balls:
		if(i.k == k):
			ball = i
	
	if ball:
		var distanceOfBall = position.x - ball.position.x - 64 - 12 +  93 - 30
		var ballY = ball.position.y
		var ballVelocity = ball.vel
	
		var normalizedValues = Vector3(position.y, distanceOfBall, ballY).normalized()
		
		#print([normalizedValues.x, normalizedValues.y, normalizedValues.z])
		var nnPredict = nn.predict([normalizedValues.x, normalizedValues.y, normalizedValues.z])

		#print(nnPredict)
		if(nnPredict[0] >= 1):
			racket.walk(1, delta)
			
		if(nnPredict[1] >= 1):	
			racket.walk(-1, delta)
	
	pass

func _on_PongBot_area_entered(area):
	if area.k == k:
		racket.hit(area)
	pass # Replace with function body.
