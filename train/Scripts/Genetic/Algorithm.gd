extends Node

class Individual:
	var generation
	var chromosome
	var pointsDid
	var lifeTime
	var rating
	
	func _init(numberOfChromosomes = null, chromosome = [], generation = 1):
		self.generation = generation
		self.chromosome = chromosome
		self.pointsDid = 0
		self.lifeTime = 0
		
		if(numberOfChromosomes):
			generateFirstGeneration(numberOfChromosomes)

	func setLifeTime(newLifeTime):
		self.lifeTime = newLifeTime

	func generateFirstGeneration(numberOfChromosomes):
		for i in range(numberOfChromosomes):
			randomize()
			self.chromosome.append(rand_range(-1, 1))

	func setChromosome(newChromosome):
		self.chromosome = newChromosome

	func crossover(anotherIndividual):
		randomize()
		var crossoverPoint = round(randf() * self.chromosome.size())
	
		var chromoOneOne = []
		var chromoOneTwo = []
		var chromoTwoOne = []
		var chromoTwoTwo = []
	
		for i in range(0, crossoverPoint, 1):
			chromoOneOne.append(anotherIndividual.chromosome[i])
	
		for i in range(crossoverPoint, self.chromosome.size(), 1):
			chromoOneTwo.append(self.chromosome[i])
	
		for i in range(0, crossoverPoint, 1):
			chromoTwoOne.append(self.chromosome[i])

		for i in range(crossoverPoint, anotherIndividual.chromosome.size(), 1):
			chromoTwoTwo.append(anotherIndividual.chromosome[i])

		var childOneChromosome = chromoOneOne + chromoOneTwo
		var childTwoChromosome = chromoTwoOne + chromoTwoTwo

		var children = [Individual.new(null, childOneChromosome, self.generation + 1), Individual.new(null, childTwoChromosome, self.generation + 1)]

		return children
	
	func fitness():
		self.rating = self.lifeTime

	func mutate(mutateProbability):
		for i in range(len(self.chromosome)):
			randomize()
			if randf() < mutateProbability:
				randomize()
				self.chromosome[i] = rand_range(-1, 1)

class GeneticAlgorithm:
	var populationLength
	var mutationRate
	var population
	var generation
	var bestSolution
	
	func _init(populationLen, mutationR):
		self.populationLength = populationLen
		self.mutationRate = mutationR

		self.population = []
		self.generation = 1
		self.bestSolution = 0

	func initializePopulation(initializeWeights):
		for i in range(self.populationLength):
			var individual
			
			if(initializeWeights): 
				individual = Individual.new(38, initializeWeights, 1)
			else:
				individual = Individual.new(38, [], 1)

			self.population.append(individual)

	func sortPopulation():
		self.population.sort_custom(self, "customComparison")
		self.bestSolution = self.population[0]
	
	func customComparison(a, b):
		return a.rating > b.rating

	func getRatingSum():
		var sum = 0

		for individual in self.population:
			sum += individual.rating
	
		return sum

	func showBestSolutionNumber():
		return self.bestSolution.rating

	func selectFather():
		var father = -1
		randomize()
		var randomValue = randf() * self.getRatingSum()

		var sum = 0
		var i = 0

		while i < len(self.population) and sum < randomValue:
			sum += self.population[i].rating
		
		father += 1
		i += 1

		return father

	func createNewPopulation():
		var newPopulation = []
		
		if generation > 1:
			self.sortPopulation()
			var npopulation = []
			
			for i in range(self.populationLength):
				npopulation.append(self.population[i])
			
			self.population = npopulation

		self.bestSolution = self.population[0]
		
		for i in range(0, self.populationLength, 2):
			var fatherOne = self.selectFather()
			var fatherTwo = self.selectFather()

			var children = self.population[fatherOne].crossover(self.population[fatherTwo])

			children[0].mutate(self.mutationRate)
			children[1].mutate(self.mutationRate)

			newPopulation.append(children[0])
			newPopulation.append(children[1])
	
		self.population = newPopulation + self.population
