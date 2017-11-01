core:module("CoreWorldDefinition")
WorldDefinition = WorldDefinition or CoreWorldDefinition.WorldDefinition

local WorldDefinition_init = WorldDefinition.init
function WorldDefinition:init(...)
    WorldDefinition_init(self, ...)
    if self._ignore_spawn_list then
        self._ignore_spawn_list[Idstring("units/dev_tools/level_tools/ai_coverpoint"):key()] = true
    end
end

local WorldDefinition_load_world_package = WorldDefinition._load_world_package
function WorldDefinition:_load_world_package(...)
    local level_tweak = _G.tweak_data.levels[Global.level_data.level_id]
    self._has_package = not not level_tweak.package
    if level_tweak.custom_packages then
        self._custom_loaded_packages = {}
        for _, package in pairs(level_tweak.custom_packages) do
            if PackageManager:package_exists(package) and not PackageManager:loaded(package) then
        		PackageManager:load(package)
                log("Loaded package: "..package)
        		table.insert(self._custom_loaded_packages, package)
        	end
        end
    end
    if not self._has_package then
        return
    end
    WorldDefinition_load_world_package(self, ...)
end

local WorldDefinitionunload_packages = WorldDefinition.unload_packages
function WorldDefinition:unload_packages(...)

    if Global.level_data._add then
        Global.level_data._add:Unload()
        Global.level_data._add = nil
    end

    if self._custom_loaded_packages then
        --if not Global.editor_mode then
            for _, pck in pairs(self._custom_loaded_packages) do
                self:_unload_package(pck)
            end
        --end
    end

    if not self._has_package then
        return
    end

    WorldDefinitionunload_packages(self, ...)
end

local WorldDefinition_load_continent_init_package = WorldDefinition._load_continent_init_package
function WorldDefinition:_load_continent_init_package(path, ...)
    if not self._has_package and not PackageManager:package_exists(path) then
        return
    end

    WorldDefinition_load_continent_init_package(self, path, ...)
end

local WorldDefinition_load_continent_package =  WorldDefinition._load_continent_package
function WorldDefinition:_load_continent_package(path, ...)
    if not self._has_package and not PackageManager:package_exists(path) then
        return
    end

    WorldDefinition_load_continent_package(self, path, ...)
end

function WorldDefinition:convert_mod_path(path)
    local level_tweak = _G.tweak_data.levels[Global.level_data.level_id]
    if BeardLib.current_level and level_tweak.custom and path and string.begins(path, ".map/") then
        path = path:gsub(".map", _G.Path:Combine("levels/mods/", BeardLib.current_level._config.id))
    end
    if not PackageManager:has(Idstring("environment"), path:id()) then
        return "core/environments/default"
    end
    return path
end

local WorldDefinition_create_environment = WorldDefinition._create_environment
function WorldDefinition:_create_environment(data, offset, ...)
    data.environment_values.environment = self:convert_mod_path(data.environment_values.environment)
    for _, area in pairs(data.environment_areas) do
        if type(area) == "table" and area.environment then
            area.environment = self:convert_mod_path(area.environment)
        end
    end
    local shape_data
    if data.dome_occ_shapes and data.dome_occ_shapes[1] and data.dome_occ_shapes[1].world_dir then
        shape_data = data.dome_occ_shapes[1]
        data.dome_occ_shapes = nil
    end

    WorldDefinition_create_environment(self, data, offset, ...)

	if shape_data then
		local corner = shape_data.position
		local size = Vector3(shape_data.depth, shape_data.width, shape_data.height)
		local texture_name = shape_data.world_dir .. "cube_lights/" .. "dome_occlusion"
		if not DB:has(Idstring("texture"), Idstring(texture_name)) then
			Application:error("Dome occlusion texture doesn't exists, probably needs to be generated", texture_name)
		else
			managers.environment_controller:set_dome_occ_params(corner, size, texture_name)
		end
	end
end