local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_civilianlogictravel_enter = CivilianLogicTravel.enter
function CivilianLogicTravel.enter(data, new_logic_name, enter_params)
	local old_data = data.internal_data
	pgt_original_civilianlogictravel_enter(data, new_logic_name, enter_params)
	local my_data = data.internal_data
	my_data.rebellion_meter = old_data.rebellion_meter
	my_data.check_surroundings_t = old_data.check_surroundings_t
end

local pgt_original_civilianlogictravel_determineexactdestination = CivilianLogicTravel._determine_exact_destination
function CivilianLogicTravel._determine_exact_destination(data, objective)
	return data.unit:base().pgt_destination or pgt_original_civilianlogictravel_determineexactdestination(data, objective)
end

local pgt_original_civilianlogictravel_onalert = CivilianLogicTravel.on_alert
function CivilianLogicTravel.on_alert(data, alert_data)
	if data.unit:base().pgt_is_being_moved then
		CivilianLogicSurrender.pgt_on_alert(data, alert_data)
	else
		pgt_original_civilianlogictravel_onalert(data, alert_data)
	end
end

local pgt_original_civilianlogictravel_update = CivilianLogicTravel.update
function CivilianLogicTravel.update(data)
	local my_data = data.internal_data
	if my_data.coarse_path and my_data.coarse_path_index >= #my_data.coarse_path and data.unit:base().pgt_destination then
		data.brain:on_hostage_move_interaction(nil, "stay")
		return
	end

	pgt_original_civilianlogictravel_update(data)
end
