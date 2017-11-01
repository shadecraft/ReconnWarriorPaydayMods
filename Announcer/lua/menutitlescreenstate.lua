local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local ancr_original_menutitlescreenstate_atenter = MenuTitlescreenState.at_enter
function MenuTitlescreenState:at_enter()
	Announcer:ResetHistory()
	return ancr_original_menutitlescreenstate_atenter(self)
end
