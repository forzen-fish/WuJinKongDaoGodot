extends Node2D

#初始值
var woodnum = 2000
var stocknum = 2000
var foodnum = 2000
var goldnum = 2000



#@onready var UIwood: Label = $"../游戏UI前置部分/资源栏ui/资源栏/木材栏/木材数量"
@onready var UIwood = get_node("../游戏UI前置部分/资源栏ui/资源栏/木材栏/木材数量")
@onready var UIstock = get_node("../游戏UI前置部分/资源栏ui/资源栏/石材栏/石材数量")
@onready var UIfood = get_node("../游戏UI前置部分/资源栏ui/资源栏/食物栏/食物数量")
@onready var UIgold = get_node("../游戏UI前置部分/资源栏ui/资源栏/金币栏/金币数量")


#@onready var 资源栏ui: Control = $"../游戏UI前置部分/资源栏ui"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateRes()
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func updateRes():
	#print(get_node("../游戏UI前置部分/资源栏ui/资源栏/木材栏/木材数量").text)
	#print(UIgold)
	#pass
	UIwood.text = str(woodnum)
	UIstock.text = str(stocknum)
	UIfood.text = str(foodnum)
	UIgold.text = str(goldnum)
	
func addRes(name,num):
	print(name)
	if name=="木材":
		woodnum+=num
	elif name=="石材":
		stocknum+=num
	elif name == "食物":
		foodnum+=num
	elif name == "金币":
		goldnum+=num
	updateRes()

#减少
func minusRes(name,num):
	print(name)
	if name=="木材":
		woodnum-=num
	elif name=="石材":
		stocknum-=num
	elif name == "食物":
		foodnum-=num
	elif name == "金币":
		goldnum-=num
	updateRes()
