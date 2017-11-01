local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_huskplayermovement_synccallcivilian = HuskPlayerMovement.sync_call_civilian
function HuskPlayerMovement:sync_call_civilian(civilian_unit)
	local peer_id = managers.network:session():peer_by_unit(self._unit):id()
	local hud = managers.hud
	local wp = hud and hud._hud and hud._hud.waypoints["CustomWaypoint_" .. (peer_id == managers.network:session():local_peer():id() and "localplayer" or peer_id)]
	local wp_position = wp and wp.position or nil
	local old_dst = civilian_unit:base().pgt_destination
	local same_dst = wp_position and old_dst and mvector3.equal(wp_position, old_dst)
	civilian_unit:base().pgt_destination = wp_position
	CivilianLogicSurrender.pgt_reset_rebellion(civilian_unit:brain()._logic_data)
	if not same_dst and wp_position and civilian_unit:anim_data().stand then
		CopLogicBase._exit(civilian_unit, "travel")
		return
	end

	pgt_original_huskplayermovement_synccallcivilian(self, civilian_unit)
end
