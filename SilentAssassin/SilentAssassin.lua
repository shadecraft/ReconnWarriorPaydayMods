-------------------------------------------------
--  Menu Logic
-------------------------------------------------
_G.SilentAssassin = _G.SilentAssassin or {}
SilentAssassin._path = ModPath
SilentAssassin._data_path = SavePath .. "silentassassin.txt"
-- num_pagers -> number of pagers allowed.
-- num_pagers_per_player -> maximum number of pagers a single
--  player may use
SilentAssassin.settings = {}
-- I can't get at the player unit at the end game screen. (or at least I don't
-- know how)  So store the local pagers used here.  It'll be easier if I end
-- up having to sync the pagers used to the clients anyway.
SilentAssassin.localPagersUsed = 0

--Loads the options from blt
function SilentAssassin:Load()
    --log(debug.traceback())
    self.settings["num_pagers"] = 2
    self.settings["num_pagers_per_player"] = 2
    self.settings["enabled"] = true
    self.settings["stealth_kill_enabled"] = true
    self.settings["pager_bonus_enabled"] = false
    self.settings["matchmaking_filter"] = 1

    local file = io.open(self._data_path, "r")
    if (file) then
        for k, v in pairs(json.decode(file:read("*all"))) do
            self.settings[k] = v
        end
    end
    --log("In Load " .. json.encode(self.settings))
end

--Saves the options
function SilentAssassin:Save()
    --log("In save " .. json.encode(self.settings))
    local file = io.open(self._data_path, "w+")
    if file then
        file:write(json.encode(self.settings))
        file:close()
    end
end

--Loads the data table for the menuing system.  Menus are
--ones based
function SilentAssassin:getCompleteTable()
    local tbl = {}
    for i, v in pairs(SilentAssassin.settings) do
        if i == "num_pagers" then
            tbl[i] = v + 1
        elseif  i == "num_pagers_per_player" then
            tbl[i] = v + 1
        else
            tbl[i] = v
        end
    end

    return tbl
end

--Sets number of pagers.  Called from the menu system.  Menus are all ones
--based
function setNumPagers(this, item)
    SilentAssassin.settings["num_pagers"] = item:value() - 1
end

function setNumPagersPerPlayer(this, item)
    SilentAssassin.settings["num_pagers_per_player"] = item:value() - 1
end

function setEnabled(this, item)
    local value = item:value() == "on" and true or false
    SilentAssassin.settings["enabled"] = value
end

function setStealthKillEnabled(this, item)
    local value = item:value() == "on" and true or false
    SilentAssassin.settings["stealth_kill_enabled"] = value
end

function setMatchmakingFilter(this, item)
    --log ("setMatchmakingFilter" .. tostring(item:value()))
    SilentAssassin.settings["matchmaking_filter"] = item:value()
end

function setEnablePagerBonusToggle(this, item)
    local value = item:value() == "on" and true or false
    SilentAssassin.settings["pager_bonus_enabled"] = value
end
--this only gives you the bonus for not using your pager
function calculateStageStealthBonus()
    --and if you personally didn't use a pager at all, you get a 2% bonus
    local playerBonus
    if getLocalPagersAnswered() == 0 then
        playerBonus = .02
    else
        playerBonus = 0
    end

    return playerBonus
end

--bonus for difficulty too
function calculateLevelStealthBonus()
    --calculate an adjusted stealth bonus for the level/stage
    -- adding or removing pagers (from the default of 2) changes the bonus
    -- each pager used by the party decreases the bonus
    -- reducing pagers per player increases the bonus
    -- not using your pager increases it
    local numPagers = getNumPagers()
    --don't penalize the player for having 2 total pagers but 4 per player
    local numPagersPerPlayer = math.min(numPagers, getNumPagersPerPlayer())
    local difficultyBonus = 0;
    local parPagers

    --par for pagers is 2 when stealth kills are enabled, otherwise 
    --it is the default of 4.
    if isStealthKillEnabled() then
        parPagers = 2
    else
        parPagers = 4
    end
    -- 2% bonus for each pager below 2
    difficultyBonus = difficultyBonus + ((parPagers - numPagers) * .02)
    -- 1% bonus for each pager per player below the number of total pagers
    difficultyBonus = difficultyBonus + ((numPagers - numPagersPerPlayer) * .01)
    --log ("difficulty bonus is " .. tostring(difficultyBonus))

    --you also get a 1% bonus for each pager you had but didn't use
    local missionBonus
    --it seems like this gets called when someone joins a stealth lobby  In
    --that case groupai is undefined.  So try this hack.
    if managers.groupai and managers.groupai:state() then
        missionBonus = (numPagers - managers.groupai:state():get_nr_successful_alarm_pager_bluffs()) * .01
    else
        missionBonus = numPagers
    end
    --log ("mission bonus is " .. tostring(missionBonus))

    --and if you personally didn't use a pager at all, you get a 2% bonus
    local playerBonus
    if getLocalPagersAnswered() == 0 then
        playerBonus = .02
    else
        playerBonus = 0
    end

    --log("Player bonus is " .. tostring(playerBonus))

    local bonus = difficultyBonus + missionBonus + playerBonus
    --log("Level bonus is " .. tostring(bonus))
    return bonus
end

--Load locatization strings
Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_SilentAssassin", function(loc)
    loc:load_localization_file(SilentAssassin._path.."loc/en.txt")
end)

--Set up the menu
Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_SilentAssassin", function(menu_manager)
    MenuCallbackHandler.SilentAssassin_setNumPagers = setNumPagers
    MenuCallbackHandler.SilentAssassin_setNumPagersPerPlayer = setNumPagersPerPlayer
    MenuCallbackHandler.SilentAssassin_enabledToggle = setEnabled
    MenuCallbackHandler.SilentAssassin_killPagerEnabledToggle = setStealthKillEnabled
    MenuCallbackHandler.SilentAssassin_enablePagerBonusToggle = setEnablePagerBonusToggle
    MenuCallbackHandler.SilentAssassin_setMatchmakingFilter = setMatchmakingFilter

    MenuCallbackHandler.SilentAssassin_Close = function(this)
        SilentAssassin:Save()
    end

    SilentAssassin:Load()
    MenuHelper:LoadFromJsonFile(SilentAssassin._path.."options.txt", SilentAssassin, SilentAssassin:getCompleteTable())
end)

-- gets the number of pagers, triggering a load if necessary.  Called
-- by clients
function getNumPagers()
    if not SilentAssassin.settings["num_pagers"] then
        SilentAssassin:Load()
    end
    return SilentAssassin.settings["num_pagers"]
end

function getNumPagersPerPlayer()
    if not SilentAssassin.settings["num_pagers_per_player"] then
        SilentAssassin:Load()
    end
    return SilentAssassin.settings["num_pagers_per_player"]
end

function isSAEnabled()
    if SilentAssassin.settings["enabled"] == nil then
        SilentAssassin:Load()
    end
    return SilentAssassin.settings["enabled"]
end

function isStealthKillEnabled()
    if not SilentAssassin.settings["stealth_kill_enabled"] == nil then
        SilentAssassin:Load()
    end
    return SilentAssassin.settings["stealth_kill_enabled"]
end

function isPagerBonusEnabled()
    return false
    --local Net = _G.LuaNetworking
    --if Net:IsClient() then
        --return false
    --end
    --if not SilentAssassin.settings["pager_bonus_enabled"] then
        --SilentAssassin:Load()
    --end
    --return SilentAssassin.settings["pager_bonus_enabled"]

end

function getMatchmakingFilter()
    if not SilentAssassin.settings["matchmaking_filter"] then
        SilentAssassin:Load()
    end
    --log ("getMatchmakingFilter " .. tostring(SilentAssassin.settings["matchmaking_filter"]))
    return SilentAssassin.settings["matchmaking_filter"]
end


function addLocalPagerAnswered()
    --log("Answered pager locally")
    SilentAssassin.localPagersUsed = SilentAssassin.localPagersUsed + 1
end

function getLocalPagersAnswered()
    return SilentAssassin.localPagersUsed
end

-------------------------------------------------
--  Handler for damaged received
-------------------------------------------------

if RequiredScript == "lib/units/enemies/cop/copbrain" then
    if not _CopBrain_clbk_damage then
        _CopBrain_clbk_damage = CopBrain._clbk_damage
    end

    function CopBrain:clbk_damage(my_unit, damage_info)
        if _CopBrain_clbk_damage then 
            --this seems to get called on damage but not on death
            --So if we take any non-fatal damage, the pager will go off
            --log ("non-fatal damage")
            self._cop_pager_ready = true
            _CopBrain_clbk_damage(self, my_unit, damage_info)
            --log ("made parent callback")
        end
    end

    if not _CopBrain_clbk_death then
        _CopBrain_clbk_death = CopBrain.clbk_death
    end
    function CopBrain:clbk_death(my_unit, damage_info)
        --log ("clbk_death")
        if isSAEnabled() and isStealthKillEnabled() then
            local head
            if damage_info.col_ray then 
                --the idea was to require a headshot.  It turns out that col_ray is not
                --set when the client takes the shot so I can only do OHKs on clients.
                --I figure to make things fair it should be OHKs for everyone
                --head = self._unit:character_damage()._head_body_name and damage_info.col_ray.body and damage_info.col_ray.body:name() == self._unit:character_damage()._ids_head_body_name
                head = true
            else
                --OHK keeps the pager from going ff
                head = true
            end
            if not head then
                --log ("enabling pager")
                --not headshots will cause the pager to go off
                self._cop_pager_ready = true
            end
            --if self._cop_pager_ready then
                --log("_cop_pager_ready is true")
            --end

            --log(tostring(self._unit:movement():stance_name()))
            --if self._unit:movement():cool() then
                --log("unit is cool")
            --end

            --cool() doesn't work for the camera operator on First World Bank.  For
            --some reason he's in stance "cbt" (and therefore uncool) even if he's not
            --alerted.  I figure this is a bug in the map.
            --if not self._cop_pager_ready and self._unit:movement():cool() then
            if not self._cop_pager_ready and self._unit:movement():stance_name() ~= "hos" then
                --we're dead and the pager is not ready, so delete it
                --log ("pager disabled")
                self._unit:unit_data().has_alarm_pager = false
            end
        end
        _CopBrain_clbk_death(self, my_unit, damage_info)
    end

-------------------------------------------------
--  Setting number of pagers
-------------------------------------------------
elseif RequiredScript == "lib/units/enemies/cop/copbrain" then
    if not _CopBrain_on_alarm_pager_interaction then
        _CopBrain_on_alarm_pager_interaction = CopBrain.on_alarm_pager_interaction
    end

    --This is called when a player interacts with a pager.  Swap in the
    --correct table before actually running the pager interaction
    function CopBrain:on_alarm_pager_interaction(status, player)
        if isSAEnabled() then
            if status == "complete" then
                --This is where the pager really runs
                local bluffChance = {}
                local numPagers;
                numPagers = getNumPagers()

                --Track the number of pagers a player has answered in the player
                --object
                if not player:base().num_answered then
                    player:base().num_answered = 0
                end

                --log("NumAnswered" .. tostring(player:base().num_answered))

                --If this player can answer a pager, write up to
                --getNumPagersPerPlayer() 1's into the table, otherwise
                --write all 0's.  This way the real on_alarm_pager_interaction
                --will index into the table as normal
                player:base().num_answered = player:base().num_answered + 1
                if player:base().is_local_player then
                    addLocalPagerAnswered()
                end
                local tableValue
                if player:base().num_answered <= getNumPagersPerPlayer() then
                    tableValue = 1
                else
                    tableValue = 0
                end
                for i = 0, ( numPagers - 1), 1 do
                    table.insert(bluffChance, tableValue)
                end
                table.insert(bluffChance, 0)

                tweak_data.player.alarm_pager["bluff_success_chance"] = bluffChance
                tweak_data.player.alarm_pager["bluff_success_chance_w_skill"] = bluffChance
            end
        end
        _CopBrain_on_alarm_pager_interaction(self, status, player)
    end

elseif RequiredScript == "lib/managers/crimespreemanager" then
    -- This is the last function that is called by NetworkMatchMakingSTEAM:set_attributes before calling
    -- self.lobby_handler:set_lobby_data, which is what ultimately gets sent to Steam when creating a
    -- lobby.  I can hide anything I want in this table and I'll see it in the client in
    -- NetworkMatchMakingSTEAM:_lobby_to_numbers.
    if not _CrimeSpreeManager_apply_matchmake_attributes then 
        _CrimeSpreeManager_apply_matchmake_attributes = CrimeSpreeManager.apply_matchmake_attributes
    end
    function CrimeSpreeManager.apply_matchmake_attributes(self, lobby_attributes)
        _CrimeSpreeManager_apply_matchmake_attributes(self, lobby_attributes)
        if isSAEnabled() then
            lobby_attributes.silent_assassin = 1
        end
        --log("apply_matchmake_attributes returns " .. json.encode(lobby_attributes))
    end

elseif RequiredScript == "lib/network/matchmaking/networkmatchmakingsteam" then
    if not _NetworkMatchMakingSTEAM_search_lobby then
        _NetworkMatchMakingSTEAM_search_lobby = NetworkMatchMakingSTEAM.search_lobby
    end

--This is a clone of the search_lobby function from the real code.  Current as
--of U154
    function NetworkMatchMakingSTEAM.search_lobby(self, friends_only, no_filters)
        --Start SA
        --This mod is incompatible with Snh20's Crime Spree Rank Spread Filter
        --Fix because they both override search_lobby without delegating to
        --the real search_filter.  If you set the filter to "any" then we'll
        --delegate to the "real" search_lobby.  This will also serve as a
        --workaround if Overkill changes the body of this function
        --Also, SA needs a higher priority than CSRSF.
        local saMMFilter = getMatchmakingFilter();
        if saMMFilter == 1 then
            --log ("delegating to real search_lobby")
            _NetworkMatchMakingSTEAM_search_lobby(self, friends_only, no_filters)
            return
        end
        --End SA

        --log ("Running SA version of search_lobby")
        self._search_friends_only = friends_only
        if not self:_has_callback("search_lobby") then
            return
        end
        local is_key_valid = function(key)
            return key ~= "value_missing" and key ~= "value_pending"
        end
        if friends_only then
            self:get_friends_lobbies()
        else
            local function refresh_lobby()
                if not self.browser then
                    return
                end
                local lobbies = self.browser:lobbies()
                local info = {
                    room_list = {},
                    attribute_list = {}
                }
                if lobbies then
                    for _, lobby in ipairs(lobbies) do
                        if self._difficulty_filter == 0 or self._difficulty_filter == tonumber(lobby:key_value("difficulty")) then
                            table.insert(info.room_list, {
                                owner_id = lobby:key_value("owner_id"),
                                owner_name = lobby:key_value("owner_name"),
                                room_id = lobby:id(),
                                owner_level = lobby:key_value("owner_level")
                            })
                            local attributes_data = {
                                numbers = self:_lobby_to_numbers(lobby)
                            }
                            attributes_data.mutators = self:_get_mutators_from_lobby(lobby)
                            local crime_spree_key = lobby:key_value("crime_spree")
                            if is_key_valid(crime_spree_key) then
                                attributes_data.crime_spree = tonumber(crime_spree_key)
                                attributes_data.crime_spree_mission = lobby:key_value("crime_spree_mission")
                            end
                            table.insert(info.attribute_list, attributes_data)
                        end
                    end
                end
                self:_call_callback("search_lobby", info)
            end
            self.browser = LobbyBrowser(refresh_lobby, function()
            end)
            local interest_keys = {
                "owner_id",
                "owner_name",
                "level",
                "difficulty",
                "permission",
                "state",
                "num_players",
                "drop_in",
                "min_level",
                "kick_option",
                "job_class_min",
                "job_class_max"
            }
            if self._BUILD_SEARCH_INTEREST_KEY then
                table.insert(interest_keys, self._BUILD_SEARCH_INTEREST_KEY)
            end

            --Start SA
            --For some reason I can't add the interest key for avoid
            --My guess is that it requires this to have some value or
            --Steam's browser won't return it.
            if saMMFilter == 2 then
                --log("Adding silent_assassin key")
                table.insert(interest_keys, "silent_assassin")
            end
            --End SA
            self.browser:set_interest_keys(interest_keys)
            self.browser:set_distance_filter(self._distance_filter)
            local use_filters = not no_filters
            if Global.game_settings.gamemode_filter == GamemodeCrimeSpree.id then
                use_filters = false
            end
            self.browser:set_lobby_filter(self._BUILD_SEARCH_INTEREST_KEY, "true", "equal")
            if use_filters then
                self.browser:set_lobby_filter("min_level", managers.experience:current_level(), "equalto_less_than")
                if Global.game_settings.search_appropriate_jobs then
                    local min_ply_jc = managers.job:get_min_jc_for_player()
                    local max_ply_jc = managers.job:get_max_jc_for_player()
                    self.browser:set_lobby_filter("job_class_min", min_ply_jc, "equalto_or_greater_than")
                    self.browser:set_lobby_filter("job_class_max", max_ply_jc, "equalto_less_than")
                end
            end
            if not no_filters then
                if Global.game_settings.gamemode_filter == GamemodeCrimeSpree.id then
                    local min_level = 0
                    if 0 <= Global.game_settings.crime_spree_max_lobby_diff then
                        min_level = managers.crime_spree:spree_level() - (Global.game_settings.crime_spree_max_lobby_diff or 0)
                        min_level = math.max(min_level, 0)
                    end
                    self.browser:set_lobby_filter("crime_spree", min_level, "equalto_or_greater_than")
                elseif Global.game_settings.gamemode_filter == GamemodeStandard.id then
                    self.browser:set_lobby_filter("crime_spree", -1, "equalto_less_than")
                end
            end
            if use_filters then
                for key, data in pairs(self._lobby_filters) do
                    if data.value and data.value ~= -1 then
                        self.browser:set_lobby_filter(data.key, data.value, data.comparision_type)
                        print(data.key, data.value, data.comparision_type)
                    end
                end
            end
            self.browser:set_max_lobby_return_count(self._lobby_return_count)

            --Start SA
            --log("Adding search_lobby SA filter")
            local filter = getMatchmakingFilter();
            -- 1 -> any (no filter)
            -- 2 -> require
            -- 3 -> avoid
            if filter == 2 then
                self.browser:set_lobby_filter("silent_assassin", 1, "equal")
                --log("Adding search_lobby SA filter (require)")
            elseif filter == 3 then
                self.browser:set_lobby_filter("silent_assassin", 1, "not_equal")
                --log("Adding search_lobby SA filter (avoid)")
            else
                --log("Adding search_lobby SA filter (any)")
            end
            --End SA

            if Global.game_settings.playing_lan then
                self.browser:refresh_lan()
            else
                self.browser:refresh()
            end
        end
    end


    if not _NetworkMatchMakingSTEAM__lobby_to_numbers then
        _NetworkMatchMakingSTEAM__lobby_to_numbers = NetworkMatchMakingSTEAM._lobby_to_numbers
    end
    function NetworkMatchMakingSTEAM._lobby_to_numbers(self, lobby)
        local numbers = _NetworkMatchMakingSTEAM__lobby_to_numbers(self, lobby)
        local version = lobby:key_value("silent_assassin")
        --log("_lobby_to_numbers silent_assassin = " .. tostring(version))
        return numbers
    end

 
elseif RequiredScript == "lib/managers/jobmanager" then
    if not _JobManager_current_stage_data then
        _JobManager_current_stage_data = JobManager.current_stage_data
    end
    function JobManager.current_stage_data(self)
        if isSAEnabled() and isPagerBonusEnabled() then 
            return modifyGhostBonus(self, _JobManager_current_stage_data(self))
        else
            return _JobManager_current_stage_data(self)
        end
    end

    if not _JobManager_current_level_data then
        _JobManager_current_level_data = JobManager.current_level_data
    end

    function JobManager.current_level_data(self)
        if isSAEnabled() and isPagerBonusEnabled() then
            return modifyGhostBonus(self, _JobManager_current_level_data(self))
        else
            return _JobManager_current_level_data(self)
        end
    end

    function modifyGhostBonus(self, level_data)
        --when the level is completed, modify the ghost_bonus of the stage.
        --This is called from JobManager.accumulate_ghost_bonus, which sets the
        --stealth bonus
        if level_data and level_data.ghost_bonus then
            local new_data = {}
            for k, v in pairs(level_data) do
                if k == "ghost_bonus" then
                    local bonus
                    if JobManager.on_last_stage(self) then
                        bonus = calculateLevelStealthBonus()
                    else
                        bonus = calculateStageStealthBonus()
                    end
                    --make sure the total stealth bonus is never negative
                    new_data[k] = math.clamp(v + bonus, 0, 1)
                else
                    new_data[k] = v
                end
            end

            return new_data
        end
        return level_data
    end
end

Hooks:Add("NetworkManagerOnPeerAdded", "NetworkManagerOnPeerAdded_SA", function(peer, peer_id)
    if Network:is_server() and isSAEnabled() then
        local skEnabled = isStealthKillEnabled()
        local numPagers = getNumPagers()
        local numPerPlayer = getNumPagersPerPlayer()

        DelayedCalls:Add("DelayedSAAnnounce" .. tostring(peer_id), 2, function()

            local message = "Host is running 'Silent Assassin'.  "
            if skEnabled then
                message = message .. "Kills on unalerted guards do not trigger pagers.  "
            end

            message = message .. "A maximum of " .. tostring(numPagers) .. " pagers are allowed, and each player may answer up to " .. tostring(numPerPlayer) .. " pagers."
            local peer2 = managers.network:session() and managers.network:session():peer(peer_id)
            if peer2 then
                peer2:send("send_chat_message", ChatManager.GAME, message)
            end
        end)
    end
end)
