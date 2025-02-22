extends Node


func calculate(cur_num: int, val: int):
	if val <= 6:
		return cur_num+val
	if val <= 12:
		return cur_num*(val-6)
