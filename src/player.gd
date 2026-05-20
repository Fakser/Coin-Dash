extends Area2D

signal pickup
signal hurt

@export var speed: int
var velocity: Vector2
var screensize: Vector2


func _ready() -> void:
	self.screensize = Vector2(480, 720)

# Called every frame. 'ddselta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_input()
	self.position += velocity * delta
	self.position.x = clamp(self.position.x, 0, self.screensize.x)
	self.position.y = clamp(self.position.y, 0, self.screensize.y)
	
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
	

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
		die()

func get_input() -> void:
	self.velocity = Vector2()
	if Input.is_action_pressed('w'):
		self.velocity.y -= 1
	if Input.is_action_pressed('a'):
		self.velocity.x -= 1
	if Input.is_action_pressed('s'):
		self.velocity.y += 1
	if Input.is_action_pressed('d'):
		self.velocity.x += 1
	if velocity.length() > 0:
		self.velocity = self.velocity.normalized() * self.speed
# Called when the node enters the scene tree for the first time.

func start(pos) -> void:
	set_process(true)
	self.position = pos
	$AnimatedSprite2D.animation = "idle"

func die() -> void:
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)
