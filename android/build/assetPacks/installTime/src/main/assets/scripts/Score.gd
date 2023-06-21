extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.update_score.connect(update_score)


func update_score(score):
	self.text = str(score)
