extends Control

signal question_answered(answered: bool)
signal answer_is(correct: bool)

func _on_wrong_pressed() -> void:
	$"showWrong".visible = true
	$'theQuestion'. visible = false
	$'Timer'.start()
	emit_signal("answer_is", false)
	print('salah')

func _on_correct_pressed() -> void:
	$"showCorrect".visible = true
	$'theQuestion'.visible = false
	$'Timer'.start()
	emit_signal("answer_is", true)
	print('benar')


func _on_timer_timeout() -> void:
	$"showWrong".visible = false
	$"showCorrect".visible = false
	emit_signal("question_answered", true)
	print('close otomatis')


func _on_close_button_pressed() -> void:
	$"showWrong".visible = false
	$"showCorrect".visible = false
	emit_signal("question_answered", true)
	$'Timer'.stop()
	print('di close')


func _on_main_call_question(call: bool) -> void:
	if call:
		$'theQuestion'. visible = true
