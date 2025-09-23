# StateMachine.gd
class_name StateMachine
extends Node

@onready var player: CharacterBody2D = get_parent()
var states: Dictionary = {}
var current_state: State
var previous_state: State

func _ready() -> void:
	# Récupérer tous les états enfants
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self
			child.player = player
	
	# Démarrer avec l'état idle
	if states.has("idle"):
		current_state = states["idle"]
		current_state.enter()

func _physics_process(delta: float) -> void:
	if current_state:
		var new_state = current_state.update(delta)
		if new_state:
			change_state(new_state)

func change_state(new_state_name: String) -> void:
	var new_state = states.get(new_state_name.to_lower())
	if new_state and new_state != current_state:
		previous_state = current_state
		if current_state:
			current_state.exit()
		current_state = new_state
		current_state.enter()

func get_current_state_name() -> String:
	return current_state.name if current_state else ""
