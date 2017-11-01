local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pgt_original_coplogicidle_chkrelocate = CopLogicIdle._chk_relocate
function CopLogicIdle._chk_relocate(data)
	if data.unit:base().pgt_destination then
		return false
	end

	return pgt_original_coplogicidle_chkrelocate(data)
end
