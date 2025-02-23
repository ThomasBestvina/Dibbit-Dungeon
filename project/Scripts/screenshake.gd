extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0

@onready var tween = get_tree().create_tween()

@onready var camera = get_parent()

func start(duration = 0.2, frequency = 15, amplitude = 16):
	self.amplitude = amplitude
	
	$Duration.wait_time = duration
	$Frequency.wait_time = 1/float(frequency)
	if(PlayerResources.screenshake):
		$Duration.start()
		$Frequency.start()
		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = randf_range(-amplitude,amplitude)
	rand.y = randf_range(-amplitude,amplitude)
	
	tween.tween_property(camera,"offset",camera.offset,rand, $Frequency.wait_time, TRANS, EASE)
	tween.start()

func _reset():
	tween.interpolate_property(camera,"offset",camera.offset,Vector2(), $Frequency.wait_time, TRANS, EASE)
	tween.start()


func _on_frequency_timeout() -> void:
	_new_shake()


func _on_duration_timeout() -> void:
	_reset()
	$Frequency.stop()
