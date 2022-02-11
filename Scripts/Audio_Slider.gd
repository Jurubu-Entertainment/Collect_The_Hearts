extends NinePatchRect

export var audio_bus_name = ''

onready var left_texture = preload("res://Assets/UI/PNG/grey_sliderLeft.png")
onready var middle_texture = preload("res://Assets/UI/PNG/grey_box.png")
onready var right_texture = preload("res://Assets/UI/PNG/grey_sliderRight.png")

onready var slider = $HSlider
onready var slider_texture = self
onready var bus = AudioServer.get_bus_index(audio_bus_name)


func _ready():
	slider.rect_size.x = self.rect_size.x * 2
	slider_texture.rect_size.x = self.rect_size.x


func _on_VSlider_value_changed(value: float):
	AudioServer.set_bus_volume_db(bus, linear2db(value))


func _on_VSlider_mouse_exited() -> void:
	slider.release_focus()
