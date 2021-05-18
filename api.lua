--[[ MIT LICENSE HEADER

  Copyright © 2017 Jordan Irwin (AntumDeluge)

  See: LICENSE.txt
--]]


--- *hidename* mod API
--
-- @script api.lua


local S = core.get_translator(hidename.modname)


--- Checks if player's nametag is hidden.
--
-- Compares alpha level of player's nametag against 0 (0 being transparent).
--
-- TODO: Check for empty string instead of alpha value
--
-- @tparam table nametag_data Nametag data retrieved by *player:get_nametag_attributes()*.
-- @treturn bool ***true*** if player's nametag is hidden
function hidename.hidden(nametag_data)
	if hidename.use_alpha then
		return nametag_data.color.a == 0
	end

	return not nametag_data.text or nametag_data.text:trim() == ""
end


--- Messages info to player about nametag text & visibility.
--
-- @tparam string name Name of player to check & message
function hidename.tellStatus(name)
	local player = core.get_player_by_name(name)
	local nametag = player:get_nametag_attributes()

	local status = "Status: "
	if hidename.hidden(nametag) then
		status = status .. "hidden"
	else
		status = status .. "visible"
	end

	-- Use name parameter value if nametag.text is empty
	if not nametag.text or nametag.text:trim() == "" then
		nametag.text = name
	end

	core.chat_send_player(name, S("Nametag:") .. " " .. nametag.text)
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
		core.chat_send_player(name, S("Nametag is already hidden"))
		return true
	end

	if hidename.use_alpha then
		-- Preserve nametag alpha level
		player:get_meta():set_int("nametag_stored_alpha", nametag.color.a)

		-- Set nametag alpha level to 0
		nametag.color.a = 0
		player:set_nametag_attributes(nametag)
	else
		-- preserve original nametag bg color (we store entire color
		-- because bgcolor attribute can be boolean)
		player:get_meta():set_string("nametag_stored_bgcolor", core.serialize(nametag.bgcolor))

		-- remove text from nametag
		nametag.text = " " -- HACK: empty nametag triggers using player name
		nametag.bgcolor = {a=0, r=255, g=255, b=255} -- can't just set alpha because may be a boolean value

		player:set_nametag_attributes(nametag)
	end

	if hidename.hidden(player:get_nametag_attributes()) then
		core.chat_send_player(name, S("Nametag is now hidden"))
	else
		core.chat_send_player(name, S("ERROR: Could not hide nametag"))
		core.log("error", "Could not set nametag to \"hidden\" for player " .. name)
		core.log("error", "Please submit an error report to the \"hidename\" mod developer")
	end
end


--- Makes a player's nametag visible.
--
-- @tparam string name Name of player whose nametag should be made visible
-- @treturn bool ***true*** if player's nametag is visible
function hidename.show(name)
	local player = core.get_player_by_name(name)
	local nametag = player:get_nametag_attributes()

	if not hidename.hidden(nametag) then
		core.chat_send_player(name, S("Nametag is already visible"))
		return true
	end

	local pmeta = player:get_meta()
	if hidename.use_alpha then
		-- restore nametag alpha level
		nametag.color.a = pmeta:get_int("nametag_stored_alpha")
		player:set_nametag_attributes(nametag)

		-- clean meta info
		player:get_meta():set_string("nametag_stored_alpha", nil)
	else
		-- restore nametag text & bg color
		nametag.text = name
		nametag.bgcolor = core.deserialize(pmeta:get_string("nametag_stored_bgcolor"))
		player:set_nametag_attributes(nametag)

		-- clean meta info
		pmeta:set_string("nametag_stored_bgcolor", nil)
	end

	if not hidename.hidden(player:get_nametag_attributes()) then
		core.chat_send_player(name, S("Nametag is now visible"))
	else
		core.chat_send_player(name, S("ERROR: Could not show nametag"))
		core.log("error", "Could not set nametag to \"visible\" for player " .. name)
		core.log("error", "Please submit an error report to the \"hidename\" mod developer")
	end
end


-- Ensure that nametag text attribute is not empty when player logs on
if not hidename.use_alpha then
	-- Sets the player's nametag text attribute to player name.
	local function setNametagText(player)
		local nametag = player:get_nametag_attributes()
		if nametag.text == "" or nametag.text == nil then
			player:set_nametag_attributes({
				text = player:get_player_name(),
			})
		end
	end

	core.register_on_joinplayer(setNametagText)
end
