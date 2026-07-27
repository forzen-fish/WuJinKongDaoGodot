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
