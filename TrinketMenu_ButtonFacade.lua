-- TrinketMenu
local bf = LibStub("AceAddon-3.0"):GetAddon("ButtonFacade")
local lbf = LibStub("LibButtonFacade",true)
local tmenubf = bf:NewModule("TrinketMenu")

local defaults = {
	profile = {
		["*"] = {
			Skin = "Blizzard",
			Gloss = 0,
			Backdrop = false,
		},
	},
}

function tmenubf:OnInitialize()
	self.db = self:RegisterNamespace("TrinketMenu", defaults)
	self:Load()
end

function tmenubf:SkinCallback(skin, gloss, backdrop, group)
	if not group then return end
	self.db.profile[group].Skin = skin
	self.db.profile[group].Gloss = gloss
	self.db.profile[group].Backdrop = backdrop
end

local btnAdded = {}
function tmenubf:SetupGroup(group, frameprefix, count)
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
		bargroup:Skin(self.db.profile[group].Skin, self.db.profile[group].Gloss,
		              self.db.profile[group].Backdrop)
	end
end

function tmenubf:Load()
	self:SetupGroup("ActionBar", "TrinketMenu_Trinket", 2)
	lbf:RegisterSkinCallback("TrinketMenu", self.SkinCallback, self)
end