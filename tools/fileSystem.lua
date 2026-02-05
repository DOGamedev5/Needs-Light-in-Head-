FileSystem = {}

function FileSystem.serialize(data, indentation)
	indentation = indentation or 0
	result = ""
	if type(data) == "number" then
		return tostring(data)
	elseif type(data) == "string" then
		return string.format("%q", data)
	elseif type(data) == "table" then
		result = result .. "{\n"
		for k, value in pairs(data) do
			local key = k
			if type(key) == "number" then
				key = "[ " .. k .. " ]"
			end 
			result = result .. string.rep("  ", indentation + 1) .. key .. " = "
			result = result .. FileSystem.serialize(value, indentation + 1) .. ",\n"
		end
		result = result .. string.rep("  ", indentation) .."}\n"
		return result
	else
		print("ERROR: cant serialize type: " .. type(data))
	end
end

function FileSystem.fileExist(file, tipe)
	tipe = tipe or "file"
	return love.filesystem.getInfo(file, tipe) ~= nil
end

function FileSystem.writeFile(file, data)
	success, message = love.filesystem.write(file, "return " .. FileSystem.serialize(data))
	if not success then
		
		print(string("ERROR WHEN WRITING FILE \"%s\", error message: ", file), message)
	end
end

function FileSystem.loadFile(file)
	chunk = love.filesystem.load(file)
	return chunk()
end

function FileSystem.deleteFile(file)
	love.filesystem.remove(file)
end