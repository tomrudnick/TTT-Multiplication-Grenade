AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_fraggrenade_thrown.mdl")


function ENT:Initialize()
    self:SetModel(self.Model)
   
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
    --self:SetModelScale(5,0)
    self:Activate()
 
    --if SERVER then
    --   self:SetExplodeTime(0)
    --end
end

function ENT:Explode()
    if SERVER then
        local multiplication_counter = GetConVar("ttt_multiplication_grenade_multiplication_counter"):GetInt()
        for i = 1, 2 do 
            local newGrenade = ents.Create("ttt_spawn_multiplication_grenade_ent")
            newGrenade:SetPos(self:GetPos())
            newGrenade:Spawn()
            newGrenade:SetCounter(multiplication_counter)
            --print("Thrower: ", self:GetThrower())
        end
        self:Remove()
    end
end