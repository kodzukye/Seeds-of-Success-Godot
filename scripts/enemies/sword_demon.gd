extends CharacterBody2D
const SPEED = 60
var player_chase = false
var player = null
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _physics_process(delta):
	if player_chase:
		if position.distance_to(player.position) > 1:
			position += (player.position-position)/SPEED
			$AnimatedSprite.play("attack")
			if (player.position.x-position.x) < 5:
				$AnimatedSprite.flip_h = true
			else: 
				$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.play("idle")
	move_and_slide()

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
