extends Node2D

const START_POS:Vector2 = Vector2(3,0);     #定义一个坐标。方便图像落到中间
const DISTANCE:Vector2 = Vector2.DOWN;    #定义一个下落距离
@onready var nextTileMap:TileMapLayer = $NextTileMapLayer;
@onready var mainTileMap:TileMapLayer = $MainTileMapLayer;
@onready var tick:Timer = $Tick;
@onready var lateral_tick = $lateral_Tick
@onready var GUI:Control = $GUI;

#下个格子形状的名字序号
var nexShapeIndex:int = 1;
#下个格子的坐标信息
var nextShape:Array;
#当前格子形状的名字序号
var currentShapeIndex:int = 1;
#当前格子的坐标信息
var currentShape:Array;
#已经落地的形状
var landingTiles:Array = [];
#平移
var lateral_move:int = 0;
#下落
#var lateral_down:int = 0;
#状态
var status_index:int = 0;
var status_list:Array;
#记录落点格子的坐标信息
var final_locaropn_shape:Array = [];
#下落声音
var land_music:bool = false;

func _ready() -> void:
	tick.start();
	lateral_tick.start();
	get_next_shape();
	draw_next_shape();
	get_current_shape();
	final_location();
	draw_current_shape();
	delete_next_shape();
	get_next_shape();
	draw_next_shape();
	check_gane_over();
	GUI.reset();
	GUI.check_speed();
	$audio/Background.play();
 	
#输入信息
func _process(delta: float) -> void:
	lateral_move = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	if Input.is_action_just_pressed("ui_down"):
		tick.wait_time = 0.1;
		land_music = true;
	if Input.is_action_just_released("ui_down"):
		tick.wait_time = 1;
	if Input .is_action_just_pressed("rotate") and currentShapeIndex !=7:
		get_rotate();
		
	if Input.is_action_just_pressed("fast_down"):
		get_fast_down();
		
	if Input.is_action_just_pressed("restart"):
		restart_game();
	#lateral_down = Input.get_action_strength("ui_down");
	#print(lateral_down);
	
	# 重新加载当前场景
func restart_game():
	var current_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(current_scene_path)
func check_gane_over():
	for cell in landingTiles:
		if cell.y <= 0:
			
			lateral_tick.stop();
			tick.stop();
			currentShape = [];
			$audio/gameover.play();
		
			
#旋转操作
func get_rotate():
	
	delete_current_shape();
	rotate_current_shape();
	final_location();
	draw_current_shape();
	$audio/rotate.play();
	status_index +=1;
	status_list = [];
	print(status_index);
	print(currentShape);

#旋转坐标初始化后调用已经存储好的旋转坐标
func rotate_current_shape():
	
	var min_x:int = get_min_x(currentShape);
	var min_y:int = get_min_y(currentShape);
	
	#if status_index > status_list.size():  #循环到同一个图像
		#status_index = 0;
	match currentShapeIndex:
		1:
			status_list = Globals.shape1_state;
		2:
			status_list = Globals.shape2_state;
		3:
			status_list = Globals.shape3_state;
		4:
			status_list = Globals.shape4_state;
		5:
			status_list = Globals.shape5_state;
			
		6:
			status_list = Globals.shape6_state;
			if status_index == 1:
				min_x -= 1;

	var temp_index:int = status_index;
	if temp_index >= status_list.size():
		temp_index = 0;
	if status_index >= status_list.size():
		status_index =0;
	var status:Array = status_list[status_index].duplicate();

	for i in status.size():
		status[i].x += min_x;
		status[i].y += min_y ;
		
	var isBound:bool = check_bound(status);
	var isLanding:bool = check_landing(status);
	
	if not isBound and not isLanding: 
		currentShape = status;
		status_index = temp_index 
	 
	
	
	

#获取图像坐标X最小值
func get_min_x(copy:Array) -> int:
	var min_x:int = 100;
	for cell in copy:
		if cell.x < min_x:
			min_x = cell.x;
	return min_x;

#获取图像坐标y最小值
func get_min_y(copy:Array) -> int:
	var min_y:int = 100;
	for cell in copy:
		if cell.y < min_y:
			min_y = cell.y;
	return min_y;

#下一个形状
func get_next_shape():
	randomize();
	nexShapeIndex = randi() % 7 + 1;
	#nexShapeIndex = 6;
	nextShape = Globals.shapes["shape" + str(nexShapeIndex)];
	#清除上次变形的数据
	status_index = 0;
	status_list =[];

#快速下落
func get_fast_down():
	var deapth:int = 1;
	var currenCopy:Array = [];
	for cell in currentShape:
		cell.y += deapth;
		currenCopy.append(cell);
	var is_land = check_landing(currenCopy);
	while is_land == false:
		deapth += 1;
		currenCopy = [];
		for cell in currentShape:
			cell.y += deapth;
			currenCopy.append(cell);
			is_land = check_landing(currenCopy);
	for i in currenCopy.size():
		currenCopy[i].y -=1;
		mainTileMap.set_cell(Vector2i(currenCopy[i].x,currenCopy[i].y),0,Vector2i(0,0))
	landingTiles.append_array(currenCopy);
	delete_current_shape();
	get_current_shape();
	draw_current_shape();
	delete_next_shape();
	get_next_shape();
	draw_next_shape();
	check_full_lines();
	
	final_location();
	draw_landing_tiles();
	check_gane_over();
	$audio/shift.play();
	
			

#落点的坐标获取
func final_location():
	delete_final_shape();
	var currentCopy:Array = [];
	var deapth:int = 1;
	for cell in currentShape:
		cell.y += deapth;
		currentCopy.append(cell);
	var is_land:bool = check_landing(currentCopy)
	while is_land == false:
		deapth += 1;
		currentCopy = [];
		for cell in currentShape:
			cell.y += deapth;
			currentCopy.append(cell);
		is_land = check_landing(currentCopy);
	final_locaropn_shape = [];
	for cell in currentCopy:
		cell.y -= 1;
		final_locaropn_shape.append(cell);
	
	draw_final_shape();
	

#删除落点图像
func delete_final_shape():
	for cell in final_locaropn_shape:
		mainTileMap.set_cell(Vector2i(cell.x,cell.y),-1,Vector2i(0,0));
#绘画落地图像
func draw_final_shape():
	for cell in final_locaropn_shape:
		mainTileMap.set_cell(Vector2i(cell.x,cell.y),1,Vector2i(0,0));
	


#绘画图像
func draw_next_shape():
	for cell in nextShape:
		nextTileMap.set_cell(Vector2i(cell.x,cell.y),0,Vector2i(0,0));
		
#删除上一个图像
func delete_next_shape():
	for cell in nextShape:
		nextTileMap.set_cell(Vector2i(cell.x,cell.y),-1,Vector2i(0,0));
#删除前一秒生成的当前图像
func delete_current_shape():
	for cell in currentShape:
		mainTileMap.set_cell(Vector2i(cell.x,cell.y),-1,Vector2i(0,0));
		
#复制上一个图像信息
func get_current_shape():
	currentShapeIndex = nexShapeIndex;
	#currentShape = nextShape;把坐标挪到中间
	currentShape = [];
	for cell in nextShape:
		currentShape.append(Vector2(cell.x+ START_POS.x  ,cell.y + START_POS.y));

#绘画当前图像
func draw_current_shape():
	for cell in currentShape:
		mainTileMap.set_cell(Vector2i(cell.x ,cell.y),0,Vector2i(0,0));


#下落
func move_current_shape():
	delete_current_shape();
	var currentCopy:Array = [];
	for cell in currentShape:
		cell += DISTANCE;
		currentCopy.append(cell);
		
	var is_land:bool = check_landing(currentCopy);
	if is_land:
		landingTiles.append_array(currentShape);
		delete_current_shape();
		get_current_shape();
		delete_next_shape();
		get_next_shape();
		draw_next_shape();
		check_full_lines();
		final_location();
		draw_current_shape();
		draw_landing_tiles();
		check_gane_over();
		$audio/land.play();
		
		
	else :
		currentShape = currentCopy;
		$audio/move.play();
		
	
	#平移获取坐标信息
func later_move_current_shape():
	delete_current_shape();
	
	var currentCopy:Array = [];
	for cell in currentShape:
		cell.x += lateral_move;
		currentCopy.append(cell);
		
	var isBound:bool = check_bound(currentCopy);
	var isOverLapp:bool = check_landing(currentCopy);
	if not isBound and not isOverLapp:
		currentShape = currentCopy;
	
#判断图像的Y坐标的值看物体是否在地上
func check_landing(copy:Array) -> bool:   #检查是否在框内
	#1,落在地上
	var is_land:bool = false;
	var max_y:int = get_max_y(copy);
	if max_y > 19:
		is_land = true;
	var overlapp:bool = check_overlapping(copy);
	#2落在其他物体上
	return is_land or overlapp;
	
	
#检查重叠
func check_overlapping(copy:Array) -> bool:
	var overlapp:bool = false;
	for cell in copy:
		if landingTiles.find(cell) > -1:
			overlapp = true;
			
	return overlapp
	
#检查左右边界
func check_bound(copy:Array) -> bool:
	var isBound:bool  = false;
	var min_x:int = get_min_x(copy);
	if min_x < 0:
		isBound = true;
	var max_x:int = get_max_x(copy);
	if max_x > 9:
		isBound = true;
	return isBound
	
#判断是否以满行。
func check_full_lines():
	#一行有多少个块
	var line_elements:int = 0;
	#第几行
	var line:int = 19;
	#当前行所以数据的位置
	var tileIndex:Array = [];
	#会满几行
	var fullLineCount:int = 0;
	while line > -1:
		line_elements = 0;
		tileIndex = [];
		for i in landingTiles.size():
			var cell:Vector2 = landingTiles[i];
			if cell.y == line:
				line_elements += 1;
				tileIndex.append(i);
		if line_elements ==10:
			fullLineCount += 1;
			delete_landing_data(tileIndex,line);
			
		else:
			line -= 1;
	if fullLineCount > 0:
		delete_landing_tile();
		draw_landing_tiles();
		draw_current_shape();
		$audio/clear.play();
		GUI.add_level(fullLineCount);
		GUI.check_speed();
			
#删除整行图像
func delete_landing_tile():
	var cells:Array = mainTileMap.get_used_cells_by_id(0);
	for cell in cells:
		mainTileMap.set_cell(Vector2i(cell.x,cell.y),-1,Vector2i(0,0));
	$audio/clear.play();
#删除整行
func delete_landing_data(tileIndex:Array,line:int):
	while tileIndex.size() > 0:
		landingTiles.remove_at(tileIndex.pop_back())
	for i in landingTiles.size():
		if landingTiles[i].y < line:
			landingTiles[i].y += 1;
	
#绘画落地的形状
func draw_landing_tiles():
	#var cells:Array = mainTileMap.get_used_cells_by_id(0)
	for cell in landingTiles:
		mainTileMap.set_cell(Vector2i(cell.x,cell.y),0,Vector2i(0,0));
	
#下落时间计时器
func _on_tick_timeout() -> void:
	move_current_shape();
	draw_current_shape();
	
	
	
	
#获取图像的Y坐标值
func get_max_y(copy:Array) -> int:
	var max_y:int = 0;
	for cell in copy:
		if cell.y > max_y:
			max_y = cell.y;
	return max_y;
	
#获取图像的x坐标值	
func get_max_x(copy:Array) -> int:
	var max_x:int = 0;
	for cell in copy:
		if cell.x >= max_x:
			max_x = cell.x;
	return max_x;

#定义一个等待时间
func set_wait_time(value:float):
	tick.stop();
	tick.wait_time = value;
	tick.start();
	$audio/level.play();
	

#平移时间计时器,如果没有左右信号，那么重新获取左右移动的信息并绘制图像
func _on_lateral_tick_timeout() -> void:
	if lateral_move != 0:
		later_move_current_shape();
		final_location();
		draw_current_shape();
		$audio/move.play();
		
	
