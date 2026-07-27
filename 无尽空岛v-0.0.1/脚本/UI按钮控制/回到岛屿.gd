extends Button

@onready var camera_2d: Camera2D = $"../../../Camera2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#摄像机回到初始位置
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# 回到240 360
		camera_2d.position.x = 240
		camera_2d.position.y = 360
		#print("摄像机回到初始位置")
		
