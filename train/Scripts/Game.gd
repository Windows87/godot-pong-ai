extends Node

var GeneticAlgorithm = preload("res://Scripts/Genetic/Algorithm.gd")
var PongBot = preload("res://Scenes/PongBot.tscn")
var Ball = preload("res://Scenes/Ball.tscn")

onready var chart = get_node('Chart')

var genetic

var playerScore = 0
var botScore = 0
var time = 0
var numberPopulation = 30
var initializeWithThatWeights = null

var instances = []
var balls = []

func _ready():
	set_process(true)

	chart.initialize(chart.LABELS_TO_SHOW.NO_LABEL,
	{
		best = Color(1.0, 0.18, 0.18),
		average = Color(0.58, 0.92, 0.07)
	})

	genetic = GeneticAlgorithm.GeneticAlgorithm.new(numberPopulation, 0.1)
	genetic.initializePopulation(initializeWithThatWeights)
	
	setPopulation()
	
	pass

func deletePopulation():
	for instance in instances:
		genetic.population[instance.k].setPointsAndLose(instance.points, instance.lose)
		genetic.population[instance.k].fitness()
		instance.queue_free()
		
	for instance in balls:
		instance.queue_free()

	instances = []
	balls = []

func setPopulation():
	var k = 0
	randomize()
	var kColor = [randf(), randf(), randf()]
	
	for i in range(genetic.population.size()):
		var pongbot = PongBot.instance()
		
		pongbot.k = k
		
		pongbot.modulate = Color(kColor[0], kColor[1], kColor[2])
		
		var values = genetic.population[i].chromosome
		
		var weightsIH = [[values[0], values[1], values[2]], [values[3], values[4], values[5]], [values[6], values[7], values[8]], [values[9], values[10], values[11]], [values[12], values[13], values[14]], [values[15], values[16], values[17]]]
		var weightsHO = [[values[18], values[19], values[20], values[21], values[22], values[23]], [values[24], values[25], values[26], values[27], values[28], values[29]]]
		
		var biasH = [[values[30]], [values[31]], [values[32]], [values[33]], [values[34]], [values[35]]]
		var biasO = [[values[36]], [values[37]]]
		
		pongbot.init(weightsIH, weightsHO, biasH, biasO)
		
		pongbot.position = Vector2(940, 288)
		var ball = Ball.instance()
			
		ball.restart(1)
		ball.k = k
		ball.modulate = Color(kColor[0], kColor[1], kColor[2])
		add_child(ball)
			
		balls.append(ball)
			
		randomize()
		kColor = [randf(), randf(), randf()]
		k += 1
		
		add_child(pongbot)
		instances.append(pongbot)

func onPlayerHit(k):
	playerScore += 1
	
	for i in range(instances.size()):
		var instance = instances[i]
		var ball = balls[i]
		
		if instance.k == k:
			genetic.population[instance.k].setLifeTime(time)
			genetic.population[instance.k].fitness()
			instance.queue_free()
			ball.queue_free()
			instances.erase(instance)
			balls.erase(ball)
			break

	if not instances.size():
		restart()
		
	get_node("ScorePlayer/Label").set_text(playerScore as String)

func onBotHit(k):
	botScore += 1
	
	get_node("ScoreBot/Label").set_text(botScore as String)

func restart():
	time = 0
	playerScore = 0
	botScore = 0
	
	genetic.generation += 1
	
	get_node("ScorePlayer/Label").set_text("0")
	get_node("ScoreBot/Label").set_text("0")
	
	deletePopulation()
	genetic.sortPopulation()
	
	get_node("GeneticInfo/BestRating").set_text("Best Rating: " + genetic.bestSolution.rating as String)
	
	var average = 0
	
	for i in genetic.population:
		print(i.rating)
		average += i.rating
	
	average /= genetic.population.size()
	
	chart.create_new_point({
		label = genetic.generation as String,
		values = {
			best = genetic.bestSolution.rating,
			average = average
		}
	})
	
	genetic.createNewPopulation()
	setPopulation()
	
	#print("NEW POPULATION")
	#for item in genetic.population:
		#print(item.chromosome)	

	get_node("GeneticInfo/Generation").set_text("Generation: " + genetic.generation as String)
	
	print(genetic.bestSolution.chromosome)

func _process(delta):
	time += delta
	
	get_node("Timer/Label").set_text(round(time) as String)
	
	pass
