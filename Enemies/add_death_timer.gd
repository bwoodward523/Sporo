extends Node
var timer
var deathAnimation: String
func add_death_timer(deathAnim: String):
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(on_timeout)
	timer.start(timer.wait_time)
	deathAnimation = deathAnim
@warning_ignore("unused_parameter")
func _process(delta):
	if timer != null:
		print(timer.time_left)
func on_timeout():
	var animplayer = get_parent().get_node("AnimationPlayer")
	print(animplayer.get_animation(deathAnimation))
	print("yo usp")
	animplayer.play(deathAnimation)
