-- ButtonFacade support for TrinketMenu 
-- Cribbed mostly from PT3Bar_ButtonFacade

local lbf = LibStub("LibButtonFacade",true)

local defaults, db = {
	Skin = "Blizzard",
	Gloss = 0,
	Backdrop = true,
	Colors = {},
}, {}

local f = CreateFrame("frame")
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
f:RegisterEvent("ADDON_LOADED")

function f:SkinCallback(skin, gloss, backdrop, group, button, colors)
	if not group then return end
	db.Skin = skin
	db.Gloss = gloss
	db.Backdrop = backdrop
	db.Colors = colors
end

local btnAdded = {}
function f:SetupGroup(group, frameprefix, count)
	local bargroup = lbf:Group("TrinketMenu", group)
	local doskin
	for i=0, count-1, 1 do
		local button = _G[frameprefix..i]
		if button then
			if not btnAdded[button:GetName()] then
				bargroup:AddButton(button)
				btnAdded[button:GetName()] = true
				doskin = true
			end
		end
	end
	if doskin then
	    bargroup.Colors = db.Colors
		bargroup:Skin(db.Skin, dbGloss, db.Backdrop)
	end
end

function f:ADDON_LOADED(event, addon)
	if addon ~= "TrinketMenu_ButtonFacade" then return end

	TrinketMenu_ButtonFacadeDB = 
		setmetatable(TrinketMenu_ButtonFacadeDB or {}, {__index = defaults})
	db = TrinketMenu_ButtonFacadeDB
		
	self:SetupGroup("ActionBar", "TrinketMenu_Trinket", 2)
	lbf:RegisterSkinCallback("TrinketMenu", self.SkinCallback, self)
	
	self:UnregisterEvent("ADDON_LOADED")
end