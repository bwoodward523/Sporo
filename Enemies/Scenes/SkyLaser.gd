extends Area2D

var dir: Vector2
var speed: float

func _ready():
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.pause()
	$AnimationPlayer.play("new_animation")
func _physics_process(delta):
	position += dir * speed * delta

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("repeat")
	


func _on_timer_timeout():
	$AnimationPlayer.play("laserFadeAway")


func _on_delete_warning_timeout():
	$Sprite2D.queue_free()
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.visible = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "laserFadeAway":
		queue_free()
	if anim_name == "new_animation":
		$CollisionShape2D.disabled = false
