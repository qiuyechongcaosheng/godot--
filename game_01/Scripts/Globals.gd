extends Node

#字典的作用是存储要有的数据集，方便调用。是由键(KEY:也就是说是检索的索引)和值（这个键的详细内容）组成。有先后顺序。
var shapes:	Dictionary = {"shape1":[Vector2(0,0),Vector2(0,1),Vector2(1,1),Vector2(2,1)],
							"shape2":[Vector2(2,0),Vector2(0,1),Vector2(1,1),Vector2(2,1)],
							"shape3":[Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(2,1)],
							"shape4":[Vector2(1,0),Vector2(2,0),Vector2(0,1),Vector2(1,1)],
							"shape5":[Vector2(1,0),Vector2(0,1),Vector2(1,1),Vector2(2,1)],
							"shape6":[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(3,0)],
							"shape7":[Vector2(0,0),Vector2(1,0),Vector2(0,1),Vector2(1,1)],};

var shape1_state:Array =[[Vector2(1,0),Vector2(1,1),Vector2(0,2),Vector2(1,2)],[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(2,1)],
						[Vector2(0,0),Vector2(0,1),Vector2(0,2),Vector2(1,0)],[Vector2(0,0),Vector2(0,1),Vector2(1,1),Vector2(2,1)]];
						
var shape2_state:Array =[[Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(1,2)],[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(0,1)],
						[Vector2(0,0),Vector2(0,1),Vector2(0,2),Vector2(1,2)],[Vector2(2,0),Vector2(0,1),Vector2(1,1),Vector2(2,1)]];
						
var shape4_state:Array =[[Vector2(1,0),Vector2(0,1),Vector2(1,1),Vector2(0,2)],[Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(2,1)]];

var shape3_state:Array =[[Vector2(0,0),Vector2(0,1),Vector2(1,1),Vector2(1,2)],[Vector2(1,0),Vector2(2,0),Vector2(0,1),Vector2(1,1)]];

var shape5_state:Array =[[Vector2(1,0),Vector2(0,1),Vector2(1,1),Vector2(1,2)],[Vector2(0,1),Vector2(1,1),Vector2(2,1),Vector2(1,2)],
						[Vector2(1,0),Vector2(1,1),Vector2(2,1),Vector2(1,2)],[Vector2(0,0),Vector2(-1,1),Vector2(0,1),Vector2(1,1)]];
						
var shape6_state:Array =[[Vector2(1,0),Vector2(1,1),Vector2(1,2),Vector2(1,3)],[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(3,0)]];

#消行增加的分数
var add_score:Array = [100,300,700,1500];

#升级所需的分数
var level_score:Array = [0,10000,20000,30000,50000,80000,120000,180000,2500000];
