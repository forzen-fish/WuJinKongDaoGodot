extends TileMapLayer

const 实体 = preload("uid://b1vfj2utri10o")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
	
