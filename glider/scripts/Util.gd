extends Node

const TIME_FORMAT := "%02d:%02d:%02d"

func millis_to_string(time_in_ms: int) -> String:
    var minutes := time_in_ms / 60000
    var seconds := time_in_ms / 1000
    var millis := (time_in_ms % 1000) / 10
    return TIME_FORMAT % [minutes, seconds, millis]
