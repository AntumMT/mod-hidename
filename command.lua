--[[ MIT LICENSE HEADER
  
  Copyright © 2017 Jordan Irwin (AntumDeluge)
  
  See: LICENSE.txt
--]]


-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.global_exists('intllib') then
	if intllib.make_gettext_pair then
		S = intllib.make_gettext_pair()
	else
		S = intllib.Getter()
	end
else
	S = function(s) return s end
end


-- Default alpha level (FIXME: Should be player attribute)
local stored_alpha = 255

-- "hidename" chat command
core.register_chatcommand(S('hidename'), {
	description = S('Make nametag hidden'),
	func = function(name, param)
		return hidename.hide(name)
	end,
})


-- "showname" chat command
core.register_chatcommand(S('showname'), {
	description = S('Make nametag visible'),
	func = function(name, param)
		return hidename.show(name)
	end,
})
