# State.gd (classe de base)
class_name State
extends Node

var state_machine: StateMachine
var player: CharacterBody2D

# Méthodes à override dans les états spécifiques
func enter() -> void:
	pass

func exit() -> void:
	pass

func update(delta: float) -> String:
	return ""

func handle_input(event: InputEvent) -> String:
	return ""
