local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.FadingContour = _G.FadingContour or {}
FadingContour._path = ModPath
FadingContour._data_path = SavePath .. 'fading_contour.txt'
FadingContour.FadeModifier = FadingContour.FadeSquareRoot
FadingContour.sync_contour = 'medic_heal'
FadingContour.settings = {
	fade_from = 1,
	fade_method = 2
}

-- fade_level: float from 0 to 1
local sync_history = {}
function FadingContour.SynchronizeFadeLevel(unit, fade_level, forced)
	fade_level = math.ceil(fade_level * 8)

	local u_key = unit:key()
	if not forced and fade_level == sync_history[u_key] then
		return
	end
	sync_history[u_key] = fade_level

	local session = managers.network:session()
	if session then
		session:send_to_peers_synched('sync_contour_state', unit, unit:id(), FadingContour.sync_contour_index, false, fade_level)
	end
end

function FadingContour:FadeLinear(dt_end, dt_now, duration)
	return (dt_end - dt_now) / (duration * self.settings.fade_from)
end

function FadingContour:FadeSquareRoot(dt_end, dt_now, duration)
	return math.sqrt(self:FadeLinear(dt_end, dt_now, duration))
end

function FadingContour:SetModifier()
	if self.settings.fade_method == 1 then
		self.FadeModifier = self.FadeLinear
	else
		self.FadeModifier = self.FadeSquareRoot
	end
end

function FadingContour:Load()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all'))) do
			self.settings[k] = v
		end
		file:close()
	end
	FadingContour:SetModifier()
end

function FadingContour:Save()
	local file = io.open(self._data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_FadingContour', function(loc)
	for _, filename in pairs(file.GetFiles(FadingContour._path .. 'loc/')) do
		local str = filename:match('^(.*).txt$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			loc:load_localization_file(FadingContour._path .. 'loc/' .. filename)
			break
		end
	end
	
	loc:load_localization_file(FadingContour._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_FadingContour', function(menu_manager)
	MenuCallbackHandler.FadingContourFadeMethod = function(this, item)
		FadingContour.settings.fade_method = tonumber(item:value())
		FadingContour:SetModifier()
	end

	MenuCallbackHandler.FadingContourFadeFrom = function(self, item)
		FadingContour.settings.fade_from = item:value()
	end

	MenuCallbackHandler.FadingContourSave = function(this, item)
		FadingContour:Save()
	end

	FadingContour:Load()
	MenuHelper:LoadFromJsonFile(FadingContour._path .. 'menu/options.txt', FadingContour, FadingContour.settings)
end)

