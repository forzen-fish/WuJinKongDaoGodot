extends Node2D

#拆除提示
@onready var dismantle_ui: Control = $拆除提示ui

#房屋建造 1
@onready var Buliemode1: Button = get_node("../建造模式UI/建筑列表ui/ScrollContainer/HBoxContainer/房屋建筑按钮")

@onready var sprite_2d: Sprite2D = $Sprite2D房屋

@onready var hpbar: ProgressBar = $HP


#房屋血量
var hp = 100

#建筑所需资源
var res = [["木材",10],["石材",10],["食物",10]]

#是否检测输入
var tag = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dismantle_ui.visible = false
	hpbar.max_value = hp
	hpbar.value = hpbar.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	#获取一个建造模式的信号，当建造模式开启的时候，不要做任何动作，防止建造的时候出现UI
	
	if tag == 0 and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#TODO 加一个判断，判断点击是否发生在自身坐标，否则全部监视 借用实体的 去掉信号就行了，没必要价格信号
		var globalMousePos = get_global_mouse_position()
		var sprite2DRect = sprite_2d.get_rect()
		var sprite2DGlobalPos = sprite_2d.global_position
		var  sprite_global_rect = Rect2(
		sprite2DGlobalPos - sprite2DRect.size / 2,
		sprite2DRect.size
		)
		if sprite_global_rect.has_point(globalMousePos):
			#pickup()
			dismantle_ui.visible = true
		else:
			dismantle_ui.visible = false

func change_tag():
	if tag==0:
		tag = 1
	else:
		tag = 0
