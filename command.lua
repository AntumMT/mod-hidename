--[[ MIT LICENSE HEADER
  
  Copyright © 2017 Jordan Irwin
  
  See: LICENSE.txt
--]]


-- Default alpha level (FIXME: Should be player attribute)
local stored_alpha = 255

-- The "hidename" chat command
core.register_chatcommand('hidename', {
	description = 'Hide or show nametag',
	func = function(name, param)
		local player = core.get_player_by_name(name)
		local nametag_color = player:get_nametag_attributes().color
		local alpha = nametag_color.a
		
		if alpha == 0 then
			core.chat_send_player(name, 'Setting nametag shown')
			
			nametag_color.a = stored_alpha
		else
			core.chat_send_player(name, 'Setting nametag hidden')
			
			nametag_color.a = 0
		end
		
		player:set_nametag_attributes({
			color = nametag_color,
		})
		
		-- FIXME: Needs return value
	end
})
