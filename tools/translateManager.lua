TranslateManager = {}

TranslateManager.lang = {}

function TranslateManager.newReference(catergory, tag)
	local instance = {}

	instance.catergory = catergory
	instance.tag = tag

	instance.getText = function(self)
		if TranslateManager.lang[catergory] == nil then return self.tag end
		if TranslateManager.lang[catergory][tag] == nil then return self.tag end

		return TranslateManager.lang[catergory][tag]
	end

	return instance
end

function TranslateManager:getReference(catergory, tag)
	if self.lang[catergory] == nil then return tag end
	if self.lang[catergory][tag] == nil then return tag end

	return self.lang[catergory][tag]
end

function TranslateManager:loadLanguege(lang)
	if not FileSystem.fileExist(string.format("translations/%s.lua", lang)) then
		print(string.format("there is no translation for %s languege", lang))
		lang = "en"
	end	
	self.lang = require(string.format("translations.%s", lang))

end