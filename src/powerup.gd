extends Area2D

var screensize: Vector2
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pickup():
	self.tween = get_tree().create_tween()
	self.tween = tween.set_trans(Tween.TRANS_QUAD)
	self.tween = tween.set_ease(Tween.EASE_IN_OUT)
	self.tween = tween.parallel()
	self.tween.tween_property($AnimatedSprite2D, "scale", $AnimatedSprite2D.scale * 3.0, 0.3)
	self.tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1, 0), 0.2)
	self.tween.tween_callback(self.queue_free)
	$AudioStreamPlayer2D.play()


func _on_lifetime_timeout() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles"):
		self.position = Vector2(
			randi_range(0, self.screensize.x),
			randi_range(0, self.screensize.y))
