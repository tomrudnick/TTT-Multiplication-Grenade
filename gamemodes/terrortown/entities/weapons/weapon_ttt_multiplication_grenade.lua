if SERVER then
   AddCSLuaFile()
   resource.AddWorkshop("2254978370")
end

SWEP.HoldType = "grenade"

--if SERVER then
--	resource.AddWorkshop("")
--end

if CLIENT then
   SWEP.PrintName = "Multiplication Grenade"
   SWEP.Slot = 7

   SWEP.EquipMenuData = {
      type = "Multiplication Grenade",
      desc = "If just need a litte bit more then 'a bit pushing'".."\n".."NOW EXTRA HUGE - Ikkou"
   };
   
   SWEP.Icon = "vgui/ttt/icon_ttt_multiplication_grenade.png"
   SWEP.IconLetter = "h"
end

SWEP.Base				= "weapon_tttbasegrenade"

SWEP.WeaponID = WEAPON_EQUIP
SWEP.Kind = WEAPON_EQUIP2

SWEP.CanBuy = {ROLE_TRAITOR}

SWEP.Spawnable = false


SWEP.AutoSpawnable      = false

SWEP.UseHands			= true
SWEP.ViewModelFlip		= true
SWEP.ViewModelFOV		= 70
SWEP.ViewModel			= "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_fraggrenade.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.Weight			= 5

-- really the only difference between grenade weapons: the model and the thrown
-- ent.
function SWEP:Initialize()
   self:Activate()
end

function SWEP:OnDrop()
   self:Activate()
end


function SWEP:GetGrenadeName()
   return "ttt_multiplication_grenade_ent"
end
