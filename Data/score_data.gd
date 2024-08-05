## The base data for score calculations
class_name ScoreData
extends Node


## Start Points for flashes
## amount of allowed flashes divided by this value
@export var flashes: int = 1000
## Points for completing  the level on the levels level_time
@export var time: int = 500
## Points added per second under the level_time
@export var time_bonus: int = 10
## Points removed per second above the level_time
@export var time_reduction: int = 10
## Points per enemy flashed
@export var enemies: int = 100
## Point bonus per multiple flashes
## (Flashed 4 enemies at once = (enemies * 4) + (enemies_bonus * 4))
@export var enemies_bonus: int = 50
