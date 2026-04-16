class_name CountPWright
extends CharacterBody3D

@export var left_hand: CountHand
@export var right_hand: CountHand

func show_hands():
	left_hand.show()
	right_hand.show()
	
func hide_hands():
	left_hand.hide()
	right_hand.hide()
