class_name NeuralNetwork

var Matrix = preload("./Matrix.gd")
var MatrixOperator = preload("./MatrixOperator.gd")

var input_nodes := 0
var hidden_nodes := 0
var output_nodes := 0
 
var weights_ih: Matrix # input -> hidden
var weights_ho: Matrix # hidden -> output
var bias_h: Matrix
var bias_o: Matrix

var learning_rate = 1
var mutation_rate = 0.1

var reLu_ref: FuncRef
var dreLu_ref: FuncRef
var mutation_func_ref: FuncRef

# CONSTRUCTORS
func _init(a, b = 1, c = 1):
	randomize()
	reLu_ref = funcref(self, 'reLU')
	dreLu_ref = funcref(self, "dreLU")
	mutation_func_ref = funcref(self, "mutation_func")
	
	if a is int:
		construct_from_sizes(a, b, c)
	else:
		construct_from_nn(a)

func construct_from_sizes(a, b, c):
	input_nodes = a
	hidden_nodes = b
	output_nodes = c
	
	weights_ih = Matrix.new(hidden_nodes, input_nodes)
	weights_ho = Matrix.new(output_nodes, hidden_nodes)
	weights_ih.randomize()
	weights_ho.randomize()
	
	bias_h = Matrix.new(hidden_nodes, 1)
	bias_o = Matrix.new(output_nodes, 1)
	bias_h.randomize()
	bias_o.randomize()

func construct_from_nn(a):
	input_nodes = a.input_nodes
	hidden_nodes = a.hidden_nodes
	output_nodes = a.output_nodes
	
	weights_ih = a.weights_ih.duplicate()
	weights_ho = a.weights_ho.duplicate()
	
	bias_h = a.bias_h.duplicate()
	bias_o = a.bias_o.duplicate()

func predict(input_array: Array) -> Array:
	var inputs = Matrix.new(input_array)
	
	var hidden = MatrixOperator.multiply(weights_ih, inputs)
	hidden.add(bias_h)
	hidden.map(reLu_ref)
	
	var outputs = MatrixOperator.multiply(weights_ho, hidden)
	outputs.add(bias_o)
	outputs.map(reLu_ref)
	
	return outputs.to_array()

func train(input_array, target_array):
	var inputs = Matrix.new(input_array)
	
	var hidden = MatrixOperator.multiply(weights_ih, inputs)
	hidden.add(bias_h)
	hidden.map(reLu_ref)
	
	var outputs = MatrixOperator.multiply(weights_ho, hidden)
	outputs.add(bias_o)
	outputs.map(reLu_ref)
	
	var targets = Matrix.new(target_array)
	
	var output_errors = MatrixOperator.subtract(targets, outputs)
	
	var gradients = MatrixOperator.map(outputs, dreLu_ref)
	gradients.multiply(output_errors)
	gradients.multiply(learning_rate)
	
	var hidden_T = MatrixOperator.transpose(hidden)
	var weight_ho_deltas = MatrixOperator.multiply(gradients, hidden_T)
	
	weights_ho.add(weight_ho_deltas)
	bias_o.add(gradients)
	
	var who_t = MatrixOperator.transpose(weights_ho)
	var hidden_errors = MatrixOperator.multiply(who_t, output_errors)
	
	var hidden_gradients = MatrixOperator.map(hidden, dreLu_ref)
	hidden_gradients.multiply(hidden_errors)
	hidden_gradients.multiply(learning_rate)
	
	var inputs_T = MatrixOperator.transpose(inputs)
	var weight_ih_deltas = MatrixOperator.multiply(hidden_gradients, inputs_T)
	
	weights_ih.add(weight_ih_deltas)
	bias_h.add(hidden_gradients)

func reLU(x):
	if(x < 0):
		return 0
	else:
		return x

func dreLU(y):
	if(y < 0):
		return 0
	else:
		return 1
