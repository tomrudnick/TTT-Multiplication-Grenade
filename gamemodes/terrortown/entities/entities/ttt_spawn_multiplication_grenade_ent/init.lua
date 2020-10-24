AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


local interval = 2

local ttt_allow_jump = CreateConVar("ttt_allow_discomb_jump", "0")
local ttt_pull_physics = CreateConVar("ttt_multiplication_grenade_pull_physics", "0")
local ttt_push_force = CreateConVar("ttt_multiplication_grenade_push_force", "400")
local ttt_radius = CreateConVar("ttt_multiplication_grenade_radius", "800")
CreateConVar("ttt_multiplication_grenade_multiplication_counter", "3")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

    self.timer = CurTime()
    self.applyForce = CurTime()
    self.randomForceVector = Vector(math.random(-100, 100), math.random(-100, 100), math.random(-20, 20))

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end

    

end

local function PushPullRadius(pos)
    local radius = ttt_radius:GetInt()
    local phys_force = 1500
    local push_force = ttt_push_force:GetInt()
    
    -- pull physics objects and push players
    for k, target in ipairs(ents.FindInSphere(pos, radius)) do
       if IsValid(target) then
          local tpos = target:LocalToWorld(target:OBBCenter())
          local dir = (tpos - pos):GetNormalized()
          local phys = target:GetPhysicsObject()
 
          if target:IsPlayer() and (not target:IsFrozen()) then
            --print("Target: ", target, " Thrower: ", pusher)
             -- always need an upwards push to prevent the ground's friction from
             -- stopping nearly all movement
            dir.z = math.abs(dir.z) + 1

            local push = dir * push_force

            -- try to prevent excessive upwards force
            local vel = target:GetVelocity() + push
            vel.z = math.min(vel.z, push_force)
            target:SetVelocity(vel)

 
          elseif IsValid(phys) and ttt_pull_physics:GetBool() then
            --local test = "test" 
            phys:ApplyForceCenter(dir * -1 * phys_force)
          end
       end
    end
 
    local phexp = ents.Create("env_physexplosion")
    if IsValid(phexp) then
       phexp:SetPos(pos)
       
       if ttt_pull_physics:GetBool() then
           phexp:SetKeyValue("magnitude", 1) 
       else
           phexp:SetKeyValue("magnitude", 100)
       end

       phexp:SetKeyValue("radius", radius / 2)
       -- 1 = no dmg, 2 = push ply, 4 = push radial, 8 = los, 16 = viewpunch
       phexp:SetKeyValue("spawnflags", 1 + 2 + 16)
       phexp:Spawn()
       phexp:Fire("Explode", "", 0.2)
    end
 end


function ENT:PhysicsUpdate(phys)
    local phys = self:GetPhysicsObject()
    if self.counter <= 3 && CurTime() - self.applyForce < 1 then
        phys:ApplyForceCenter(self.randomForceVector)
    end
end

function ENT:Explode()
    if SERVER then
        
        local pos = self:GetPos()
        self:SetNoDraw(true)
        --self.SetSolid(SOLID_NONE)
        self:Remove()
        PushPullRadius(pos)

        local effect = EffectData()
        effect:SetStart(pos)
        effect:SetOrigin(pos)
        --print("Thrower in ENT: ", self.thrower)
        util.Effect("Explosion", effect, true, true)
        util.Effect("cball_explode", effect, true, true)
    end

end

function ENT:Think()

    if CurTime() - self.timer > interval then
        --print("Grenade Counter: ", self.counter)
        self.timer = CurTime()
        if self.counter == 0 then
            self:Explode()
        else
            for i = 1, 2 do 
                local newGrenade = ents.Create("ttt_spawn_multiplication_grenade_ent")
                newGrenade:SetPos(self:GetPos())
                newGrenade:Spawn()
                newGrenade.counter = self.counter - 1
            end
            self.counter = self.counter - 1
        end
    end
end

function ENT:SetCounter(num)
    self.counter = num
end
