extends TileMapLayer
@onready var extendbutton = get_node("../游戏UI前置部分/游戏主界面下方功能按钮/扩建岛屿")

const 实体 = preload("uid://b1vfj2utri10o")



# BuildMode
#可用建造坐标
var avlBuildPosList
#1 建造房子按钮
@onready var Buliemode1: Button = $"../建造模式UI/建筑列表ui/ScrollContainer/HBoxContainer/房屋建筑按钮"
#房子场景
const buildHouse = preload("uid://ui115dhtn5wg")

#0不是建造模式，1是房子，2是...
var buildMode = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	extendbutton.extendIsland.connect(get_parent().IslandExtend)
	Buliemode1.BuildingMode1.connect(build1)
	Buliemode1.deBuildingMode1.connect(debuild1)
	avlBuildPosList = get_used_cells()
	
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# 先确定地图范围、然后排除有岛的地方，然后准备刷新物资


# 传递生存天数和道具
func creatRes(xf,yf,days,daoju):
	var res = 实体.instantiate()
	res = res.initRes(days,daoju)
	var avlList = getavlPos(xf,yf)
	if avlList.is_empty():
		#print(get_cell_source_id(Vector2i(0,3)))
		return
	var randPos = avlList[randi()%len(avlList)]
	# 转换世界坐标加一个偏移 要不然飞了
	var worldPos = map_to_local(randPos)# - Vector2(50,50)
	res.position = worldPos
	get_parent().add_child(res)
	
	# 链接到主场景的resPicked中
	res.picked.connect(get_parent().resPicked)
	


#获取范围内所有可用坐标
#传递一个范围，横轴范围，纵轴范围 2,6
# get_used_rect() 获取地块 
func getavlPos(xf,yf):
	var avlList = []
	var x = get_used_rect().position.x
	var y = get_used_rect().position.y
	var sizex = get_used_rect().size.x
	var sizey = get_used_rect().size.y
	for i in range(x-xf,x+sizex-1+xf+1):
		for j in range(y-yf,y+sizey-1+yf+1):
			if  get_cell_source_id(Vector2i(i,j))==-1:
				avlList.append(Vector2i(i,j))
	#print(avlList)
	return avlList
	

#在点击位置添加一个房屋
func build1():
	buildMode = 1
	print("收到信号")
#非建造模式
func debuild1():
	buildMode = 0
	print("收到信号")


# 所有建造写到下面的If函数里面
func _unhandled_input(event: InputEvent) -> void:
	if buildMode==0:
		pass
	else:
		#获取鼠标
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#获取鼠标坐标、转换坐标、修复偏移、根据mode号：检测资源数、实例化建筑、扣除资源、添加到树上
			var localmousePos = get_local_mouse_position()
			var mapPos = local_to_map(localmousePos)
			#print(mapPos)
			#print(avlBuildPosList)
			#建造房子
			if buildMode==1:
				#实例化
				var build1 = buildHouse.instantiate()
				#检查坐标可用
				if mapPos in avlBuildPosList:
					#检查资源成功就扣
					if get_parent().checkBuildRes(build1):
						var worldPos = map_to_local(mapPos)
						build1.position = worldPos
						get_parent().add_child(build1)
						avlBuildPosList.erase(mapPos)
						pass#安排
					else:
						print("资源不足")
				else:
					print("坐标不可用")
				
				
			pass
