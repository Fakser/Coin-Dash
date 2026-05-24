extends Node

@export var player_start_position: Vector2
@export var coin: PackedScene
@export var powerup: PackedScene
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.playing and $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5
		$AudioStreamPlayer2D.play()

		spawn_coins()
		$PowerupTimer.wait_time = randi_range(5, 10)
		$PowerupTimer.start()

func _on_game_timer_timeout() -> void:
	self.time_left -= 1
	$HUD.update_time(self.time_left)
	if self.time_left <= 0:
		game_over()

func new_game():
	self.playing = true
	self.level = 1
	self.score = 0
	self.time_left = playtime
	$Player.start(self.player_start_position)
	$Player.show()
	$GameTimer.start()
	spawn_coins()

func game_over():
	playing = false
	$GameTimer.stop()
	for child in $CoinContainer.get_children():
			child.queue_free()
	$HUD.show_game_over()
	$Player.die()

func spawn_coins():
	for i in range(4 + self.level):
		var c = self.coin.instantiate()
		c.screensize = self.screensize
		c.position = Vector2(
			randi_range(0, self.screensize.x),
			randi_range(0, self.screensize.y))
		$CoinContainer.add_child(c)


func _on_player_pickup(group: String) -> void:
	match group:
		"coins":
			self.score += 1
			$HUD.update_score(self.score)
		"powerups":
			self.time_left += 5
			$HUD.update_time(self.time_left)


func _on_powerup_timer_timeout() -> void:
	var p = self.powerup.instantiate()
	p.screensize = self.screensize
	p.position = Vector2(
		randi_range(0, self.screensize.x),
		randi_range(0, self.screensize.y))
	self.add_child(p)


func _on_player_hurt() -> void:
	game_over()
