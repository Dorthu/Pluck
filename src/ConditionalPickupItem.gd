extends PickupItem

class_name ConditionalPickupItem

export var required_game_state: String
export(Array, String) var before_state_lines
var before_state_dialog_pool: Clickable.DialogTextPool

func _ready():
	before_state_dialog_pool = Clickable.DialogTextPool.new(before_state_lines)
	
func collect(controller):
	if required_game_state in controller.game_state:
		if controller.game_state[required_game_state]:
			.collect(controller)
	
	# it's not time to collect this yet
	if len(before_state_dialog_pool.lines) > 0:
		controller.show_dialog(before_state_dialog_pool)