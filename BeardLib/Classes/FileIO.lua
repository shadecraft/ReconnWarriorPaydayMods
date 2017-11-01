FileIO = FileIO or {}
function FileIO:Open(path, flags)
	if SystemFS then
		return SystemFS:open(path, flags)
	else
		return io.open(path, flags)
	end
end

function FileIO:WriteTo(path, data, flags)
	local dir = BeardLib.Utils.Path:GetDirectory(path)
	if not self:Exists(dir) then
		self:MakeDir(dir)
	end
 	local file = self:Open(path, flags or "w")
 	if file then
	 	file:write(data)
	 	file:close()
	 	return true
	else
		log("[FileIO][ERROR] Failed opening file at path " .. tostring(path))
		return false
	end
end

function FileIO:ReadFrom(path, flags, method)
 	local file = self:Open(path, flags or "r")
 	if file then
 		local data = file:read(method or "*all")
	 	file:close()
	 	return data
	else
		log("[FileIO][ERROR] Failed opening file at path " .. tostring(path))
		return false
	end
end

function FileIO:ReadConfig(path, tbl)
	local file = self:Open(path, "r")
	if file then
		local config = ScriptSerializer:from_custom_xml(file:read("*all"))
		for i, var in pairs(config) do
			if type(var) == "string" then
				config[i] = string.gsub(var, "%$(%w+)%$", tbl or self)
			end
		end
		return config
	else
		log("[FileIO][ERROR] Config at %s doesn't exist!", tostring(path))
	end
end

function FileIO:ConvertScriptData(data, typ, clean) 
	local new_data
    if typ == "json" then
        new_data = json.custom_decode(data)
    elseif typ == "xml" then
        new_data = ScriptSerializer:from_xml(data)
    elseif typ == "custom_xml" then
        new_data = ScriptSerializer:from_custom_xml(data)
    elseif typ == "generic_xml" then
        new_data = ScriptSerializer:from_generic_xml(data)
    elseif typ == "binary" then
        new_data = ScriptSerializer:from_binary(data)
    end
    return clean and BeardLib.Utils:CleanCustomXmlTable(new_data) or new_data
end

function FileIO:ConvertToScriptData(data, typ) 
	local new_data
    if typ == "json" then
        new_data = json.custom_encode(data, true)
    elseif typ == "custom_xml" then
        new_data = ScriptSerializer:to_custom_xml(data)
    elseif typ == "generic_xml" then
        new_data = ScriptSerializer:to_generic_xml(data)
    elseif typ == "binary" then
        new_data = ScriptSerializer:to_binary(data)
    end
    return new_data
end

function FileIO:ReadScriptDataFrom(path, typ) 
	local read = self:ReadFrom(path, typ == "binary" and "rb")
	if read then
		return self:ConvertScriptData(read, typ)
	end
    return false
end

function FileIO:WriteScriptDataTo(path, data, typ)
	return self:WriteTo(path, self:ConvertToScriptData(data, typ), typ == "binary" and "wb")
end

function FileIO:Exists(path)
	if not path then
		return false
	end
	if SystemFS then
		return SystemFS:exists(path)
	else
		if self:Open(path, "r") or file.GetFiles(path) then
			return true
		else
			return false
		end
	end
end

function FileIO:CopyFileTo(path, to_path)
	local dir = BeardLib.Utils.Path:GetDirectory(to_path)
	if not self:Exists(dir) then
		self:MakeDir(dir)
	end
	if SystemFS then
		SystemFS:copy_file(path, dir)
	else
		os.execute(string.format("copy \"%s\" \"%s\" /e /i /h /y /c", path, to_path))
	end
end

function FileIO:CopyTo(path, to_path) 
	os.execute(string.format("xcopy \"%s\" \"%s\" /e /i /h /y /c", path, to_path))
end

function FileIO:PrepareFilesForCopy(path, to_path)
	local files = {}
	local function PrepareCopy(p)
		local _, e = p:find(path, nil, true)
		local new_path = Path:Normalize(Path:Combine(to_path, p:sub(e + 1)))
	    for _, file in pairs(FileIO:GetFiles(p)) do
	        table.insert(files, {Path:Combine(p,file), Path:Combine(new_path, file)})
	    end
	    for _, folder in pairs(FileIO:GetFolders(p)) do
	        PrepareCopy(Path:Normalize(Path:Combine(p, folder)))
	        FileIO:MakeDir(Path:Combine(new_path, folder))
	    end
	end
	PrepareCopy(path)
	return files
end

function FileIO:CopyDirTo(path, to_path)
	for _, file in pairs(self:PrepareFilesForCopy(path, to_path)) do
		SystemFS:copy_file(file[1], file[2])
	end
end

function FileIO:CopyToAsync(path, to_path, callback)
	SystemFS:copy_files_async(self:PrepareFilesForCopy(path, to_path), callback or function(success, message)
	    if success then
	        BeardLib:log("[FileIO] Done copying directory %s to %s", path, to_path)
	    else
	        BeardLib:log("[FileIO] Something went wrong when copying directory %s to %s, \n %s", path, to_path, message)
	    end
	end)
end

function FileIO:MoveTo(path, to_path)
	SystemFS:rename_file(path, to_path)
end

function FileIO:Delete(path)
	if SystemFS then
		SystemFS:delete_file(path)
	else
		os.execute("rm -r " .. path)
	end
end

function FileIO:DeleteEmptyFolders(path, delete_current) 
	for _, folder in pairs(self:GetFolders(path)) do
		self:DeleteEmptyFolders(Path:Combine(path, folder), true)
	end
	if delete_current then
		if #self:GetFolders(path) == 0 and #self:GetFiles(path) == 0 then
			self:Delete(path)	
		end
	end
end

function FileIO:MakeDir(path) 
    if SystemFS then
    	local p
    	for _, s in pairs(string.split(path, "/")) do
    		p = p and p .. "/" .. s  or s
    		if not self:Exists(p) then
    			SystemFS:make_dir(p)
    		end
    	end
    else
        os.execute(string.format("mkdir \"%s\"", path))
    end
end
--Changed to SystemFS because blt's one sometimes fucks up the strings.
function FileIO:GetFiles(path)
	if SystemFS then
		return SystemFS:list(path)
	else
		return file.GetFiles(path)
	end
end

function FileIO:GetFolders(path)
	if SystemFS then
		return SystemFS:list(path, true)
	elseif self:Exists(path) then
		return file.GetDirectories(path)
	else
		return {}
	end
end