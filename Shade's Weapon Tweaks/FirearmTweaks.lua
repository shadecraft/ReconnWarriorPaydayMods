local old_init = WeaponTweakData.init

function WeaponTweakData:init(tweak_data)
    old_init(self, tweak_data)

--Pistols	

--5/7
self.lemming.AMMO_MAX = 150

--Shotguns
	
--Judge
self.judge.AMMO_MAX = 100
self.judge.AMMO_PICKUP = {.5,1.5}
self.judge.timers.shotgun_reload_first_shell_offset	= .5

--AA-12
self.aa12.AMMO_MAX = 250

--SMG's

--P90
self.p90.stats.recoil = 27

--Bizon
self.coal.AMMO_MAX = 256
self.coal.timers.reload_empty = 1.0
self.coal.timers.reload_not_empty = .75
	
--Mac 10
self.mac10.stats.concealment = 30
	
	
--Assault Rifles



--M14
self.new_m14.AMMO_MAX = 150

--Galant
self.ching.AMMO_MAX = 160

--Eagle Rifle
self.scar.CLIP_AMMO_MAX = 30
self.scar.AMMO_MAX = 240
self.scar.stats.damage = 120
self.scar.FIRE_MODE = "auto"
self.scar.AMMO_PICKUP = {0.85, 3.00}
self.scar.stats.recoil = 10

--little friend
self.contraband.CLIP_AMMO_MAX = 40
self.contraband.AMMO_MAX = 240
self.contraband.stats.damage = 160
self.contraband_m203.damage = 1300
self.contraband.AMMO_PICKUP = {1.50, 2.00}
self.contraband_m203.AMMO_PICKUP = {0.5, 1.50}
self.contraband.stats.concealment = 27
self.contraband.stats.recoil = 27
self.contraband.stats.spread = 27
self.contraband.can_shoot_through_enemy = true
self.contraband.can_shoot_through_wall = true

--Sniper Rifles

--1874 Repeater
self.winchester1874.AMMO_MAX = 90

--SVD
self.siltstone.AMMO_MAX = 100

--Mosin Nagant
self.mosin.AMMO_MAX = 75


--Specials

--OVE9000
self.saw.CLIP_AMMO_MAX = 250
self.saw.AMMO_MAX = 1000
self.saw.AMMO_PICKUP = {.5,1.5}

--Heavy Crossbow
self.arblast.AMMO_MAX = 50
self.arblast.armor_piercing_chance = 1
self.arblast.can_shoot_through_shield = true
self.arblast.can_shoot_through_enemy = true
self.arblast.can_shoot_through_wall = true

--Light Crossbow
self.frankish.AMMO_MAX = 50

--Pistol Crossbow
self.hunter.AMMO_MAX = 50

--M134
self.m134.CLIP_AMMO_MAX = 1000
self.m134.AMMO_MAX = 5000
self.m134.AMMO_PICKUP = {1.0,1.5}
self.m134.stats.recoil = 10
self.m134.stats.spread = 27
self.m134.can_shoot_through_shield = true
self.m134.can_shoot_through_enemy = true
self.m134.can_shoot_through_wall = true
self.m134.penetration_power_mult = 0.70 
self.m134.penetration_damage_mult = 0.50
self.m134.shield_damage_mult = 0.10
self.m134.min_shield_pen_dam = 1
self.m134.armor_piercing_chance = 1

--Puff
self.china.AMMO_MAX = 15
self.m134.AMMO_PICKUP = {.5,.75}

-- Light Machine Guns

-- KSP 58
self.par.stats.damage = 48
self.par.stats.spread = 16
self.par.can_shoot_through_enemy = true
self.par.can_shoot_through_shield = true
self.par.can_shoot_through_wall = true
self.par.penetration_power_mult = 0.70 
self.par.penetration_damage_mult = 0.50
self.par.shield_damage_mult = 0.10
self.par.min_shield_pen_dam = 1
self.par.armor_piercing_chance = 1

-- RPK
self.rpk.stats.damage = 44
self.rpk.stats.spread = 15
self.rpk.can_shoot_through_enemy = true
self.rpk.can_shoot_through_shield = true
self.rpk.can_shoot_through_wall = true
self.rpk.penetration_power_mult = 0.70
self.rpk.penetration_damage_mult = 0.50
self.rpk.shield_damage = 0.10
self.rpk.min_shield_pen_dam = 1
self.rpk.armor_piercing_chance = 1

-- KSP
self.m249.stats.damage = 48
self.m249.stats.spread = 15
self.m249.can_shoot_through_enemy = true
self.m249.can_shoot_through_shield = true
self.m249.can_shoot_through_wall = true
self.m249.penetration_power_mult = 0.70
self.m249.penetration_damage_mult = 0.50
self.m249.shield_damage = 0.10
self.m249.min_shield_pen_dam = 1
self.m249.armor_piercing_chance = 1

-- Brenner 21
self.hk21.stats.damage = 44
self.hk21.stats.spread = 17
self.hk21.can_shoot_through_enemy = true
self.hk21.can_shoot_through_shield = true
self.hk21.can_shoot_through_wall = true
self.hk21.penetration_power_mult = 0.70
self.hk21.penetration_damage_mult = 0.50
self.hk21.shield_damage = 0.10
self.hk21.min_shield_pen_dam = 1
self.hk21.armor_piercing_chance = 1

-- Buzzsaw 42
self.mg42.stats.damage = 42
self.mg42.stats.spread = 15
self.mg42.can_shoot_through_enemy = true
self.mg42.can_shoot_through_shield = true
self.mg42.can_shoot_through_wall = true
self.mg42.penetration_power_mult = 0.70
self.mg42.penetration_damage_mult = 0.50
self.mg42.shield_damage = 0.10
self.mg42.min_shield_pen_dam = 1
self.mg42.armor_piercing_chance = 1


--Melee

--

end