extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area is CharaSoulHurtbox:
		HpManager.set_damage(5, 0, HpManager.DamageTypes.NORMAL)
