extends Camera2D

# Shake parameters
var shake_intensity: float = 0.0
var shake_duration: float = 0.0
var shake_timer: float = 0.0

func _ready() -> void:
	PlayerResources.camera = self

func _process(delta: float) -> void:
	if shake_timer > 0:
		# Reduce the timer
		shake_timer -= delta

		# Calculate the shake offset
		var shake_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)

		# Apply the offset to the camera's position
		offset = shake_offset

		# Reduce the intensity over time
		shake_intensity = lerp(shake_intensity, 0.0, 1.0 - (shake_timer / shake_duration))
	else:
		# Reset the offset when the shake is over
		offset = Vector2.ZERO

# Function to start the screen shake
func start_shake(intensity: float, duration: float) -> void:
	shake_intensity = intensity
	shake_duration = duration
	shake_timer = duration
