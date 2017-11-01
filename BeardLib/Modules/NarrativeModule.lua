NarrativeModule = NarrativeModule or class(ItemModuleBase)

NarrativeModule.type_name = "narrative"
NarrativeModule._loose = true

function NarrativeModule:init(core_mod, config)
    self.clean_table = table.add(clone(self.clean_table), {
        {
            param = "chain",
            action = {"number_indexes", "remove_metas"}
        },        
        {
            param = "chain",
            action = function(tbl)
                for _, v in pairs(tbl) do
                    if v.level_id then
                        v = BeardLib.Utils:RemoveAllNumberIndexes(v, true)
                    else
                        for _, _v in pairs(v) do
                            _v = BeardLib.Utils:RemoveAllNumberIndexes(_v, true)
                        end
                    end
                end
            end
        },        
        {
            param = "crimenet_callouts",
            action = "number_indexes"
        },
        {
            param = "crimenet_videos",
            action = "number_indexes"
        },
        {
            param = "payout",
            action = "number_indexes"
        },
        {
            param = "contract_cost",
            action = "number_indexes"
        },
        {
            param = "experience_mul",
            action = "number_indexes"
        },
        {
            param = "min_mission_xp",
            action = "number_indexes"
        },
        {
            param = "max_mission_xp",
            action = "number_indexes"
        },
        {
            param = "allowed_gamemodes",
            action = "number_indexes"
        }
    })
    if not NarrativeModule.super.init(self, core_mod, config) then
        return false
    end

    return true
end

function NarrativeModule:AddNarrativeData(narr_self)
    local data = {
        name_id = self._config.name_id or "heist_" .. self._config.id .. "_name",
        briefing_id = self._config.brief_id or "heist_" .. self._config.id .. "_brief",
        contact = self._config.contact or "custom",
        jc = self._config.jc or 50,
        chain = self._config.chain,
        dlc = self._config.dlc,
        briefing_event = self._config.briefing_event,
        debrief_event = self._config.debrief_event,
        crimenet_callouts = self._config.crimenet_callouts,
        crimenet_videos = self._config.crimenet_videos,
        payout = self._config.payout or {0.001,0.001,0.001,0.001,0.001},
        contract_cost = self._config.contract_cost or {0.001,0.001,0.001,0.001,0.001},
        experience_mul = self._config.experience_mul or {0.001,0.001,0.001,0.001,0.001},
        contract_visuals = {
            min_mission_xp = self._config.min_mission_xp or {0.001,0.001,0.001,0.001,0.001},
            max_mission_xp = self._config.max_mission_xp or {0.001,0.001,0.001,0.001,0.001}
        },
        ignore_heat = true,
        allowed_gamemodes = self._config.allowed_gamemodes,
        custom = true
    }    
    for _, stage in pairs(data.chain) do
        if stage.level_id then
            narr_self.stages[stage.level_id] = stage
        else
            for _, _stage in pairs(stage) do
                narr_self.stages[_stage.level_id] = _stage
            end
        end
    end
    if self._config.merge_data then
        table.merge(data, BeardLib.Utils:RemoveMetas(self._config.merge_data, true))
    end
    narr_self.jobs[self._config.id] = data
    if #data.chain > 0 then 
        table.insert(narr_self._jobs_index, self._config.id)
    end
    narr_self:set_job_wrappers()
end

function NarrativeModule:RegisterHook()
    if tweak_data and tweak_data.narrative then
        self:AddNarrativeData(tweak_data.narrative)
    else
        Hooks:PostHook(NarrativeTweakData, "init", self._config.id .. "AddNarrativeData", callback(self, self, "AddNarrativeData"))
    end
end

BeardLib:RegisterModule(NarrativeModule.type_name, NarrativeModule)
