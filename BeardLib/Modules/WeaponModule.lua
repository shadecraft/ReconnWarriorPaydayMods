WeaponModule = WeaponModule or class(ItemModuleBase)
WeaponModule.type_name = "Weapon"

function WeaponModule:init(core_mod, config)
    self.required_params = {}
    self.clean_table = table.add(clone(self.clean_table), {
        {
            param = "weapon.kick",
            action = "remove_metas"
        },
        {
            param = "weapon.crosshair",
            action = "remove_metas"
        },
        {
            param = "weapon.stats",
            action = "remove_metas"
        },
        {
            param = "factory.default_blueprint",
            action = "remove_metas"
        },
        {
            param = "factory.uses_parts",
            action = "remove_metas"
        },
        {
            param = "factory.optional_types",
            action = "remove_metas"
        },
        {
            param = "factory.animations",
            action = "remove_metas"
        },
        {
            param = "factory.override",
            action = {"remove_metas", "no_number_indexes"}
        },
        {
            param = "factory.adds",
            action = {"remove_metas", "no_number_indexes"}
        }
    })
    if not WeaponModule.super.init(self, core_mod, config) then
        return false
    end

    return true
end

function WeaponModule:RegisterHook()
    local dlc = self._config.dlc or self.defaults.dlc
    self._config.unlock_level = self._config.unlock_level or 1

    --Old eh? lets convert it!
    if not self._config.weapon and not self._config.factory and self._config.fac_id then
        self:ConvertOldToNew()
    end

    for _, param in pairs({"weapon", "factory", "weapon.id", "factory.id"}) do
        if BeardLib.Utils:StringToTable(param, self._config, true) == nil then
            self:log("[ERROR] Parameter '%s' is required!", param)
            return false
        end
    end

    Hooks:PostHook(WeaponTweakData, "_init_new_weapons", self._config.weapon.id .. "AddWeaponTweakData", function(w_self, autohit_rifle_default, autohit_pistol_default, autohit_shotgun_default, autohit_lmg_default, autohit_snp_default, autohit_smg_default, autohit_minigun_default, damage_melee_default, damage_melee_effect_multiplier_default, aim_assist_rifle_default, aim_assist_pistol_default, aim_assist_shotgun_default, aim_assist_lmg_default, aim_assist_snp_default, aim_assist_smg_default, aim_assist_minigun_default)
        local config = self._config.weapon

        if w_self[config.id] then
            self:log("[ERROR] Weapon with id '%s' already exists!", config.id)
            return
        end

        local default_autohit = {
            rifle = autohit_rifle_default,
            pistol = autohit_pistol_default,
            shotgun = autohit_shotgun_default,
            lmg = autohit_lmg_default,
            snp = autohit_snp_default,
            smg = autohit_smg_default,
            minigun = autohit_minigun_default,
        }

        local default_aim_assist = {
            rifle = aim_assist_rifle_default,
            pistol = aim_assist_pistol_default,
            shotgun = aim_assist_shotgun_default,
            lmg = aim_assist_lmg_default,
            snp = aim_assist_snp_default,
            smg = aim_assist_smg_default,
            minigun = aim_assist_minigun_default,
        }

        local data = table.merge(deep_clone(config.based_on and (w_self[config.based_on] ~= nil and w_self[config.based_on]) or w_self.glock_17), table.merge({
            name_id = "bm_w_" .. config.id,
            desc_id = "bm_w_" .. config.id .. "_desc",
            description_id = "des_" .. config.id,
            autohit = default_autohit[config.default_autohit],
            aim_assist = default_aim_assist[config.default_aim_assist],
            damage_melee = damage_melee_default,
            damage_melee_effect_mul = damage_melee_effect_multiplier_default,
            global_value = self.defaults.global_value,
            custom = true
        }, config))
        data.AMMO_MAX = data.CLIP_AMMO_MAX * data.NR_CLIPS_MAX
        data.AMMO_PICKUP = config.ammo_pickup and w_self:_pickup_chance(data.AMMO_MAX, config.ammo_pickup) or data.AMMO_PICKUP
        data.npc = nil
        data.override = nil

        if config.override then
            data = table.merge(data, config.override)
        end

        w_self[config.id] = data
    end)

    Hooks:Add("BeardLibCreateCustomWeapons", self._config.factory.id .. "AddWeaponFactoryTweakData", function(w_self)
        local config = self._config.factory
        if w_self[config.id] then
            self:log("[ERROR] Weapon with factory id '%s' already exists!", config.id)
            return
        end

        local data = table.merge({
            custom = true
        }, config)
        data.override = nil

        if config.override then
            data = table.merge(data, config.override)
        end

        w_self[config.id] = data
        w_self[config.id .. "_npc"] = table.merge(clone(data), {unit = config.unit .. "_npc"})
    end)

    Hooks:PostHook(UpgradesTweakData, "init", self._config.weapon.id .. "AddWeaponUpgradesData", function(u_self)
        u_self.definitions[self._config.weapon.id] = {
            category = "weapon",
            weapon_id = self._config.weapon.id,
            factory_id = self._config.factory.id,
            dlc = dlc
        }
        if self._config.unlock_level then
            u_self.level_tree[self._config.unlock_level] = u_self.level_tree[self._config.unlock_level] or {upgrades={}, name_id="weapons"}
            table.insert(u_self.level_tree[self._config.unlock_level].upgrades, self._config.weapon.id)
        end
    end)

    Hooks:PostHook(PlayerTweakData, "_init_new_stances", self._config.weapon.id .. "AddWeaponStancesData", function(p_self)
        local stance_data = self._config.stance or {}
        p_self.stances[self._config.weapon.id] = table.merge(deep_clone(stance_data.based_on and (p_self.stances[stance_data.based_on] ~= nil and p_self.stances[stance_data.based_on]) or self._config.weapon.based_on and (p_self.stances[self._config.weapon.based_on] ~= nil and p_self.stances[self._config.weapon.based_on]) or p_self.stances.glock_17), stance_data)
    end)
end

function WeaponModule:ConvertOldToNew()
    self:log("Converting weapon module from old to new(It's recommended to update the module)")
    local anims = self._config.animations and BeardLib.Utils:RemoveMetas(self._config.animations)
    self._config.weapon = {
        id = self._config.id,
        based_on = self._config.based_on,
        default_autohit = self._config.autohit,
        default_aim_assist = self._config.aim_assist,
        damage_melee = self._config.damage_melee,
        damage_melee_effect_mul = self._config.damage_melee_effect_mul,
        global_value = self._config.global_value,
        override = self._config.merge_data,          
        muzzleflash = self._config.muzzleflash,
        shell_ejection = self._config.shell_ejection,
        use_data = self._config.use_data,
        DAMAGE = self._config.DAMAGE,
        damage_near = self._config.damage_near,
        damage_far = self._config.damage_far,
        shake = self._config.shake,
        weapon_hold = self._config.weapon_hold,
        rays = self._config.rays,
        CLIP_AMMO_MAX = self._config.CLIP_AMMO_MAX,
        NR_CLIPS_MAX = self._config.NR_CLIPS_MAX,
        FIRE_MODE = self._config.FIRE_MODE,
        fire_mode_data = self._config.fire_mode_data,
        single = self._config.single,
        spread = self._config.spread,
        category = self._config.category,
        sub_category = self._config.sub_category,
        sounds = self._config.sounds,
        timers = self._config.timers,
        cam_animations = self._config.cam_animations,
        animations = anims,
        texture_bundle_folder = self._config.texture_bundle_folder,
        panic_suppression_chance = self._config.panic_suppression_chance,
        kick = self._config.kick and BeardLib.Utils:RemoveMetas(self._config.kick),
        crosshair = self._config.crosshair and BeardLib.Utils:RemoveMetas(self._config.crosshair),            
        stats = self._config.stats and BeardLib.Utils:RemoveMetas(self._config.stats),
    }
    self._config.factory = {
        id = self._config.fac_id,
        unit = self._config.unit,
        default_blueprint = self._config.default_blueprint and BeardLib.Utils:RemoveMetas(self._config.default_blueprint),
        uses_parts = self._config.uses_parts and BeardLib.Utils:RemoveMetas(self._config.uses_parts),
        optional_types = self._config.optional_types and BeardLib.Utils:RemoveMetas(self._config.optional_types),
        animations = anims,
        override = self._config.fac_merge_data and BeardLib.Utils:RemoveMetas(BeardLib.Utils:RemoveAllNumberIndexes(self._config.override)),
        adds = self._config.adds and BeardLib.Utils:RemoveMetas(BeardLib.Utils:RemoveAllNumberIndexes(self._config.adds)),
    }
    --now those are useless.
    --weapon
    self._config.id = nil
    self._config.based_on = nil
    self._config.autohit  = nil
    self._config.aim_assist = nil
    self._config.damage_melee  = nil
    self._config.damage_melee_effect_mul = nil 
    self._config.global_value = nil
    self._config.merge_data,          
    self._config.muzzleflash = nil
    self._config.shell_ejection = nil
    self._config.use_data = nil
    self._config.DAMAGE = nil
    self._config.damage_near = nil
    self._config.damage_far = nil
    self._config.kick = nil
    self._config.crosshair = nil
    self._config.shake = nil
    self._config.weapon_hold = nil
    self._config.cam_animations = nil
    self._config.texture_bundle_folder = nil
    self._config.panic_suppression_chance = nil
    self._config.stats = nil
    self._config.rays = nil
    self._config.CLIP_AMMO_MAX = nil
    self._config.NR_CLIPS_MAX = nil
    self._config.FIRE_MODE = nil
    self._config.fire_mode_data = nil
    self._config.single = nil
    self._config.spread = nil
    self._config.category = nil
    self._config.sub_category = nil
    self._config.sounds = nil
    self._config.timers = nil
    --factory
    self._config.override = nil
    self._config.unit = nil
    self._config.default_blueprint = nil
    self._config.uses_parts = nil
    self._config.optional_types = nil
    self._config.animations = nil
    self._config.fac_id = nil
    self._config.adds = nil
end

WeaponModuleNew = WeaponModuleNew or class(WeaponModule) --Kept for backwards compatibility
WeaponModuleNew.type_name = "WeaponNew"

BeardLib:RegisterModule(WeaponModule.type_name, WeaponModule)
BeardLib:RegisterModule(WeaponModuleNew.type_name, WeaponModuleNew)
