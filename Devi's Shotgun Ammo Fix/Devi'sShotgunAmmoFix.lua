--if RequiredScript == "lib/tweak_data/weaponfactorytweakdata" then

	local old_wftd_init = WeaponFactoryTweakData.init
	function WeaponFactoryTweakData:init(tweak_data)
		old_wftd_init(self,tweak_data)
		


-- Slugs
self.parts.wpn_fps_upg_a_slug.stats = {value = 5, total_ammo_mod = -4, damage = 150, spread = 10, moving_spread = 0, recoil = -5}

-- High Explosive
self.parts.wpn_fps_upg_a_explosive.stats = {value = 5, total_ammo_mod = 0, damage = 200, spread = -1, moving_spread = 0, recoil = -3}
self.parts.wpn_fps_upg_a_explosive.custom_stats = {ignore_statistic = true, rays = 1, damage_near_mul = 1.5, damage_far_mul = 2, bullet_class = "InstantExplosiveBulletBase"}

-- Flechette
self.parts.wpn_fps_upg_a_piercing.stats = {value = 5, total_ammo_mod = 0, damage = 75, spread = -2, moving_spread = 0, recoil = 5}
self.parts.wpn_fps_upg_a_piercing.custom_stats = {damage_near_mul = 2, damage_far_mul = 1.7, armor_piercing_add = 1, rays = 9, can_shoot_through_enemy = true, can_shoot_through_shield = true, can_shoot_through_wall = true}

-- Dragon's Breath
self.parts.wpn_fps_upg_a_dragons_breath.stats = {value = 5, total_ammo_mod = 0, damage = 20, spread = -6, moving_spread = 0, recoil = -3}
self.parts.wpn_fps_upg_a_dragons_breath.custom_stats = {ignore_statistic = true, rays = 10, damage_near_mul = 2, damage_far_mul = 1.15, armor_piercing_add = 1, can_shoot_through_shield = true, bullet_class = "FlameBulletBase", muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath", fire_dot_data = {dot_damage = 7, dot_trigger_max_distance = 5000, dot_trigger_chance = 80, dot_length = 3, dot_tick_period = 0.5}}

-- 000 Buckshot
self.parts.wpn_fps_upg_a_custom.stats = {value = 5, total_ammo_mod = 6, damage = 100, spread = -2, moving_spread = 0, recoil = -1}
self.parts.wpn_fps_upg_a_custom_free.stats = {value = 5, total_ammo_mod = 6, damage = 20, spread = -2, moving_spread = 0, recoil = -1, can_shoot_through_enemy = true, can_shoot_through_wall = true}

end
--end