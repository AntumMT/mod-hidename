--[[ MIT LICENSE HEADER
  
  Copyright © 2017 Jordan Irwin (AntumDeluge)
  
  See: LICENSE.txt
]]


--- *hidename* settings
--
-- @script settings.lua


--- Use nametag's alpha color level to hide instead of clearing nametag text.
-- 
-- @setting hidename.use_alpha
-- @settype bool
-- @default true
hidename.use_alpha = core.settings:get_bool('hidename.use_alpha') ~= false
