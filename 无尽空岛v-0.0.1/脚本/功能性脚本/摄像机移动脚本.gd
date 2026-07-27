extends Camera2D

#拖拽标志
var dragFlag = false

#拖拽起始位置
var startPos = Vector2()

#摄像头起始位置
var startPosCamera2d = Vector2()

#平滑处理一下
#func _ready():
	#position_smoothing_enabled = true
	#position_smoothing_speed = 8
	
# 直接在设置里面处理平滑

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			dragFlag = true
			startPos = get_global_mouse_position()
			startPosCamera2d = global_position
			#print(global_position)
		else:
			dragFlag = false
	
	if event is InputEventMouseMotion and dragFlag:
		var move = get_global_mouse_position() - startPos
		
		#解决抖动
		global_position = (startPosCamera2d - move).round()
		#global_position = startPosCamera2d - move
		#print(global_position)
