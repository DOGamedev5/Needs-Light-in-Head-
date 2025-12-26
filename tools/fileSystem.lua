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
		for key, value in pairs(data) do
			result = result .. string.rep("  ", indentation + 1) .. key .. " = "
			result = result .. FileSystem.serialize(value, indentation + 1) .. ",\n"
		end
		result = result .. string.rep("  ", indentation) .."}\n"
		return result
	else
		print("error: cant serialize type: " .. type(data))
	end
end

function FileSystem.fileExist(file)
	return love.filesystem.getInfo(file, "file") ~= nil
end

function FileSystem.writeFile(file, data)
	success, message = love.filesystem.write(file, "return " .. FileSystem.serialize(data))
	print(success)
	print(message)
end

function FileSystem.loadFile(file)
	chunk = love.filesystem.load(file)
	return chunk()
end

function FileSystem.deleteFile(file)
	love.filesystem.remove(file)
end