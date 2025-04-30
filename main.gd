extends Node3D

var tower = null

var players = [
	{"name": "Player 1", "lives": 4, "score": 0},
	{"name": "Player 2", "lives": 4, "score": 0},
	{"name": "Player 3", "lives": 4, "score": 0},
	{"name": "Player 4", "lives": 4, "score": 0}
]
var current_player_index = 0
#var current_player = players[current_player_index]
var touching_ground = false

var selected_block: RigidBody3D = null
var previous_block: RigidBody3D = null
var original_color: Color = Color.WHITE

var Question_show: bool = true
@export var question_Bali_node := []
var last_question_Bali = null
@export var question_Jawa_node := []
var last_question_Jawa = null
@export var question_Kalimantan_node := []
var last_question_Kalimantan = null
@export var question_Sumatra_node := []
var last_question_Sumatra = null

@export var rotation_speed: float = 1.5

@export var rotation_step = 90.0
@export var move_y_speed = 6
@export var move_speed = 25

var answer_is_true: bool = false
var done_moving: bool = true

var current_block_xyz = Vector3.ZERO

signal call_question(call: bool)
signal question_show(q_show: bool)

func next_player():
	current_player_index = (current_player_index + 1) % players.size()
	while players[current_player_index]["lives"] <= 0:
		current_player_index = (current_player_index + 1) % players.size()
	
	#print_player_status()
	print("Giliran: ", players[current_player_index].name)
	
	
func _on_q_answer_is(correct: bool) -> void:
	if correct:
		answer_is_true = true
	if not correct:
		answer_is_true = false
		
func all_block(tower : Node3D):
	var all_block = []
	for block in tower.get_children():
		if block is Node3D:    
			block.mass = 1
			block.gravity_scale = .5
			block.physics_material_override.friction = 1
			all_block.append(block)
	return all_block
	
func _ready():
	$"CanvasLayer/UserInterface/Question/questionBali".hide()
	$"CanvasLayer/UserInterface/Question/questionJawa".hide()
	$"CanvasLayer/UserInterface/Question/questionSulawesi".hide()
	$"CanvasLayer/UserInterface/Question/questionSumatra".hide()
	Question_show = false
	question_Bali_node = $CanvasLayer/UserInterface/Question/questionBali.get_children()
	question_Jawa_node = $CanvasLayer/UserInterface/Question/questionJawa.get_children()
	question_Sumatra_node = $CanvasLayer/UserInterface/Question/questionSumatra.get_children()
	question_Kalimantan_node = $CanvasLayer/UserInterface/Question/questionSulawesi.get_children()
	$"CanvasLayer/UserInterface/ColorRect".visible = false
	$"CanvasLayer/UserInterface/ColorRect2".visible = false
	$"CanvasLayer/UserInterface/ColorRect3".visible = false
	$"CanvasLayer/UserInterface/Player2/ColorRect".visible = false
	$"CanvasLayer/UserInterface/Player1/ColorRect".visible = true
	tower =  $"Tower"
	all_block(tower)
	
		
func show_random_question_Bali():
	for question in question_Bali_node:
		question.visible = false
	var random_question_Bali
	while true:
		random_question_Bali = question_Bali_node[randi() % question_Bali_node.size()]
		if random_question_Bali != last_question_Bali:
			emit_signal("call_question", true)
			break
	random_question_Bali.visible = true
	last_question_Bali = random_question_Bali
	print("Soal yang dipilih: ", random_question_Bali.name)
	print("last question: ", last_question_Bali.name)
	$'CanvasLayer/UserInterface/Button'.visible = false
	$'CanvasLayer/UserInterface/BlockButton'.visible = false
	
func show_random_question_Jawa():
	for question in question_Jawa_node:
		question.visible = false
	var random_question_Jawa
	while true:
		random_question_Jawa = question_Jawa_node[randi() % question_Jawa_node.size()]
		if random_question_Jawa != last_question_Jawa:
			emit_signal("call_question", true)
			break
	random_question_Jawa.visible = true
	last_question_Jawa = random_question_Jawa
	print("Soal yang dipilih: ", random_question_Jawa.name)
	print("last question: ", last_question_Jawa.name)
	$'CanvasLayer/UserInterface/Button'.visible = false
	$'CanvasLayer/UserInterface/BlockButton'.visible = false

func show_random_question_Kalimantan():
	for question in question_Kalimantan_node:
		question.visible = false
	var random_question_Kalimantan
	while true:
		random_question_Kalimantan = question_Kalimantan_node[randi() % question_Kalimantan_node.size()]
		if random_question_Kalimantan != last_question_Kalimantan:
			emit_signal("call_question", true)
			break
	random_question_Kalimantan.visible = true
	last_question_Kalimantan = random_question_Kalimantan
	print("Soal yang dipilih: ", random_question_Kalimantan.name)
	print("last question: ", last_question_Kalimantan.name)
	$'CanvasLayer/UserInterface/Button'.visible = false
	$'CanvasLayer/UserInterface/BlockButton'.visible = false

func show_random_question_Sumatra():
	for question in question_Sumatra_node:
		question.visible = false
	var random_question_Sumatra
	while true:
		random_question_Sumatra = question_Sumatra_node[randi() % question_Sumatra_node.size()]
		if random_question_Sumatra != last_question_Sumatra:
			emit_signal("call_question", true)
			break
	random_question_Sumatra.visible = true
	last_question_Sumatra = random_question_Sumatra
	print("Soal yang dipilih: ", random_question_Sumatra.name)
	print("last question: ", last_question_Sumatra.name)
	$'CanvasLayer/UserInterface/Button'.visible = false
	$'CanvasLayer/UserInterface/BlockButton'.visible = false

func get_node_by_type(parent: Node) -> Node:
	for child in parent.get_children():
		if child is MeshInstance3D:
			return child
	return null

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Menentukan ray dari kamera ke posisi mouse
			var ray_origin = get_viewport().get_camera_3d().project_ray_origin(get_viewport().get_mouse_position())
			var ray_direction = get_viewport().get_camera_3d().project_ray_normal(get_viewport().get_mouse_position())
			var space_state = get_world_3d().direct_space_state

			# Menggunakan ray untuk mendeteksi objek
			var query = PhysicsRayQueryParameters3D.new()
			query.from = ray_origin
			query.to = ray_origin + ray_direction * 100
			query.collide_with_bodies = true

			var result = space_state.intersect_ray(query)

			# Jika ray mengenai sesuatu
			if result and result.collider.is_in_group("blocks") and done_moving:
				var new_block = result.collider
				if new_block.position.y <= 1.5:
					print('balok ',new_block, ' terdeteksi')
					emit_signal("question_show", true)
					Question_show = true
					done_moving = false
					current_block_xyz = new_block.position
					touching_ground = false
					if new_block.is_in_group("bali"):
						$"CanvasLayer/UserInterface/Question/questionBali".show()
						show_random_question_Bali()
						$"CanvasLayer/UserInterface/Question/questionJawa".hide()
						$"CanvasLayer/UserInterface/Question/questionSulawesi".hide()
						$"CanvasLayer/UserInterface/Question/questionSumatra".hide()
					if new_block.is_in_group("jawa"):
						$"CanvasLayer/UserInterface/Question/questionJawa".show()
						show_random_question_Jawa()
						$"CanvasLayer/UserInterface/Question/questionBali".hide()
						$"CanvasLayer/UserInterface/Question/questionSulawesi".hide()
						$"CanvasLayer/UserInterface/Question/questionSumatra".hide()
					if new_block.is_in_group("sulawesi"):
						$"CanvasLayer/UserInterface/Question/questionSulawesi".show()
						show_random_question_Kalimantan()
						$"CanvasLayer/UserInterface/Question/questionBali".hide()
						$"CanvasLayer/UserInterface/Question/questionJawa".hide()
						$"CanvasLayer/UserInterface/Question/questionSumatra".hide()
					if new_block.is_in_group("sumatra"):
						$"CanvasLayer/UserInterface/Question/questionSumatra".show()
						show_random_question_Sumatra()
						$"CanvasLayer/UserInterface/Question/questionBali".hide()
						$"CanvasLayer/UserInterface/Question/questionJawa".hide()
						$"CanvasLayer/UserInterface/Question/questionSulawesi".hide()
				
					# Reset warna balok sebelumnya jika berbeda
					if selected_block and selected_block != new_block:
						reset_block_color(selected_block)

					# Pilih balok baru
					selected_block = new_block
					change_block_color(selected_block)
				else:
					print('balok ketinggian')
					$"CanvasLayer/UserInterface/ColorRect".visible = true
					$"CanvasLayer/UserInterface/ColorRect/AnimationPlayer".play("alert")
				
				
			else:
				#selected_block = null
				print('tidak ada balok terdeteksi')
			

func change_block_color(block: RigidBody3D):
	# Ambil node MeshInstance3D dari balok
	var mesh_instance: MeshInstance3D = block.get_node("MeshInstance3D")

	# Simpan warna asli jika belum tersimpan
	if original_color == Color.WHITE:
		original_color = mesh_instance.material_override.albedo_color

	# Ubah warna menjadi memudar (lebih gelap)
	var fade_factor = 0.7
	var new_color = Color(
					original_color.r * (1 - fade_factor) + fade_factor * 0.5,  # Mengurangi red
					original_color.g * (1 - fade_factor) + fade_factor * 0.5,  # Mengurangi green
					original_color.b * (1 - fade_factor) + fade_factor * 0.5   # Mengurangi blue
					)
	mesh_instance.material_override.albedo_color = new_color

func reset_block_color(block: RigidBody3D):
	# Kembalikan warna ke warna asli
	var mesh_instance: MeshInstance3D = block.get_node("MeshInstance3D")
	if original_color != Color.WHITE:
		mesh_instance.material_override.albedo_color = original_color

	# Kosongkan warna asli
	original_color = Color.WHITE

func _on_q_question_answered(answered: bool) -> void:
	if answered:
		Question_show = false
		print('terjawab bosq')
		if answer_is_true:
			$'CanvasLayer/UserInterface/Button'.visible = true
			$'CanvasLayer/UserInterface/BlockButton'.visible = true
			$'CanvasLayer/UserInterface/BlockButton/ContainerMesh/MeshInstance2D/AnimationPlayer'.play("timer")
			$'Timer'.start()
		if not answer_is_true:
			done_moving = true
			$'CanvasLayer/UserInterface/Button'.visible = true
			the_scores()
		
func _process(delta) -> void:
	#for block in all_block(tower):
		#if block.position.y <= .1:
			#all_fall()
			#break
			
	if not Question_show:
		var pivot = $"Pivot"
		if Input.is_action_pressed("camera_roatate_left"):
			pivot.rotate_y(rotation_speed * delta)
		if Input.is_action_pressed("camera_roatate_right"):
			pivot.rotate_y(-rotation_speed * delta)
			
	if selected_block and answer_is_true and not done_moving:
		$'CanvasLayer/UserInterface/BlockButton/DoneButton'.visible = true
		if Input.is_action_just_pressed("rotate_block"):
			selected_block.rotation_degrees.y += rotation_step
		if Input.is_action_just_pressed("move_down"):
			$"Pivot/Camera3D".position.y = 2
			selected_block.gravity_scale = 1
			selected_block.position.y -= move_y_speed * delta
		if Input.is_action_just_pressed("move_up"):
			$"Pivot/Camera3D".position.y += move_y_speed * delta
			selected_block.gravity_scale = 0
			selected_block.position.y += move_y_speed * delta
		if Input.is_action_just_pressed("move_left"):
			selected_block.gravity_scale = 0
			selected_block.position.x -= move_speed * delta
		if Input.is_action_just_pressed("move_right"):
			selected_block.gravity_scale = 0
			selected_block.position.x += move_speed * delta
		if Input.is_action_just_pressed("move_forward"):
			selected_block.gravity_scale = 0
			selected_block.position.z += move_speed * delta
		if Input.is_action_just_pressed("move_backward"):
			selected_block.gravity_scale = 0
			selected_block.position.z -= move_speed * delta
		if selected_block.gravity_scale == 0:
			$'CanvasLayer/UserInterface/BlockButton/DoneButton'.visible = false
		elif selected_block.gravity_scale > 0:
			$'CanvasLayer/UserInterface/BlockButton/DoneButton'.visible = true
		if selected_block.position.y < 0.1:
			touching_ground = true
			done_moving = true
			selected_block.gravity_scale = 1
			$'CanvasLayer/UserInterface/Button'.visible = true
			$'CanvasLayer/UserInterface/BlockButton'.visible = false
			$'CanvasLayer/UserInterface/BlockButton/ContainerMesh/MeshInstance2D/AnimationPlayer'.stop(false)
			$"Pivot/Camera3D".position.y = 2
			selected_block.position = current_block_xyz
			$"CanvasLayer/UserInterface/ColorRect2".visible = true
			$"CanvasLayer/UserInterface/ColorRect2/AnimationPlayer".play("alert")
			the_scores()
			
	if not answer_is_true:
		$'CanvasLayer/UserInterface/BlockButton'.visible = false
	

func _on_done_button_pressed() -> void:
	done_moving = true
	selected_block.gravity_scale = 1
	$'CanvasLayer/UserInterface/Button'.visible = true
	$'CanvasLayer/UserInterface/BlockButton'.visible = false
	$'CanvasLayer/UserInterface/BlockButton/ContainerMesh/MeshInstance2D/AnimationPlayer'.stop(false)
	$"Timer".stop()
	$"Pivot/Camera3D".position.y = 2
	the_scores()


func _on_timer_timeout() -> void:
	done_moving = true
	selected_block.gravity_scale = 1
	$'CanvasLayer/UserInterface/Button'.visible = true
	$'CanvasLayer/UserInterface/BlockButton'.visible = false
	$'CanvasLayer/UserInterface/BlockButton/ContainerMesh/MeshInstance2D/AnimationPlayer'.stop(false)
	$"CanvasLayer/UserInterface/ColorRect3".visible = true
	$'CanvasLayer/UserInterface/ColorRect3/AnimationPlayer'.play("alert")
	$"Pivot/Camera3D".position.y = 2
	the_scores()

func the_scores():
	var current_player = players[current_player_index]
	if touching_ground or not answer_is_true:
		current_player["lives"] -= 1
		edit_ui()
		print(current_player["name"], " menjawab salah! Nyawa tersisa: ", current_player["lives"])
		next_player()
	if players[0]["lives"] <= 0 or players[1]["lives"] <= 0 or players[2]["lives"] <= 0 or players[3]["lives"] <= 0:
		game_over()
		
	if not touching_ground and answer_is_true:
		current_player["score"] += 10
		edit_ui()
		print(current_player["name"], " menjawab benar! Skor: ", current_player["score"])
		next_player()
		

func all_fall():
	if selected_block.position.y >= .1:
		game_over()
				
			

func game_over() -> void:
	$"CanvasLayer/UserInterface/Restart".visible = true

func edit_ui():
	if current_player_index == 0:
		$"CanvasLayer/UserInterface/Player2/ColorRect".visible = true
		$"CanvasLayer/UserInterface/Player1/ColorRect".visible = false
		$"CanvasLayer/UserInterface/Player1/Score".text ="SCORE: " + str(players[0]["score"])
		if players[0]["lives"] < 4:
			$"CanvasLayer/UserInterface/Player1/Heart/Heart4".visible = false
			if players[0]["lives"] < 3:
				$"CanvasLayer/UserInterface/Player1/Heart/Heart3".visible = false
				if players[0]["lives"] < 2:
					$"CanvasLayer/UserInterface/Player1/Heart/Heart2".visible = false
					if players[0]["lives"] < 1:
						$"CanvasLayer/UserInterface/Player1/Heart/Heart2".visible = false
			
	if current_player_index == 1:
		$"CanvasLayer/UserInterface/Player3/ColorRect".visible = true
		$"CanvasLayer/UserInterface/Player2/ColorRect".visible = false
		$"CanvasLayer/UserInterface/Player2/Score".text ="SCORE: " + str(players[1]["score"])
		if players[1]["lives"] < 4:
			$"CanvasLayer/UserInterface/Player2/Heart/Heart4".visible = false
			if players[1]["lives"] < 3:
				$"CanvasLayer/UserInterface/Player2/Heart/Heart3".visible = false
				if players[1]["lives"] < 2:
					$"CanvasLayer/UserInterface/Player2/Heart/Heart2".visible = false
					if players[1]["lives"] < 1:
						$"CanvasLayer/UserInterface/Player2/Heart/Heart2".visible = false
	if current_player_index == 2:
		$"CanvasLayer/UserInterface/Player4/ColorRect".visible = true
		$"CanvasLayer/UserInterface/Player3/ColorRect".visible = false
		$"CanvasLayer/UserInterface/Player3/Score".text ="SCORE: " + str(players[2]["score"])
		if players[2]["lives"] < 4:
			$"CanvasLayer/UserInterface/Player3/Heart/Heart4".visible = false
			if players[2]["lives"] < 3:
				$"CanvasLayer/UserInterface/Player3/Heart/Heart3".visible = false
				if players[2]["lives"] < 2:
					$"CanvasLayer/UserInterface/Player3/Heart/Heart2".visible = false
					if players[2]["lives"] < 1:
						$"CanvasLayer/UserInterface/Player3/Heart/Heart2".visible = false
	if current_player_index == 3:
		$"CanvasLayer/UserInterface/Player1/ColorRect".visible = true
		$"CanvasLayer/UserInterface/Player4/ColorRect".visible = false
		$"CanvasLayer/UserInterface/Player4/Score".text ="SCORE: " + str(players[3]["score"])
		if players[3]["lives"] < 4:
			$"CanvasLayer/UserInterface/Player4/Heart/Heart4".visible = false
			if players[3]["lives"] < 3:
				$"CanvasLayer/UserInterface/Player4/Heart/Heart3".visible = false
				if players[3]["lives"] < 2:
					$"CanvasLayer/UserInterface/Player4/Heart/Heart2".visible = false
					if players[3]["lives"] < 1:
						$"CanvasLayer/UserInterface/Player4/Heart/Heart2".visible = false


func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://start.tscn")


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	reset_block_color(selected_block)
