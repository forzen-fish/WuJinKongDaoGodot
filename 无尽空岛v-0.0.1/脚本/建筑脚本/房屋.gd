extends Node2D

#拆除提示
@onready var dismantle_ui: Control = $拆除提示ui

#房屋建造 1
@onready var Buliemode1: Button = get_node("../建造模式UI/建筑列表ui/ScrollContainer/HBoxContainer/房屋建筑按钮")

@onready var sprite_2d: Sprite2D = $Sprite2D房屋

@onready var hpbar: ProgressBar = $HP

#拆除
@onready var dismantleButtom: Button = $"拆除提示ui/拆除按钮"

@onready var ResWarehouse: Node2D = $资源仓库

#地图
var tile_map_layer

#房屋血量
var hp = 100

#建筑所需资源
var res = [["木材",10],["石材",10],["食物",10]]

#是否检测输入
var tag = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_map_layer = get_node("/root/Main/TileMapLayer")
	dismantle_ui.visible = false
	hpbar.max_value = hp
	hpbar.value = hpbar.max_value
	dismantleButtom.dismantleSignal.connect(dismantleBuilding)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# hp为0 销毁
	if hp <=0:
		destroyBuilding()
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

#用户点击了拆除按钮，根据Hp拆除建筑，然后把坐标还给map
func dismantleBuilding():
	#找到当前实例对象所在的格子
	var localmousePos = global_position#需要改成现在的对象
	var mapPos = tile_map_layer.local_to_map(localmousePos)
	#将这个坐标加入到列表
	tile_map_layer.avlBuildPosList.append(mapPos)
	#TODO 根据hp退还资源
	
	#销毁
	destroyBuilding()
	print("房屋场景收到拆除信号")


func destroyBuilding():
	queue_free()
