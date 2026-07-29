extends Node2D

#昼夜进度条Timer
@onready var daynightTimer: Timer = $昼夜进度条Timer

#资源随机刷新timer
@onready var creatRestimer: Timer = $TileMapLayer/资源刷新timer

#昼夜进度条 daynight_progressbar
@onready var daynight_progressbar: Control = $"游戏UI前置部分/生存进度ui/生存进度panel/白天黑夜进度条"
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

#资源仓库 ResWarehouse
@onready var ResWarehouse: Node2D = $资源仓库

#资源不足提示
@onready var msgResUnenough: AcceptDialog = $游戏浮动提示/资源不足提示框


#昼夜交替ui更新
@onready var 太阳月亮图标: TextureRect = $"游戏UI前置部分/生存进度ui/生存进度panel/太阳月亮图标"
@onready var 白天黑夜提示标签: Label = $"游戏UI前置部分/生存进度ui/生存进度panel/白天黑夜提示标签"
@onready var 生存天数记录: Label = $"游戏UI前置部分/生存进度ui/生存进度panel/生存天数记录"
@onready var 背景图片: TextureRect = $"游戏UI部分/背景/背景图片"
const A_4天空夜间背景图 = preload("uid://cdofpvmuagemu")
const A_4蓝天白云背景素材 = preload("uid://ot8w6m7ikdud")
const 月亮图标 = preload("uid://b3pcixr3j4o21")
const 太阳图标 = preload("uid://6sbxgq5qt52r")





#--------------------------常量设置：：：：：

#昼夜进度条更新时间 越小越平滑 大了就跳了
const daynightTimerwitetime = 0.1

#刷新资源边界
const xf = 1
const yf = 3

#随机生成资源时间
#最长
const MaxResTime = 1
#最短
const MinResTime = 0.5

#每个岛屿块扩建所需资源
const extendWood = 10
const extendStock = 10
const extendFood = 10
const extendGold = 10


#-------------------------------------变量设置：：：：：
# ------------ 昼夜时间（后续随生存时间调整）-
#日间时间
var daytime = 30
#夜间时间
var nighttime = 15
#昼夜标志 true = day
var daynighttag = true
#计时
var passedtime

#----------生存天数------------
var survivaldays

#道具倍率 TODO
var daoju = 0

#资源生存随机时间
var randResTime = 1




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	daynightTimer.wait_time = daynightTimerwitetime
	daynight_progressbar.max_value = daytime
	#初始随机资源生成时间
	randResTime = randf_range(MinResTime,MaxResTime)
	creatRestimer.wait_time = randResTime
	daynightTimer.start()
	creatRestimer.start()
	passedtime = daynightTimer.time_left
	survivaldays = 0
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#每一个witetime执行一次！！！！！
#昼夜交替主要实现
func _on_daynighttimer_timeout() -> void:
	#白日
	if daynighttag:
		#TODO:更新进度条、更新UI，切换昼夜
		passedtime += daynightTimerwitetime
		daynight_progressbar.value = passedtime
		
		#测试一下刷新资源 一切正常
		#tile_map_layer.creatRes(xf,yf,survivaldays,daoju)
		if passedtime>=daytime:
			passedtime = 0
			daynighttag = false
			daynight_progressbar.max_value = nighttime
			#TODO 更新UI
			#背景图片更新
			#太阳月亮更新
			#提示标签更新
			背景图片.texture = A_4天空夜间背景图
			太阳月亮图标.texture = 月亮图标
			白天黑夜提示标签.text = "当前是黑夜，请活下来"
			
			
	#黑夜
	else:
		passedtime += daynightTimerwitetime
		daynight_progressbar.value = passedtime
		if passedtime>=nighttime:
			passedtime = 0
			daynighttag = true
			daynight_progressbar.max_value = daytime
			##TODO 更新UI
			#背景图片更新
			#太阳月亮更新
			#提示标签更新
			#生存天数更新
			背景图片.texture = A_4蓝天白云背景素材
			太阳月亮图标.texture = 太阳图标
			白天黑夜提示标签.text = "当前为白天，请努力收集资源！"
			survivaldays+=1
			生存天数记录.text = "当前已生存：%d天"%survivaldays


func _on_creatRestimer_timeout() -> void:
	if daynighttag:
		#print("a")
		tile_map_layer.creatRes(xf,yf,survivaldays,daoju)
		randResTime = randf_range(MinResTime,MaxResTime)
		creatRestimer.wait_time = randResTime
		creatRestimer.start()

#拾取物体
func resPicked(name,num):
	ResWarehouse.addRes(name,int(num))



#扩建
#扩建岛屿功能
func IslandExtend():
	#接受一个extendIsland信号，接收到后，先计算可扩建坐标 计算总资源，检查资源数量，如果足够，可以扩建
	#试一下接收信号情况ok
	#print("扩建信号收到")
	var avlExtendPosList = calcExtendIslandList()
	var IslandNumList = calcExtendRes(len(avlExtendPosList))
	
	#检查资源数量
	if ResWarehouse.woodnum>=IslandNumList[0] and ResWarehouse.stocknum>=IslandNumList[1] and ResWarehouse.foodnum>=IslandNumList[2] and ResWarehouse.goldnum>=IslandNumList[3]:
		#扩建
		pass
		ResWarehouse.woodnum -= IslandNumList[0]
		ResWarehouse.stocknum -= IslandNumList[1]
		ResWarehouse.foodnum -= IslandNumList[2]
		ResWarehouse.goldnum -= IslandNumList[3]
		ResWarehouse.updateRes()
		for i in avlExtendPosList:
			#print("-----------------")
			#print(i)
			tile_map_layer.set_cell(i,0,Vector2i(0, 0))
			#print(tile_map_layer.get_cell_source_id(i))
		tile_map_layer.avlBuildPosList = tile_map_layer.get_used_cells()
	else:
		#弹出个提示 msgResUnenough
		var template = "资源不足此次扩建需要%d木头，%d石头，%d食物，%d金币。"
		var msgString = template % [IslandNumList[0], IslandNumList[1], IslandNumList[2], IslandNumList[3]]
		#先测试
		msgResUnenough.dialog_text = msgString
		msgResUnenough.title = "扩建资源不足！"
		msgResUnenough.popup_centered()
		#print("资源不足此次扩建需要%d木头，%d石头，%d食物，%d金币。"%[IslandNumList[0],IslandNumList[1],IslandNumList[2],IslandNumList[3]])
	
	

#计算可扩建岛屿坐标
func calcExtendIslandList():
	#tile_map_layer
	var avlList = []
	var x = tile_map_layer.get_used_rect().position.x
	var y = tile_map_layer.get_used_rect().position.y
	var sizex = tile_map_layer.get_used_rect().size.x
	var sizey = tile_map_layer.get_used_rect().size.y
	for i in range(x-1,x+sizex+1):
		for j in range(y-1,y+sizey+1):
			if  tile_map_layer.get_cell_source_id(Vector2i(i,j))==-1:
				avlList.append(Vector2i(i,j))
	#print(avlList)
	return avlList
	#pass

func calcExtendRes(IslandNum):
	return [IslandNum*extendWood,
	IslandNum*extendStock,
	IslandNum*extendFood,
	IslandNum*extendGold,
	]

#检查并且扣除资源 能建造、口资源，不能的话返回false
func checkBuildRes(Build):
	#var res = [["木材",10],["石材",10],["食物",10]]
	var woodNeed = Build.res[0][1]
	var stockNeed = Build.res[1][1]
	var foodNeed = Build.res[2][1]
	var goldNeed = 0
	if len(Build.res)==4:
		goldNeed = Build.res[3][1]
	#var woodnum = 2000
	#var stocknum = 2000
	#var foodnum = 2000
	#var goldnum = 2000
	if woodNeed<=ResWarehouse.woodnum and stockNeed<=ResWarehouse.stocknum and foodNeed<=ResWarehouse.foodnum and goldNeed<=ResWarehouse.goldnum :
		#扣除资源
		ResWarehouse.woodnum -= woodNeed
		ResWarehouse.stocknum -= stockNeed
		ResWarehouse.foodnum -= foodNeed
		ResWarehouse.goldnum -= goldNeed
		ResWarehouse.updateRes()
		#返回
		return true
	else:
		return false
