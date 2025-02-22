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

func lookup_realval(val: int) -> int:
	if val <= 6:
		return val
	if val <= 12:
		return val-6
	if val <= 18:
		return val-12
	if val <= 24:
		return val-24
	return 0


func calculate(cur_num: int, val: int):
	if val <= 6:
		return cur_num+val
	if val <= 12:
		return cur_num*(val-6)
