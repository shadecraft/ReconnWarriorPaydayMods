local DIYSK_tier1 = {
	"DIYSK_combat_medic",
    "DIYSK_triathlete",
    "DIYSK_stable_shot",
    "DIYSK_underdog",
    "DIYSK_oppressor",
    "DIYSK_scavenging",
    "DIYSK_defense_up",
    "DIYSK_hardware_expert",
    "DIYSK_steady_grip",
    "DIYSK_jail_workout",
    "DIYSK_sprinter",
    "DIYSK_scavenger",
    "DIYSK_equilibrium",
    "DIYSK_nine_lives",
    "DIYSK_martial_arts"
}

local DIYSK_tier2_L = {
	"DIYSK_tea_time",
	"DIYSK_cable_guy",
	"DIYSK_rifleman",
	"DIYSK_shotgun_cqb",
	"DIYSK_show_of_force",
	"DIYSK_ammo_reservoir",
	"DIYSK_sentry_targeting_package",
	"DIYSK_combat_engineering",
	"DIYSK_heavy_impact",
	"DIYSK_cleaner",
	"DIYSK_awareness",
	"DIYSK_optic_illusions",
	"DIYSK_dance_instructor",
	"DIYSK_running_from_death",
	"DIYSK_bloodthirst"
}

local DIYSK_tier2_R = {
	"DIYSK_fast_learner",
	"DIYSK_joker",
	"DIYSK_sharpshooter",
	"DIYSK_shotgun_impact",
	"DIYSK_pack_mule",
	"DIYSK_portable_saw",
	"DIYSK_eco_sentry",
	"DIYSK_drill_expert",
	"DIYSK_fire_control",
	"DIYSK_chameleon",
	"DIYSK_thick_skin",
	"DIYSK_silence_expert",
	"DIYSK_akimbo",
	"DIYSK_up_you_go",
	"DIYSK_steroids"
}

local DIYSK_tier3_L = {
	"DIYSK_tea_cookies",
	"DIYSK_stockholm_syndrome",
	"DIYSK_spotter_teamwork",
	"DIYSK_far_away",
	"DIYSK_iron_man",
	"DIYSK_ammo_2x",
	"DIYSK_engineering",
	"DIYSK_more_fire_power",
	"DIYSK_shock_and_awe",
	"DIYSK_second_chances",
	"DIYSK_dire_need",
	"DIYSK_backstab",
	"DIYSK_gun_fighter",
	"DIYSK_perseverance",
	"DIYSK_drop_soap"
}

local DIYSK_tier3_R = {
	"DIYSK_medic_2x",
	"DIYSK_control_freak",
	"DIYSK_speedy_reload",
	"DIYSK_close_by",
	"DIYSK_prison_wife",
	"DIYSK_carbon_blade",
	"DIYSK_jack_of_all_trades",
	"DIYSK_kick_starter",
	"DIYSK_fast_fire",
	"DIYSK_ecm_booster",
	"DIYSK_insulation",
	"DIYSK_hitman",
	"DIYSK_expert_handling",
	"DIYSK_feign_death",
	"DIYSK_wolverine"
}

local DIYSK_tier4 = {
	"DIYSK_inspire",
	"DIYSK_black_marketeer",
	"DIYSK_single_shot_ammo_return",
	"DIYSK_overkill",
	"DIYSK_juggernaut",
	"DIYSK_bandoliers",
	"DIYSK_tower_defense",
	"DIYSK_fire_trap",
	"DIYSK_body_expertise",
	"DIYSK_ecm_2x",
	"DIYSK_jail_diet",
	"DIYSK_unseen_strike",
	"DIYSK_trigger_happy",
	"DIYSK_messiah",
	"DIYSK_frenzy"
}

local function find_DIYSK_1 (tab, val)
	    for key, value in ipairs(tab) do
	        if value.name_id == val then
	        	value.tiers = {
					{
						DIYSK_tier1[MenuDIYST._data.DIYST_m_1_1_val]
					},
					{
						DIYSK_tier2_L[MenuDIYST._data.DIYST_m_1_2_L_val],
						DIYSK_tier2_R[MenuDIYST._data.DIYST_m_1_2_R_val]
					},
					{
						DIYSK_tier3_L[MenuDIYST._data.DIYST_m_1_3_L_val],
						DIYSK_tier3_R[MenuDIYST._data.DIYST_m_1_3_R_val]
					},
					{
						DIYSK_tier4[MenuDIYST._data.DIYST_m_1_4_val]
					}
					}
	            return true
	        end
	    end
	    return false
	end

local function find_DIYSK_2 (tab, val)
	    for key, value in ipairs(tab) do
	        if value.name_id == val then
	        	value.tiers = {
						{
							DIYSK_tier1[MenuDIYST._data.DIYST_m_2_1_val]
						},
						{
							DIYSK_tier2_L[MenuDIYST._data.DIYST_m_2_2_L_val],
							DIYSK_tier2_R[MenuDIYST._data.DIYST_m_2_2_R_val]
						},
						{
							DIYSK_tier3_L[MenuDIYST._data.DIYST_m_2_3_L_val],
							DIYSK_tier3_R[MenuDIYST._data.DIYST_m_2_3_R_val]
						},
						{
							DIYSK_tier4[MenuDIYST._data.DIYST_m_2_4_val]
						}
					}
	            return true
	        end
	    end
	    return false
	end

local function find_DIYSK_3 (tab, val)
	    for key, value in ipairs(tab) do
	        if value.name_id == val then
	        	value.tiers = {
					{
						DIYSK_tier1[MenuDIYST._data.DIYST_m_3_1_val]
					},
					{
						DIYSK_tier2_L[MenuDIYST._data.DIYST_m_3_2_L_val],
						DIYSK_tier2_R[MenuDIYST._data.DIYST_m_3_2_R_val]
					},
					{
						DIYSK_tier3_L[MenuDIYST._data.DIYST_m_3_3_L_val],
						DIYSK_tier3_R[MenuDIYST._data.DIYST_m_3_3_R_val]
					},
					{
						DIYSK_tier4[MenuDIYST._data.DIYST_m_3_4_val]
					}
					}
	            return true
	        end
	    end
	    return false
	end


check_once = false

local data = SkillTreeTweakData.init
function SkillTreeTweakData:init(tweak_data)
	data(self, tweak_data)
	local digest = function(value)
		return Application:digest_value(value, true)
	end
	self.tier_unlocks = {
		digest(0),
		digest(1),
		digest(3),
		digest(18)
	}

	log("DIYSK_init")

	if not check_once then
		for key, value in pairs(self.skills) do -- pairs get also not numeric keys
			log(tostring(key))
			if string.sub(key, 1, 6) ~= 'DIYSK_' then
				self.skills["DIYSK_"..tostring(key)] = self.skills[key]
				log('done')
			end
		end
		log('Double_check')
		for key, value in pairs(self.skills) do -- pairs get also not numeric keys
			if string.sub(key, 1, 6) ~= 'DIYSK_' then
				self.skills["DIYSK_"..tostring(key)] = self.skills[key]
				log(tostring(key))
				log('done')
			end
		end
		check_once = true
	end
	local function contain_my_skilltree (tab, val)
		    for index, value in ipairs(tab) do
		        if value == val then
		            return true
		        end
		    end
		    return false
		end
		if not contain_my_skilltree(self.skill_pages_order,"DIYSK") then
			
			table.insert(self.skill_pages_order,"DIYSK")

			self.skilltree.DIYSK = {
				name_id = "DIYSK_skilltree",
				desc_id = "DIYSK_skilltree_desc"
			}
		end

		-- This is for insert our skill tre in main tree
		table.insert(self.trees,{
					name_id = "DIYSK_tree_1",-- id for localization
					background_texture = "guis/textures/pd2/skilltree/bg_mastermind",
					unlocked = true,
					skill = "DIYSK", -- the name of your skilltree
					tiers = {
								{
									"DIYSK_combat_medic"
								},
								{
									"DIYSK_tea_time",
									"DIYSK_fast_learner"
								},
								{
									"DIYSK_tea_cookies",
									"DIYSK_medic_2x"
								},
								{"DIYSK_inspire"}
							}
					})

		table.insert(self.trees,{
					name_id = "DIYSK_tree_2",-- id for localization
					background_texture = "guis/textures/pd2/skilltree/bg_mastermind",
					unlocked = true,
					skill = "DIYSK", -- the name of your skilltree
					tiers = {
								{
									"DIYSK_combat_medic"
								},
								{
									"DIYSK_tea_time",
									"DIYSK_fast_learner"
								},
								{
									"DIYSK_tea_cookies",
									"DIYSK_medic_2x"
								},
								{"DIYSK_inspire"}
							}
					})

		table.insert(self.trees,{
					name_id = "DIYSK_tree_3",-- id for localization
					background_texture = "guis/textures/pd2/skilltree/bg_mastermind",
					unlocked = true,
					skill = "DIYSK", -- the name of your skilltree
					tiers = {
								{
									"DIYSK_combat_medic"
								},
								{
									"DIYSK_tea_time",
									"DIYSK_fast_learner"
								},
								{
									"DIYSK_tea_cookies",
									"DIYSK_medic_2x"
								},
								{"DIYSK_inspire"}
							}
					})		


	self.skills.DIYSK_inspire = {
		["name_id"] = "menu_inspire_beta",
		["desc_id"] = "menu_inspire_beta_desc",
		["icon_xy"] = {4, 9},
		[1] = {
			upgrades = {
				"player_revive_interaction_speed_multiplier",
				"player_morale_boost"
			},
			cost = self.costs.hightier
		},
		[2] = {
			upgrades = {
				"cooldown_long_dis_revive"
			},
			cost = self.costs.hightierpro
		}
	}

	--[[ -- Debug part
		log("DIYSK_tiers")
		for key, value in pairs(self.trees) do -- pairs get also not numeric keys
			table.insert(DIYSK_tier2_L, value.tiers[2][1])

			table.insert(DIYSK_tier2_R, value.tiers[2][2])

			table.insert(DIYSK_tier3_L, value.tiers[3][1])

			table.insert(DIYSK_tier3_R, value.tiers[3][2])

			table.insert(DIYSK_tier4,   value.tiers[4][1])
		end

		var = ""
		for key, value in pairs(DIYSK_tier2_L) do 
			var = var .. "," .. value .. ","
		end

		log('DIYSK_tier2_L')
		log(var)

		var = ""
		for key, value in pairs(DIYSK_tier2_R) do 
			var = var .. "," .. value .. ","
		end

		log('DIYSK_tier2_R')
		log(var)

		var = ""
		for key, value in pairs(DIYSK_tier3_L) do 
			var = var .. "," .. value .. ","
		end

		log('DIYSK_tier3_L')
		log(var)

		var = ""
		for key, value in pairs(DIYSK_tier3_R) do 
			var = var .. "," .. value .. ","
		end

		log('DIYSK_tier3_R')
		log(var)

		var = ""
		for key, value in pairs(DIYSK_tier4) do 
			var = var .. "," .. value .. ","
		end

		log('DIYSK_tier4')
		log(var)
	]]


end

function SkillTreeTweakData:refresh_DIYST()
	log('DIYSK_refresh:')
	log(tostring(find_DIYSK_1(self.trees ,"DIYSK_tree_1")))
	log(tostring(find_DIYSK_2(self.trees ,"DIYSK_tree_2")))
	log(tostring(find_DIYSK_3(self.trees ,"DIYSK_tree_3")))
end