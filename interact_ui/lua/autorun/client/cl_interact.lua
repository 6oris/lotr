print("[INTERACTUI] loaded client")

local entitys = {
    "arsenal"
}

local sw, sh = ScrW(), ScrH()
local aw = sw / 1920
local ah = sh / 1080
local anim = 0

surface.CreateFont("lotr.font.interact", {
	font = "Montserrat Bold",
	size = (sw+sh)*(.015/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = true,
    scanlines = 2,
})
surface.CreateFont("lotr.font.interact_sub", {
	font = "Montserrat Bold",
	size = (sw+sh)*(.012/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = true,
    scanlines = 2,
})

surface.CreateFont("lotr.font.interact_sub_g", {
	font = "Montserrat Bold",
	size = (sw+sh)*(.012/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = true,
    scanlines = 2,
    blursize = 6
})

local function DrawOutRect(x,y,w,h,ww,hh)
    -- TOP-LEFT
    surface.DrawRect(x,y,ww,hh)
    surface.DrawRect(x,y,hh,ww)
    -- TOP-RIGHT
    surface.DrawRect(x + w - ww,y,ww,hh)
    surface.DrawRect(x + w - hh,y,hh,ww)
    -- Bottom-LEFT
    surface.DrawRect(x,y + h - hh,ww,hh)
    surface.DrawRect(x,y + h - ww,hh,ww)
    -- Bottom-RIGHT
    surface.DrawRect(x + w - ww,y + h - hh,ww,hh)
    surface.DrawRect(x + w - hh,y + h - ww,hh,ww)
end


hook.Add("HUDPaint", "LOTR.INTERACT", function()
    for k, v in pairs(ents.GetAll()) do
        local class_ent = v:GetClass()
        if LocalPlayer():GetEyeTrace().Entity == v then
            if (table.HasValue(entitys, class_ent)) then
                if LocalPlayer():GetPos():Distance(v:GetPos()) < 128 then
                    anim = math.Clamp(anim + 5 * FrameTime(), 0, 1)
                else
                    anim = math.Clamp(anim - 5 * FrameTime(), 0, 1)
                end
            else
                anim = math.Clamp(anim - 5 * FrameTime(), 0, 1)
            end
        end
    end
    surface.SetDrawColor(54,36,4,255*anim)
    surface.DrawRect(sw*(.53),sh*(.52),sw*(.0135/aw),sh*(.0225/ah))
    surface.SetDrawColor(184,166,104,255*anim)
    DrawOutRect(sw*(.53),sh*(.52),sw*(.013/aw),sh*(.022/ah),sw*(.0012/aw),sh*(.01/ah))
    draw.SimpleText("E", "lotr.font.interact", sw*(.5361),sh*(.53), Color(184,166,104,255*anim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Использовать", "lotr.font.interact_sub_g", sw*(.572),sh*(.535), Color(214,196,134,200*anim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Использовать", "lotr.font.interact_sub", sw*(.572),sh*(.535), Color(214,196,134,255*anim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    --[[surface.SetDrawColor(54,36,4,255*anim)
    surface.DrawRect(sw*(.53/aw),sh*(.52/ah),sw*(.0135/aw),sh*(.0225/ah))
    surface.SetDrawColor(241,199,25,255*anim)
    DrawOutRect(sw*(.53/aw),sh*(.52/ah),sw*(.013/aw),sh*(.022/ah),sw*(.0012/aw),sh*(.01/ah))
    draw.SimpleText("E", "lotr.font.interact", sw*(.5361/aw),sh*(.53/ah), Color(241,199,25,255*anim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    --draw.SimpleText("Использовать", "lotr.font.interact_sub_g", sw*(.572/aw),sh*(.535/ah), Color(241,199,25,200*anim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Использовать", "lotr.font.interact_sub", sw*(.572/aw),sh*(.535/ah), Color(241,199,25,255*anim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)]]

end)