local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_playerstandard_getintimidationaction = PlayerStandard._get_intimidation_action
function PlayerStandard:_get_intimidation_action(prime_target, char_table, amount, primary_only, detect_only, secondary)
	if prime_target and prime_target.unit and prime_target.unit:base() and prime_target.unit:base().pgt_is_being_moved == self._unit then
		local wp = managers.hud and managers.hud._hud and managers.hud._hud.waypoints["CustomWaypoint_localplayer"]
		local wp_position = wp and wp.position or nil
		local old_dst = prime_target.unit:base().pgt_destination
		local same_dst = wp_position and old_dst and mvector3.equal(wp_position, old_dst)
		prime_target.unit:base().pgt_destination = wp_position

		local do_intimidate
		local t = TimerManager:game():time()
		if not self._intimidate_t or t - self._intimidate_t > tweak_data.player.movement_state.interaction_delay then
			do_intimidate = true
			if Network:is_server() then
				CivilianLogicSurrender.pgt_reset_rebellion(prime_target.unit:brain()._logic_data)
			else
				managers.network:session():send_to_host("long_dis_interaction", prime_target.unit, 0, self._unit, false)
			end
		end

		if wp_position then
			if do_intimidate then
				self._intimidate_t = t
				self:say_line("g18", managers.groupai:state():whisper_mode())
				if not self:_is_using_bipod() then
					self:_play_distance_interact_redirect(t, "cmd_gogo")
				end
				if not same_dst and Network:is_server() then
					CopLogicBase._exit(prime_target.unit, "travel")
				end
			end
			return "mic_boost", false, prime_target -- will do nothing
		else
			return "come", false, prime_target
		end
	end

	return pgt_original_playerstandard_getintimidationaction(self, prime_target, char_table, amount, primary_only, detect_only, secondary)
end

