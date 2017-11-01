local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_copbrain_onintimidated = CopBrain.on_intimidated
function CopBrain:on_intimidated(amount, aggressor_unit)
	if aggressor_unit and self._unit:base().pgt_is_being_moved == aggressor_unit then
		local peer_id = managers.network:session():peer_by_unit(aggressor_unit):id()
		local hud = managers.hud
		local wp = hud and hud._hud and hud._hud.waypoints["CustomWaypoint_" .. (peer_id == managers.network:session():local_peer():id() and "localplayer" or peer_id)]
		local wp_position = wp and wp.position or nil
		local old_dst = self._unit:base().pgt_destination
		local same_dst = wp_position and old_dst and mvector3.equal(wp_position, old_dst)
		self._unit:base().pgt_destination = wp_position
		CivilianLogicSurrender.pgt_reset_rebellion(self._logic_data)
		if not same_dst and self._unit:anim_data().stand then
			self:set_logic("travel")
		end
		return
	end

	return pgt_original_copbrain_onintimidated(self, amount, aggressor_unit)
end

local pgt_original_copbrain_searchforcoarsepath = CopBrain.search_for_coarse_path
function CopBrain:search_for_coarse_path(search_id, to_seg, verify_clbk, access_neg)
	local pgt_destination = self._unit:base().pgt_destination
	if pgt_destination then
		to_seg = managers.navigation:get_nav_seg_from_pos(pgt_destination, true)
	end
	return pgt_original_copbrain_searchforcoarsepath(self, search_id, to_seg, verify_clbk, access_neg)
end
