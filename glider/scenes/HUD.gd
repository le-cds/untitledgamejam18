extends Node


const TIME_FORMAT := "%02d:%02d:%02d"

onready var _time_label: Label = $TimeLabel

# Number of milliseconds elapsed since starting the timer.
var _time_milli := 0


func _physics_process(delta: float) -> void:
    _time_milli += int(delta * 1000)

    var minutes := int(_time_milli / 60000)
    var seconds := int(_time_milli / 1000)
    var millis := int((_time_milli % 1000) / 10)
    _time_label.text = TIME_FORMAT % [minutes, seconds, millis]
