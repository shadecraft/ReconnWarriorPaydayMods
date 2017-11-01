local c_weap_hook = "BeardLibCreateCustomWeapons"
local c_weap_mods_hook = "BeardLibCreateCustomWeaponMods"

Hooks:Register(c_weap_hook)
Hooks:Register(c_weap_mods_hook)

Hooks:PostHook(WeaponFactoryTweakData, "_init_content_unfinished", "CallWeaponFactoryAdditionHooks", function(self)
    Hooks:Call(c_weap_hook, self)
    Hooks:Call(c_weap_mods_hook, self)
end)

BeardLib.managers.MapFramework:RegisterHooks()
BeardLib.managers.AddFramework:RegisterHooks()

function HudIconsTweakData:get_icon_data(icon_id, default_rect)
	local icon_data = tweak_data.hud_icons[icon_id]
	local icon = icon_data and icon_data.texture or icon_id
	local texture_rect
	if not icon_data or not icon_data.custom then
		texture_rect = icon_data and icon_data.texture_rect or default_rect or {
			0,
			0,
			48,
			48
		}
	end
	return icon, texture_rect
end
 