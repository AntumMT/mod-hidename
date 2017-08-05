--[[ MIT LICENSE HEADER
  
  Copyright © 2017 Jordan Irwin (AntumDeluge)
  
  See: LICENSE.txt
--]]


--- *hidename* mod API
--
-- @script api.lua


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


--- Checks if player's nametag is hidden.
--
-- Compares alpha level of player's nametag against 0 (0 being transparent).
--
-- TODO: Check for empty string instead of alpha value
--
-- @tparam table nametag_data Nametag data retrieved by *player:get_nametag_attributes()*.
-- @treturn bool ***true*** if player's nametag is hidden
function hidename.hidden(nametag_data)
	return nametag_data.color.a == 0
end


--- Messages info to player about nametag text & visibility.
--
-- @tparam string name Name of player to check & message
function hidename.tellStatus(name)
	local player = core.get_player_by_name(name)
	local nametag = player:get_nametag_attributes()
	
	local status = 'Status: '
	if hidename.hidden(nametag) then
		status = status .. 'hidden'
	else
		status = status .. 'visible'
	end
	
	-- Use parameter value if nametag.text is empty
	-- FIXME: This may cause issues if text value is used instead of transparency
	--        to determine if nametag is hidden
	if nametag.text == '' then
		nametag.text = name
	end
	
	core.chat_send_player(name, S('Nametag:') .. ' ' .. nametag.text)
	core.chat_send_player(name, S(status))
end


--- Hides a player's nametag.
--
-- @tparam string name Name of player whose nametag should be made hidden
-- @treturn bool ***true*** if player's nametag is hidden
function hidename.hide(name)
	local player = core.get_player_by_name(name)
	local nametag = player:get_nametag_attributes()
	
	if hidename.hidden(nametag) then
		core.chat_send_player(name, S('Nametag is already hidden'))
		return true
	end
	
	-- Set nametag alpha level to 0
	nametag.color.a = 0
	player:set_nametag_attributes({
		color = nametag.color,
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
-- @tparam string name Name of player whose nametag should be made visible
-- @treturn bool ***true*** if player's nametag is visible
function hidename.show(name)
	local player = core.get_player_by_name(name)
	local nametag = player:get_nametag_attributes()
	
	if not hidename.hidden(nametag) then
		core.chat_send_player(name, S('Nametag is already visible'))
		return true
	end
	
	-- Restore nametag alpha level (currently static)
	nametag.color.a = stored_alpha
	player:set_nametag_attributes({
		color = nametag.color,
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
