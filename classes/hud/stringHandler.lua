StringHandler = {}


function StringHandler.getDimentions(text, font)
	local wid = font:getWidth(text)
  	local _, count = string.gsub(text, "\n", "")
  	local hei = font:getHeight(text)*(count+1)

  	return wid, hei
end
