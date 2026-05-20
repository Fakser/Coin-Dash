extends Node

@export var player_start_position: Vector2
@export var coin: PackedScene
@export var playtime: int

var level: int
var score: int
var time_left: int
var screensize: Vector2
var playing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	self.screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.playing and $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5
		spawn_coins()

func new_game():
	self.playing = true
	self.level = 1
	self.score = 0
	self.time_left = playtime
	$Player.start(self.player_start_position)
	$Player.show()
	$GameTimer.start()
	spawn_coins()

func spawn_coins():
	for i in range(4 + self.level):
		var c = self.coin.instantiate()
		c.screensize = self.screensize
		c.position = Vector2(
			randi_range(0, self.screensize.x),
			randi_range(0, self.screensize.y))
		$CoinContainer.add_child(c)
		
