extends Button
@onready var BildListUI: Control = $"../../../建造模式UI/建筑列表ui"

#当建造列表关闭，需要给一个信号控制，防止关闭后还能建造建筑
signal BuildListClosed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# 检查建造列表是否可以显示，如果可以，隐藏，如果不可显示，显示
		if BildListUI.visible:
			BuildListClosed.emit()
			BildListUI.visible = false
		else:
			BildListUI.visible = true
