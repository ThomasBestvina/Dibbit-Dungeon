## Contains dice game utilities

extends Node

func lookup_operation(val: int) -> String:
	if val <= 6:
		return "+"
	if val <= 12:
		return "*"
	if val <= 18:
		return "/"
	if val <= 24:
		return "-"
	return ""

func lookup_realval(val: int) -> float:
	if val == 7:
		return 1.5
	if val == 13:
		return 1.5
	if val <= 6:
		return val
	if val <= 12:
		return val-6
	if val <= 18:
		return val-12
	if val <= 24:
		return val-18
	return 0


func calculate(cur_num: int, val: int):
	if val == 7:
		return cur_num*(1.5)
	if val == 13:
		return cur_num/(1.5)
	if val <= 6:
		return cur_num+val
	if val <= 12:
		return cur_num*(val-6)
	if val <= 18:
		return cur_num/(val-12)
	if val <= 24:
		return cur_num-(val-18)


## Each die needs to have a couple of things:
## At least 1 Constant
## At least 1 Curse
## 6 Sides
## A color
## For other 4 sides, a random number should be picked, 1-4, deciding constant-subtraction, then weighting should occur in the direction of lower values.
func generate_die() -> Array:
	# haha bad solution!
	var weighted_array = [1, 1, 1, 2, 2, 2, 0, 3,3, 4,4, 5, 6]
	
	## constant and curse
	var values = [randi_range(1,6), weighted_array[randi() % weighted_array.size()]*randi_range(3,4)]
	
	for i in range(4):
		values.append(weighted_array[randi() % weighted_array.size()]*randi_range(1,4))
	values.shuffle()
	return [values, generate_random_color()]

func generate_random_color():
	var color = Color(randi_range(0, 255) / 255.0, randi_range(0, 255) / 255.0, randi_range(0, 255) / 255.0)

	# Ensure the color is not close to white (e.g. not all values close to 1)
	while color.r > 0.8 and color.g > 0.8 and color.b > 0.8:
		color = Color(randi_range(0, 255) / 255.0, randi_range(0, 255) / 255.0, randi_range(0, 255) / 255.0)

	return color

# what is an evil color? ive been awake for far to long.
func make_color_evil(color: Color, evil_factor: float = 0.5) -> Color:
	var hsb =  rgb_to_hsv(color.r,color.g,color.b)
	hsb.z = max(0.0, hsb.z - evil_factor * 0.4)  # Lower the brightness
	hsb.x = lerp(hsb.x, 0.0, evil_factor * 0.5)  # Shift the hue towards red
	hsb.y = lerp(hsb.y, 1.0, evil_factor * 0.3)  # Increase the saturation
	return Color.from_hsv(hsb.x,hsb.y,hsb.z)

# Couldnt find rgb_to_hsv method. Fuck it, Im making my own
# Function to convert RGB to HSV
func rgb_to_hsv(r: float, g: float, b: float) -> Vector3:
	var max_val = max(r, g, b)
	var min_val = min(r, g, b)
	var delta = max_val - min_val

	var h = 0.0
	var s = 0.0
	var v = max_val

	if delta > 0.0:
		# Saturation
		s = delta / max_val

		# Hue
		if max_val == r:
			h = (g - b) / delta
		elif max_val == g:
			h = 2.0 + (b - r) / delta
		else:
			h = 4.0 + (r - g) / delta

		h = fmod(h / 6.0, 1.0)  # Normalize to [0, 1]
		if h < 0.0:
			h += 1.0

	return Vector3(h, s, v)
