Configuration = {}
Configuration.language = "en"
Configuration.gamma = 1.0
Configuration.bloom = true

local savePath = "configuration.lua"

function Configuration:packet()
	return {
		language = "en",
		gamma = 1.0,
		bloom = false,
		version = "v0.3"
	}
end

function Configuration:unpack(packet)
	self.language = packet.language
	self.gamma = packet.gamma
	self.bloom = packet.bloom
	self.version = packet.version
end

function Configuration:load()
	if not FileSystem.fileExist(savePath) then
    	self:save()
  	else
    	self:unpack(FileSystem.loadFile(savePath))
  	end
end

function Configuration:save()
	FileSystem.writeFile(savePath, self:packet())
end
