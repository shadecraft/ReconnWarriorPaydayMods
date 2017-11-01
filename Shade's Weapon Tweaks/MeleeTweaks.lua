local _init_melee_weapons_actual = BlackMarketTweakData._init_melee_weapons

function BlackMarketTweakData:_init_melee_weapons(...)
    _init_melee_weapons_actual(self, ...)
	
--Great Sword
 self.melee_weapons.great.stats.min_damage = 20
 self.melee_weapons.great.stats.max_damage = 60
 self.melee_weapons.great.stats.min_damage_effect = 2
 self.melee_weapons.great.stats.max_damage_effect = 2
 self.melee_weapons.great.stats.charge_time = 3.5
 self.melee_weapons.great.stats.concealment = 26
 self.melee_weapons.great.stats.range = 280
 self.melee_weapons.great.repeat_expire_t = 3.2
 
 
end	