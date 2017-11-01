local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_ANCR', function(loc)
	for _, filename in pairs(file.GetFiles(Announcer._path .. 'loc/')) do
		local str = filename:match('^(.*).txt$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			loc:load_localization_file(Announcer._path .. 'loc/' .. filename)
			break
		end
	end

	loc:load_localization_file(Announcer._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_ANCR', function(menu_manager)

	MenuCallbackHandler.AnnouncerSetDontBotherSteamFriends = function(this, item)
		Announcer.settings.dont_bother_steam_friends = item:value() == 'on'
	end

	MenuCallbackHandler.AnnouncerSetKeepQuiet = function(this, item)
		Announcer.settings.keep_quiet = item:value() == 'on'
	end

	MenuCallbackHandler.AnnouncerSave = function(this, item)
		Announcer:Save()
	end

	Announcer:Load()
	MenuHelper:LoadFromJsonFile(Announcer._path .. 'menu/options.txt', Announcer, Announcer.settings)

end)
