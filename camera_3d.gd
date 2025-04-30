extends Camera3D

@export var rotation_speed = 5.0
@export var zoom_speed = 500
var min_zoom = 50
var max_zoom = 130
var Question_show: bool = false
var v = Vector3()

func _ready() -> void:
	if not Question_show:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if not Question_show:
		if event is InputEventMouseMotion:
			v.y -= (event.relative.x * 0.2)
			v.x -= (event.relative.y * 0.2)
			v.x = clamp(v.x, -80, 90)
		

func _on_main_question_show(q_show: bool) -> void:
	if q_show:
		Question_show = true


func _on_q_1_question_answered(answered: bool) -> void:
	if answered:
		Question_show = false


func _process(delta):
	if not Question_show:
		# Zoom
		if Input.is_action_just_pressed("camera_zoom_in"):
			fov -= zoom_speed * delta
			print(fov)
		elif Input.is_action_just_pressed("camera_zoom_out"):
			fov += zoom_speed * delta
		fov = clamp(fov, min_zoom , max_zoom)
	rotation_degrees.x = v.x
	rotation_degrees.y = v.y
