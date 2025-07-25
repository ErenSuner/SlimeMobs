extends ProgressBar


func change_health_bar_theme(fill_color: Color, background_color: Color):
	var fill_stylebox = self.get_theme_stylebox("fill")
	var new_fill_stylebox = fill_stylebox.duplicate()
	new_fill_stylebox.bg_color = fill_color
	new_fill_stylebox.border_color = background_color
	self.add_theme_stylebox_override("fill", new_fill_stylebox)
	
	var bg_stylebox = self.get_theme_stylebox("background")
	var new_bg_stylebox = bg_stylebox.duplicate()
	new_bg_stylebox.bg_color = background_color
	self.add_theme_stylebox_override("background", new_bg_stylebox)
