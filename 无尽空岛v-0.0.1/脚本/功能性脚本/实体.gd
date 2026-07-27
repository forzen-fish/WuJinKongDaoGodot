extends Node2D

#定义一个信号拾取
signal picked(name, count)

@onready var sprite_2d: Sprite2D = $Sprite2D
const 实体 = preload("uid://b1vfj2utri10o")

#定时销毁3s
@onready var timer: Timer = $Timer

##加减资源 改用信号到主场景控制
#@onready var ResWarehouse: Node2D = $资源仓库




const 木材图标 = preload("uid://cpmijbde5ssu1")
const 石头图标 = preload("uid://d0etedsfhgj5n")
const 食物 = preload("uid://cd7s3vwrpjfr8")

var wood = {
	"name":"木材",
	"icon":木材图标,
	"num":0
}
var stock = {
	"name":"石材",
	"icon":石头图标,
	"num":0
}
var food = {
	"name":"食物",
	"icon":食物,
	"num":0
}
var resList = [wood,stock,food]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

#初始化
# days:生存天数 TODO 随生存天数变化获取资源的倍数
# daoju:道具 TODO 商店提升倍数的倍数
# 基础资源 1-6
func initRes(days,daoju):
	#获取随机资源
	var resInfo = resList[randi() % len(resList)]
	var newRes = 实体.instantiate()
	var sprite = newRes.get_node("Sprite2D")
	sprite.texture = resInfo["icon"]
	#后期用days和daoju
	newRes.set_meta("num", randi() % 6 + 1)
	newRes.set_meta("name", resInfo["name"])
	return newRes

# 点击检测
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var globalMousePos = get_global_mouse_position()
		var sprite2DRect = sprite_2d.get_rect()
		var sprite2DGlobalPos = sprite_2d.global_position
		# Sprite2D 默认原点在中心，所以需要偏移半个大小
		var  sprite_global_rect = Rect2(
			sprite2DGlobalPos - sprite2DRect.size / 2,
			sprite2DRect.size
			)
		if sprite_global_rect.has_point(globalMousePos):
			pickup()




# 拾取处理
func pickup() -> void:
	#print("拾取了：", get_meta("num", 0), " 个", wood.name)
	#拾取处理
	#print(self.get_meta("num"))
	#print(self.get_meta("name"))
	
	var resname = self.get_meta("name")
	var resnum = int(self.get_meta("num"))
	
	#用信号传
	picked.emit(resname, int(resnum))
	
	#添加资源
	#ResWarehouse.addRes(resname,resnum)
	#if resname=="木材":
		#pass
	#elif resname == "石材":
		#pass
	#elif resnum=="食物":
		#pass

	#销毁
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
