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


--- Hide Name mod API.


-- Default alpha level (FIXME: Should be player attribute)
local stored_alpha = 255


--- Checks if player's nametag is hidden.
--
-- Compares value of argument ***alpha*** against 0 (0 being transparent).
-- TODO: Check for empty string instead of alpha value
--
-- @return ***true*** if player's nametag is hidden
function hidename.hidden(alpha)
	return alpha == 0
end


--- Hides a player's nametag.
--
-- @param name Name of player whose nametag should be hidden
-- @return ***true*** if player's nametag is hidden
function hidename.hide(name)
	local player = core.get_player_by_name(name)
	local nametag_color = player:get_nametag_attributes().color
	
	if hidename.hidden(nametag_color.a) then
		core.chat_send_player(name, S('Nametag is already hidden'))
		return true
	end
	
	-- Set nametag alpha level to 0
	nametag_color.a = 0
	player:set_nametag_attributes({
		color = nametag_color,
	})
	
	-- Test new alpha level
	local hidden = player:get_nametag_attributes().color.a == 0
	if hidden then
		core.chat_send_player(name, S('Nametag is now hidden'))
	else
		core.chat_send_player(name, S('ERROR: Could not hide nametag'))
		core.log('error', 'Could not set nametag to "hidden" for player ' .. name)
		core.log('error', 'Please submit an error report to the "hidename" mod developer')
	end
	
	return hidden
end


--- Makes a player's nametag visible.
--
-- @param name Name of player whose nametag should be visible
-- @return ***true*** if player's nametag is visible
function hidename.show(name)
	local player = core.get_player_by_name(name)
	local nametag_color = player:get_nametag_attributes().color
	local alpha = nametag_color.a
	
	if not hidename.hidden(alpha) then
		core.chat_send_player(name, S('Nametag is already visible'))
		return true
	end
	
	-- Restore nametag alpha level (currently static)
	nametag_color.a = stored_alpha
	player:set_nametag_attributes({
		color = nametag_color,
	})
	
	-- Test new alpha level
	local shown = player:get_nametag_attributes().color.a ~= 0
	if shown then
		core.chat_send_player(name, S('Nametag is now visible'))
	else
		core.chat_send_player(name, S('ERROR: Could not show nametag'))
		core.log('error', 'Could not set nametag to "visible" for player ' .. name)
		core.log('error', 'Please submit an error report to the "hidename" mod developer')
	end
	
	return shown
end
