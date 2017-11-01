_G.MenuDIYST = _G.MenuDIYST or {}
MenuDIYST._path = ModPath
MenuDIYST._data_path = ModPath .. "/save/MenuDIYST_options.txt"
MenuDIYST._data = {}

function MenuDIYST:Save()
	local file = io.open( self._data_path, "w+" )
	if file then
		file:write( json.encode( self._data ) )
		file:close()
	end
end
function MenuDIYST:Load()
	local file = io.open( self._data_path, "r" )
	if file then
		self._data = json.decode( file:read("*all") )
		file:close()
		if self._data.DIYST_tg_1_val == nil then self._data.DIYST_tg_1_val = true end
		if self._data.DIYST_m_1_1_val == nil then self._data.DIYST_m_1_1_val = 1 end
		if self._data.DIYST_m_1_2_L_val == nil then self._data.DIYST_m_1_2_L_val = 2 end
		if self._data.DIYST_m_1_2_R_val == nil then self._data.DIYST_m_1_2_R_val = 3 end
		if self._data.DIYST_m_1_3_L_val == nil then self._data.DIYST_m_1_3_L_val = 4 end
		if self._data.DIYST_m_1_3_R_val == nil then self._data.DIYST_m_1_3_R_val = 5 end
		if self._data.DIYST_m_1_4_val == nil then self._data.DIYST_m_1_4_val = 6 end

		if self._data.DIYST_m_2_1_val == nil then self._data.DIYST_m_2_1_val = 1 end
		if self._data.DIYST_m_2_2_L_val == nil then self._data.DIYST_m_2_2_L_val = 2 end
		if self._data.DIYST_m_2_2_R_val == nil then self._data.DIYST_m_2_2_R_val = 3 end
		if self._data.DIYST_m_2_3_L_val == nil then self._data.DIYST_m_2_3_L_val = 4 end
		if self._data.DIYST_m_2_3_R_val == nil then self._data.DIYST_m_2_3_R_val = 5 end
		if self._data.DIYST_m_2_4_val == nil then self._data.DIYST_m_2_4_val = 6 end

		if self._data.DIYST_m_3_1_val == nil then self._data.DIYST_m_3_1_val = 1 end
		if self._data.DIYST_m_3_2_L_val == nil then self._data.DIYST_m_3_2_L_val = 2 end
		if self._data.DIYST_m_3_2_R_val == nil then self._data.DIYST_m_3_2_R_val = 3 end
		if self._data.DIYST_m_3_3_L_val == nil then self._data.DIYST_m_3_3_L_val = 4 end
		if self._data.DIYST_m_3_3_R_val == nil then self._data.DIYST_m_3_3_R_val = 5 end
		if self._data.DIYST_m_3_4_val == nil then self._data.DIYST_m_3_4_val = 6 end
		MenuDIYST:Save()
	end
end
Hooks:Add("MenuManagerInitialize", "MenuDIYST_MenuManagerInitialize", function(menu_manager)
	MenuCallbackHandler.MenuDIYST_save = function(self, item)
		MenuDIYST:Save()
	end	
	MenuCallbackHandler.DIYST_tg_1_func = function(self, item)
		-- Do notthing i'm just a friendly remider
	end
		-- Skill 1
	MenuCallbackHandler.DIYST_m_1_1_func = function(self, item)
		MenuDIYST._data.DIYST_m_1_1_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end	
	MenuCallbackHandler.DIYST_m_1_2_L_func = function(self, item)
		MenuDIYST._data.DIYST_m_1_2_L_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end
	MenuCallbackHandler.DIYST_m_1_2_R_func = function(self, item)
		MenuDIYST._data.DIYST_m_1_2_R_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end	
	MenuCallbackHandler.DIYST_m_1_3_L_func = function(self, item)
		MenuDIYST._data.DIYST_m_1_3_L_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end
	MenuCallbackHandler.DIYST_m_1_3_R_func = function(self, item)
		MenuDIYST._data.DIYST_m_1_3_R_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end
	MenuCallbackHandler.DIYST_m_1_4_func = function(self, item)
		MenuDIYST._data.DIYST_m_1_4_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end

	-- Skill 2
	MenuCallbackHandler.DIYST_m_2_1_func = function(self, item)
		MenuDIYST._data.DIYST_m_2_1_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end	
	MenuCallbackHandler.DIYST_m_2_2_L_func = function(self, item)
		MenuDIYST._data.DIYST_m_2_2_L_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end
	MenuCallbackHandler.DIYST_m_2_2_R_func = function(self, item)
		MenuDIYST._data.DIYST_m_2_2_R_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end	
	MenuCallbackHandler.DIYST_m_2_3_L_func = function(self, item)
		MenuDIYST._data.DIYST_m_2_3_L_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end
	MenuCallbackHandler.DIYST_m_2_3_R_func = function(self, item)
		MenuDIYST._data.DIYST_m_2_3_R_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end
	MenuCallbackHandler.DIYST_m_2_4_func = function(self, item)
		MenuDIYST._data.DIYST_m_2_4_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end

	-- Skill 3
	MenuCallbackHandler.DIYST_m_3_1_func = function(self, item)
		MenuDIYST._data.DIYST_m_3_1_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end	
	MenuCallbackHandler.DIYST_m_3_2_L_func = function(self, item)
		MenuDIYST._data.DIYST_m_3_2_L_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end
	MenuCallbackHandler.DIYST_m_3_2_R_func = function(self, item)
		MenuDIYST._data.DIYST_m_3_2_R_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end	
	MenuCallbackHandler.DIYST_m_3_3_L_func = function(self, item)
		MenuDIYST._data.DIYST_m_3_3_L_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end
	MenuCallbackHandler.DIYST_m_3_3_R_func = function(self, item)
		MenuDIYST._data.DIYST_m_3_3_R_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end
	MenuCallbackHandler.DIYST_m_3_4_func = function(self, item)
		MenuDIYST._data.DIYST_m_3_4_val = item:value()
		tweak_data.skilltree:refresh_DIYST()
	end														
	MenuDIYST:Load()
	tweak_data.skilltree:refresh_DIYST()
	MenuHelper:LoadFromJsonFile(MenuDIYST._path .. "/options.txt", MenuDIYST, MenuDIYST._data)
end )

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_MenuDIYST", function( loc )
	loc:load_localization_file( MenuDIYST._path .. "en.txt")
end)