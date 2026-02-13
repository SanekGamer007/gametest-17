extends Trigger
var karma_timer: float = 0

func on_trigger_start() -> void:
	HpManager.set_damage(15, 0, HpManager.DamageTypes.KARMA)
	
func on_trigger_process(delta: float) -> void:
	karma_timer += delta
	if karma_timer >= 0.033:
		HpManager.set_damage(1, 0, HpManager.DamageTypes.KARMA)
		karma_timer -= 0.033
