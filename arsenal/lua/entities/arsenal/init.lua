AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("lotr.ars_open")
util.AddNetworkString("lotr.ars_pick")
util.AddNetworkString("lotr.ars_put")
resource.AddFile("materials/lotr/pistols.png")
resource.AddFile("materials/lotr/blasters.png")
resource.AddFile("materials/lotr/other.png")
resource.AddFile("materials/lotr/snipers.png")


function ENT:Initialize()
    self:SetModel("models/galactic/supclone/loreclone/simequipmentlocker.mdl ")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activ, caller)
    if activ:IsPlayer() then
        net.Start("lotr.ars_open")
        net.Send(activ)
    end
end

net.Receive("lotr.ars_pick", function(_,ply)
    local class = net.ReadString()
    ply:Give(class)
end)

net.Receive("lotr.ars_put", function(_,ply)
    local class = net.ReadString()
    ply:StripWeapon(class)
end)