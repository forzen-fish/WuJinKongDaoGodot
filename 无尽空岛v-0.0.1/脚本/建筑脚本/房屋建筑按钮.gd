extends Button

@onready var BuldmodeButton: Button = $"../../../../../游戏UI前置部分/游戏主界面下方功能按钮/建造模式"


#var cursorIcon = load("res://资源/房子.png")
#按钮按下，向外发出房屋建造信号
signal BuildingMode1()

#再次按下，取消建造
signal deBuildingMode1()

#再次点击后取消
var tag = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BuldmodeButton.BuildListClosed.connect(changeTag)
	#toggle_mode = true
	#$MyLabel.add_theme_color_override("font_color", Color(1, 0.5, 0))
	#add_theme_color_override("font_pressed_color",Color(0.611, 0.543, 0.032, 1.0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if tag == 0:
			#给建造提示 "点击岛屿块，建造建筑，再次点击按钮取消建造" 给信号吧
			#地图接受信号，把场景放进去
			#main接受信号给个提示
			BuildingMode1.emit()
			
			#Input.set_custom_mouse_cursor(cursorIcon)
			tag = 1
		else:
			#Input.set_custom_mouse_cursor(null)
			#main接受信号隐藏提示
			#地图不用这个信号
			deBuildingMode1.emit()
			tag = 0
			
#当父UI关闭后，子UI关闭
func changeTag():
	deBuildingMode1.emit()
	tag = 0
	#重置一下，不然颜色便不会来
	set_pressed(false)
