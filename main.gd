extends Node

var items: Array = [
	preload("res://resources/items/weapons/iron_sword.gd")
]


# Called when the node enters the scene tree for the first time.
func _ready():
	load_items()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_items() -> void:
	for item in items:
		var inst = item.new()
		add_child(inst.model.instantiate())
