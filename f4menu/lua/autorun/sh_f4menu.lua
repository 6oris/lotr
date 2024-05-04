if SERVER then
    resource.AddFile("materials/lotr/setting.png")
    resource.AddFile("materials/lotr/binds.png")
    resource.AddFile("materials/lotr/administration.png")
    resource.AddFile("materials/lotr/slots_pers.png")
    resource.AddFile("materials/lotr/eventmanagers.png")
    resource.AddFile("materials/lotr/transfer.png")
    AddCSLuaFile("vgui/ui_f4menu.lua")
    util.AddNetworkString("lotr.f4menu")
    util.AddNetworkString("lotr.f4menu_credit")
    util.AddNetworkString("lotr.f4menu_admin")
    util.AddNetworkString("lotr.f4menu_admin_reply")
    hook.Add("ShowSpare2", "f4Menu_lotr", function(ply)
        net.Start("lotr.f4menu") net.Send(ply)
    end)
    net.Receive("lotr.f4menu_credit", function(_, ply)
        local tbl = net.ReadTable()
        local recent = tbl.ent
        local count = tbl.count
        for k, v in ipairs(player.GetAll()) do
            if v:Name() == recent then
                recent = v
            end
        end
        if ply == recent then
            print(ply:Name().." пытался перевести себе деньги")
        else
            print(recent:Name().." Получит: "..count.."\n От: "..ply:Name())
            local ply_money = ply:getDarkRPVar("money")
            if (ply_money - count) < 0 then
                print(ply:Name().."пытался перевести сумму больше чем его счёт")
            else
                ply:addMoney(-count)
                recent:addMoney(count)
            end
        end
    end)
    net.Receive("lotr.f4menu_admin_reply", function(_, ply)
        local tbl = net.ReadTable()
        net.Start("lotr.f4menu_admin_reply")
        net.WriteString(tbl.str)
        net.Send(tbl.ply)
    end)
    concommand.Add("zhaloba", function(ply, cmd, args)
        net.Start("lotr.f4menu_admin")
        local tbl = {
            args[1],
            args[2],
            ply
        }
        net.WriteTable(tbl)
        net.Send(ply)
    end)
else
    include("vgui/ui_f4menu.lua")
    net.Receive("lotr.f4menu", function()
        if !LOTRF4menu then
            LOTRF4menu = vgui.Create("lotr.f4menu")
        end
        if LOTRF4menu:IsVisible() then
            LOTRF4menu:SetVisible(false)
            gui.EnableScreenClicker(false)
        else
            LOTRF4menu:SetVisible(true)
            gui.EnableScreenClicker(true)
        end
    end)
end