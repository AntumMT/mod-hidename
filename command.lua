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
	description = S('Hide or show nametag'),
	func = function(name, param)
		local player = core.get_player_by_name(name)
		local nametag_color = player:get_nametag_attributes().color
		local alpha = nametag_color.a
		
		if alpha == 0 then
			core.chat_send_player(name, S('Setting nametag visible'))
			
			nametag_color.a = stored_alpha
		else
			core.chat_send_player(name, S('Setting nametag hidden'))
			
			nametag_color.a = 0
		end
		
		player:set_nametag_attributes({
			color = nametag_color,
		})
		
		-- FIXME: Needs return value
	end
})
