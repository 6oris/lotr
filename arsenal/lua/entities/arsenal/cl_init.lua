include("shared.lua")

--startpackclient
LOTR_PLAYER_WEAPON_ACCESS = {
    {
        path = "rw_sw_dc17s",
        name = "DC-17s",
        model = "models/fisher/dc17s/dc17s.mdl",
        group = 1,
        vpos = Vector(0,26,7),
        vlook = Vector(0,0,0),
        mod = {
            dmg = 4,
            acc = 9,
            temp = 3,
            mob = 10,
            stab = 8,
        },
        desc = "Меньший по размерам, чем винтовка DC-15A, DC-15S не мог похвастаться дальностью стрельбы, как у своего собрата DC-15A, но зато он был лёгок в использовании. Бластеры DC-15s вели огонь заряженными пучками плазмы, активированными газом тибанна, хранившимся в сменных бластерных картриджах.",
    },
    {
        path = "rw_sw_dc17",
        name = "DC-17",
        model = "models/fisher/extendeddc17/extendeddc17.mdl",
        group = 1,
        vpos = Vector(0,21,7),
        vlook = Vector(0,0,0),
        mod = {
            dmg = 3,
            acc = 9,
            temp = 3,
            mob = 10,
            stab = 8,
        },
        desc = "Тяжёлый бластерный пистолет, частично вытеснивший другой бластер — DC-15s — и использовавшийся армией Республики во время Войн клонов. DC-17 использовался прежде всего ЭРК-капитанами, ЭРК-коммандерами, капитанами и клонами-десантниками. Отличался от DC-15s весом и точностью стрельбы. Они имели удобную кобуру. Элита клонов иногда пользовалась двумя такими пистолетами в битве — черта, напоминающая Джанго Фетта.",
    },
    {
        path = "rw_sw_dc15a",
        name = "DC-15a",
        model = "models/weapons/w_dc15a.mdl",
        group = 2,
        vpos = Vector(0,50,10),
        vlook = Vector(0,10,0),
        mod = {
            dmg = 2,
            acc = 9,
            temp = 5,
            mob = 8,
            stab = 9,
        },
        desc = "Стандартная бластерная винтовка, состоявшая на вооружении у солдат-клонов Великой армии Республики. Она производилась на мощностях компании Индустрии БласТех. Версия с деревянным прикладом была стандартным оружием коммандос Сената.",
    },
    {
        path = "rw_sw_valken38x",
        name = "Valken-38x",
        model = "models/sw_battlefront/weapons/valken_38x.mdl",
        group = 3,
        vpos = Vector(0,50,15),
        vlook = Vector(0,-10,0),
        mod = {
            dmg = 4,
            acc = 4,
            temp = 8,
            mob = 5,
            stab = 3,
        },
        desc = "Бластерная пушка, стоявшая на вооружении Галактической Республики и Альянса сепаратистов в период Войн клонов, а позже, в период правления Галактической Империи, во время Галактической гражданской войны, этим оружием были вооружены как тяжеловооружённые штурмовики Имперской армии, так и тяжеловооружённые солдаты Альянса повстанцев.",
    },
}

local sw, sh = ScrW(), ScrH()
local aw = sw / 1920
local ah = sh / 1080

surface.CreateFont("lotr.font.ars.head", {
	font = "Montserrat Bold",
	size = (sw+sh)*(.06/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
})
surface.CreateFont("lotr.font.ars.interact", {
	font = "Montserrat Black",
	size = (sw+sh)*(.09/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 5,
})
surface.CreateFont("lotr.font.ars.interact_g", {
	font = "Montserrat Black",
	size = (sw+sh)*(.09/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
    blursize = 15,
})

function ENT:Draw()
    self:DrawModel()

    local forw = self:GetForward()
    local right = self:GetRight()
    local pos_ply = LocalPlayer():GetPos()
    local pos = self:GetPos()

    cam.Start3D2D(pos + right*12 + Vector(0,0,77), self:GetAngles() + Angle(0, 0, 90), .05)
        draw.SimpleText("Арсенал", "lotr.font.ars.head", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()

    cam.Start3D2D(pos + right*12.5 + Vector(0,0,45), self:GetAngles() + Angle(0, 0, 90), .05)
        --draw.DrawNonParsedSimpleText("E", "lotr.font.ars.interact", 0, -7.5, Color(241,199,25,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        --draw.DrawNonParsedSimpleText("E", "lotr.font.ars.interact_g", 0, -7.5, Color(241,199,25,150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        local w,h = 30, 5
        local x, y = 62.5, 62.5
        surface.SetDrawColor(241,199,25,255)
        surface.DrawRect(-x,-y,w,h)
        surface.DrawRect(-x,-y,h,w)

        surface.DrawRect(x-w,-y,w,h)
        surface.DrawRect(x-h,-y,h,w)

        surface.DrawRect(-x,y-h,w,h)
        surface.DrawRect(-x,y-w,h,w)

        surface.DrawRect(x-w,y-h,w,h)
        surface.DrawRect(x-h,y-w,h,w)
    cam.End3D2D()

    cam.Start3D2D(pos + right*12 + Vector(0,0,45), self:GetAngles() + Angle(0, 0, 90), .05)
        draw.SimpleText("E", "lotr.font.ars.interact", 0, -7.5, Color(241,199,25,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("E", "lotr.font.ars.interact_g", 0, -7.5, Color(241,199,25,150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end


--UI-Interface

local blur = Material 'pp/blurscreen'
local function DrawBlur(panel, amount, alpha)
	local x, y = panel:LocalToScreen(0, 0)
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat('$blur', (i / 3) * (amount or 8))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
	end
end
local function DrawOutRect(w,h,ww,hh)
    -- TOP-LEFT
    surface.DrawRect(0,0,ww,hh)
    surface.DrawRect(0,0,hh,ww)
    -- TOP-RIGHT
    surface.DrawRect(w - ww,0,ww,hh)
    surface.DrawRect(w - hh,0,hh,ww)
    -- Bottom-LEFT
    surface.DrawRect(0,h - hh,ww,hh)
    surface.DrawRect(0,h - ww,hh,ww)
    -- Bottom-RIGHT
    surface.DrawRect(w - ww,h - hh,ww,hh)
    surface.DrawRect(w - hh,h - ww,hh,ww)
end

local function HoloBG(w,h,mw1,mh1,mw2,mh2,alpha)
    surface.SetDrawColor(255,255,255,1*alpha)
    surface.DrawRect(mw1,mh1,w - mw2,h - mh2)
    surface.SetDrawColor(255,255,255,2*alpha)
    local h2 = sh*(.002/ah)
    local n = ((h-mh2)/h2)/2
    local ypos = 0
    for i = 0, n do
        surface.DrawRect(0 + mw1,ypos + mh1,w - mw2,h2)
        ypos = ypos + (h2*2)
    end
end

local function DrawLineDW(x1,y1,x2,y2,dash)
    local n = y2-y1
    local n = n/dash
    local ypos = 0
    for i=0,n do
        surface.DrawLine(x1,y1 + ypos,x2,y1 + ypos + dash)
        ypos = ypos + (dash*2)
    end
end

local function DrawLineRH(x1,y1,x2,y2,n)
    local ypos = 0
    for i = 0, n do
        surface.DrawLine(x1,y1 + ypos,x2,y2 + ypos)
        ypos = ypos + sh*(.0008/ah)
    end
end

surface.CreateFont("lotr.font.arsenal.header", {
	font = "Montserrat SemiBold",
	size = (sw+sh)*(.025/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 2,
})
surface.CreateFont("lotr.font.arsenal.subheader", {
	font = "Montserrat SemiBold",
	size = (sw+sh)*(.015/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 2,
})
surface.CreateFont("lotr.font.arsenal.spec.header", {
	font = "Montserrat",
	size = (sw+sh)*(.013/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 2,
})
surface.CreateFont("lotr.font.arsenal.spec.modify", {
	font = "Montserrat",
	size = (sw+sh)*(.011/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 2,
})

surface.CreateFont("lotr.font.arsenal.btn", {
	font = "Montserrat SemiBold",
	size = (sw+sh)*(.017/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
})

surface.CreateFont("lotr.font.arsenal.btn2", {
	font = "Montserrat SemiBold",
	size = (sw+sh)*(.019/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
})

local pnl = {}

function pnl:Init()
    self.alpha = 0
    self:SetSize(sw,sh)
    self:MakePopup()
    self.select = 1
    self.s_wpn = 1
    self.model = "models/fisher/dc17s/dc17s.mdl"

    self.vpos = Vector(0,0,0)
    self.vlook = Vector(0,0,0)

    self.spec_name = ""
    self.spec_desc = ""

    self.tbl = {}

    self.aviable = false

    self.crt_text = "Бластерные пистолеты"

    self.pistol = Material("lotr/pistols.png")
    self.blaster = Material("lotr/blasters.png")
    self.other = Material("lotr/other.png")
    self.sniper = Material("lotr/snipers.png")

    self.close = vgui.Create("DButton", self)
    self.close:SetPos(sw*(.96),sh*(.03))
    self.close:SetSize(sw*(.02/aw),sh*(.035/ah))
    self.close:SetText("")
    self.close._anim = 0
    self.close.DoClick = function()
        self:Remove()
    end
    self.close.Paint = function(me,w,h)
        if me:IsHovered() and me:IsEnabled() then
            me._anim = math.Clamp(me._anim + 15 * FrameTime(), 0, 1)
        else
            me._anim = math.Clamp(me._anim - 15 * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(255,255,255,255*self.alpha)
        surface.DrawLine(0 + w*.29,0 + h*.28,w*.7,h*.7)
        surface.DrawLine(0 + w*.29,h*.7,w*.7,0 + h*.28)
        DrawOutRect(w, h, w*.27, h*.07)
        surface.SetDrawColor(224,87,23,255*self.alpha*me._anim)
        surface.DrawLine(0 + w*.29,0 + h*.29,w*.7,h*.7)
        surface.DrawLine(0 + w*.29,h*.7,w*.7,0 + h*.29)
        DrawOutRect(w, h, w*.27, h*.07)
    end

    self.head = vgui.Create("DPanel", self)
    self.head:SetSize(sw*(.35/aw),sh*(.12/ah))
    self.head:Center()
    self.head:SetY(sh*(.05))
    self.head.Paint = function(me,w,h)
        local w_factor, h_factor = .02, .09
        HoloBG(w,h,w*w_factor,h*h_factor,w*(w_factor*2),h*.38,self.alpha)
        draw.SimpleText("Категория", "lotr.font.arsenal.subheader", w*.5, h*.17, Color(255,255,255,255*self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        surface.SetDrawColor(255,229,136,255*self.alpha)
        DrawLineRH(0,h*.09,w,h*.09,1)
        DrawLineRH(0,h*.26,w,h*.26,1)
        draw.SimpleText(self.crt_text, "lotr.font.arsenal.header", w*.5, h*.45, Color(255,255,255,255*self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        DrawLineRH(0,h*.7,w,h*.7,1)
        DrawLineDW(w*.02,0,w*.02,h*.4,h*.04)
        DrawLineDW(w*.978,0,w*.978,h*.4,h*.04)
    end
    -- BTNS-GROUPS


    self.pistols = vgui.Create("DButton", self)
    self.pistols:SetPos(sw*(.425),sh*(.93))
    self.pistols:SetSize(sw*(.03/aw),sh*(.053/ah))
    self.pistols:SetText("")
    self.pistols._anim = 0
    self.pistols.Paint = function(me,w,h)
        surface.SetDrawColor(60,60,60,255*self.alpha)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0 + w*.25,y=0},
            {x=w - w*.25,y=0},
            {x=w,y=0 + h*.25},
            {x=w,y=h - h*.25},
            {x=w - w*.25,y=h},
            {x=0 + w*.25,y=h},
            {x=0,y=h - h*.25},
            {x=0,y=0 + h*.25},
        })
        if self.select == 1 then
            surface.SetDrawColor(241,199,25,255*self.alpha)
        else
            surface.SetDrawColor(255,255,255,255*self.alpha)
        end
        surface.SetMaterial(self.pistol)
        surface.DrawTexturedRect(0 + w*.125,0 + h*.2,w*.75,h*.6)
    end
    self.pistols.DoClick = function()
        self:Pistols()
    end

    self.blasters = vgui.Create("DButton", self)
    self.blasters:SetPos(sw*(.465),sh*(.93))
    self.blasters:SetSize(sw*(.03/aw),sh*(.053/ah))
    self.blasters:SetText("")
    self.blasters._anim = 0
    self.blasters.Paint = function(me,w,h)
        surface.SetDrawColor(60,60,60,255*self.alpha)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0 + w*.25,y=0},
            {x=w - w*.25,y=0},
            {x=w,y=0 + h*.25},
            {x=w,y=h - h*.25},
            {x=w - w*.25,y=h},
            {x=0 + w*.25,y=h},
            {x=0,y=h - h*.25},
            {x=0,y=0 + h*.25},
        })
        if self.select == 2 then
            surface.SetDrawColor(241,199,25,255*self.alpha)
        else
            surface.SetDrawColor(255,255,255,255*self.alpha)
        end
        surface.SetMaterial(self.blaster)
        surface.DrawTexturedRect(0 + w*.125,0 + h*.2,w*.75,h*.6)
    end
    self.blasters.DoClick = function()
        self:Blasters()
    end

    self.others = vgui.Create("DButton", self)
    self.others:SetPos(sw*(.505),sh*(.93))
    self.others:SetSize(sw*(.03/aw),sh*(.053/ah))
    self.others:SetText("")
    self.others._anim = 0
    self.others.Paint = function(me,w,h)
        surface.SetDrawColor(60,60,60,255*self.alpha)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0 + w*.25,y=0},
            {x=w - w*.25,y=0},
            {x=w,y=0 + h*.25},
            {x=w,y=h - h*.25},
            {x=w - w*.25,y=h},
            {x=0 + w*.25,y=h},
            {x=0,y=h - h*.25},
            {x=0,y=0 + h*.25},
        })
        if self.select == 3 then
            surface.SetDrawColor(241,199,25,255*self.alpha)
        else
            surface.SetDrawColor(255,255,255,255*self.alpha)
        end
        surface.SetMaterial(self.other)
        surface.DrawTexturedRect(0 + w*.125,0 + h*.2,w*.75,h*.6)
    end
    self.others.DoClick = function()
        self:Others()
    end

    self.snipers = vgui.Create("DButton", self)
    self.snipers:SetPos(sw*(.545),sh*(.93))
    self.snipers:SetSize(sw*(.03/aw),sh*(.053/ah))
    self.snipers:SetText("")
    self.snipers._anim = 0
    self.snipers.Paint = function(me,w,h)
        surface.SetDrawColor(60,60,60,255*self.alpha)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0 + w*.25,y=0},
            {x=w - w*.25,y=0},
            {x=w,y=0 + h*.25},
            {x=w,y=h - h*.25},
            {x=w - w*.25,y=h},
            {x=0 + w*.25,y=h},
            {x=0,y=h - h*.25},
            {x=0,y=0 + h*.25},
        })
        if self.select == 4 then
            surface.SetDrawColor(241,199,25,255*self.alpha)
        else
            surface.SetDrawColor(255,255,255,255*self.alpha)
        end
        surface.SetMaterial(self.sniper)
        surface.DrawTexturedRect(0 + w*.125,0 + h*.2,w*.75,h*.6)
    end
    self.snipers.DoClick = function()
        self:Snipers()
    end

    -- VIEWMODELS + SPEC --

    self.SPEC = vgui.Create("DPanel", self)
    self.SPEC:SetSize(sw*(.4/aw),sh*(.2/ah))
    self.SPEC:Center()
    self.SPEC:SetY(sh*(.7))
    self.SPEC.Paint = function(me,w,h)
        local w_factor, h_factor = .02, .09
        HoloBG(w,h,w*w_factor,h*h_factor,w*(w_factor*2),h*.0,self.alpha)
        surface.SetDrawColor(255,229,136,255*self.alpha)
        DrawLineRH(0,h*.09,w,h*.09,1)
        DrawLineRH(0,h*.26,w,h*.26,1)
        DrawLineRH(0,h*.4,w*.34,h*.4,1)
        DrawLineRH(0,h*.55,w*.34,h*.55,1)
        DrawLineRH(0,h*.7,w*.34,h*.7,1)
        DrawLineRH(0,h*.85,w*.34,h*.85,1)
        DrawLineRH(0,h*.99,w,h*.99,2)
        DrawLineDW(w*.02,0,w*.02,h,h*.02)
        DrawLineDW(w*.18,0,w*.18,h,h*.02)
        DrawLineDW(w*.32,0,w*.32,h,h*.02)
        DrawLineDW(w*.978,0,w*.978,h,h*.02)
        draw.SimpleText(self.spec_name, "lotr.font.arsenal.spec.header", w*.1, h*.17, Color(255,255,255,255*self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Параметры", "lotr.font.arsenal.spec.header", w*.25, h*.17, Color(255,255,255,255*self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Описание", "lotr.font.arsenal.spec.header", w*.635, h*.17, Color(255,255,255,255*self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText("урон", "lotr.font.arsenal.spec.modify", w*.25, h*.32, Color(255,255,255,255*self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("точность", "lotr.font.arsenal.spec.modify", w*.25, h*.47, Color(255,255,255,255*self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("темп", "lotr.font.arsenal.spec.modify", w*.25, h*.62, Color(255,255,255,255*self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("мобильность", "lotr.font.arsenal.spec.modify", w*.25, h*.77, Color(255,255,255,255*self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("стабильность", "lotr.font.arsenal.spec.modify", w*.25, h*.92, Color(255,255,255,255*self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.spec_desc_l = vgui.Create("DPanel", self.SPEC)
    self.spec_desc_l:SetSize(sw*(.245/aw),sh*(.13/ah))
    self.spec_desc_l:SetPos(sw*(.14/aw),sh*(.06/ah))
    self.spec_desc_l.Paint = nil

    local function SPECDraw(w,h,n)
        draw.NoTexture()
        local xpos = 0
        surface.SetDrawColor(184,166,104,255*self.alpha)
        for i=1,n do
            surface.DrawPoly({
                {x=0 + w*.04 + xpos,y=0},
                {x=w*.07+ w*.04 + xpos,y=0},
                {x=w*.07 + xpos,y=h},
                {x=0 + xpos,y=h},
            })
            xpos = xpos + w*.095
        end
        if (10 - n) != 0 then
            surface.SetDrawColor(80,80,80,255*self.alpha)
            for i=1,(10-n) do
                surface.DrawPoly({
                    {x=0 + w*.04 + xpos,y=0},
                    {x=w*.07+ w*.04 + xpos,y=0},
                    {x=w*.07 + xpos,y=h},
                    {x=0 + xpos,y=h},
                })
                xpos = xpos + w*.095
            end
        end
    end

    self.specpnl_dmg = vgui.Create("DPanel", self.SPEC)
    self.specpnl_dmg:SetSize(sw*(.06/aw),sh*(.02/ah))
    self.specpnl_dmg:SetPos(sw*(.01/aw),sh*(.057/ah))
    self.specpnl_dmg.n = 4
    self.specpnl_dmg.Paint = function(me,w,h)
        SPECDraw(w,h,me.n)
    end

    self.specpnl_acc = vgui.Create("DPanel", self.SPEC)
    self.specpnl_acc:SetSize(sw*(.06/aw),sh*(.02/ah))
    self.specpnl_acc:SetPos(sw*(.01/aw),sh*(.087/ah))
    self.specpnl_acc.n = 4
    self.specpnl_acc.Paint = function(me,w,h)
        SPECDraw(w,h,me.n)
    end

    self.specpnl_temp = vgui.Create("DPanel", self.SPEC)
    self.specpnl_temp:SetSize(sw*(.06/aw),sh*(.02/ah))
    self.specpnl_temp:SetPos(sw*(.01/aw),sh*(.117/ah))
    self.specpnl_temp.n = 4
    self.specpnl_temp.Paint = function(me,w,h)
        SPECDraw(w,h,me.n)
    end

    self.specpnl_mob = vgui.Create("DPanel", self.SPEC)
    self.specpnl_mob:SetSize(sw*(.06/aw),sh*(.02/ah))
    self.specpnl_mob:SetPos(sw*(.01/aw),sh*(.147/ah))
    self.specpnl_mob.n = 4
    self.specpnl_mob.Paint = function(me,w,h)
        SPECDraw(w,h,me.n)
    end

    self.specpnl_stab = vgui.Create("DPanel", self.SPEC)
    self.specpnl_stab:SetSize(sw*(.06/aw),sh*(.02/ah))
    self.specpnl_stab:SetPos(sw*(.01/aw),sh*(.176/ah))
    self.specpnl_stab.n = 4
    self.specpnl_stab.Paint = function(me,w,h)
        SPECDraw(w,h,me.n)
    end

    self.rt = vgui.Create("DLabel", self.spec_desc_l)
    self.rt:Dock(FILL)
    self.rt:SetAutoStretchVertical(true)
    self.rt:SetFont("lotr.font.arsenal.spec.modify")
    self.rt:SetWrap(true)

    self.l_VIEW = vgui.Create("DPanel", self)
    self.l_VIEW:SetSize(sw*(.8),sh*(.54))
    self.l_VIEW:Center()
    self.l_VIEW:SetY(sh*(.15))
    self.l_VIEW.Paint = nil

    self.VIEW = vgui.Create("DModelPanel", self.l_VIEW)
    self.VIEW.mx = 0
    self.VIEW.ang = Angle(0,135,0)
    self.VIEW.restore = 0
    self.VIEW:Dock(FILL)
    self.VIEW:SetModel("models/fisher/dc17s/dc17s.mdl")
    self.VIEW.LayoutEntity = function(me,Entity) 
        Entity:SetAngles(me.ang)
    end
    self.VIEW:SetLookAt(Vector(0,0,0))
    self.VIEW:SetCamPos(self.vpos)
    self.VIEW.capture = false

    self.VIEW.OnMousePressed = function(me, mc)
        me:MouseCapture(true)
        me.capture = true
        me.mx = gui.MouseX()
        me.restore = me.ang.y
    end

    self.VIEW.OnMouseReleased = function(me, mc)
        me:MouseCapture(false)
        me.capture = false
    end
    self.VIEW.Think = function(me)
        if me.capture then
            me.ang.y = me.restore - (me.mx - gui.MouseX())
        else
            me.ang.y = (RealTime()*10%360)
        end
        me:SetModel(self.model)
        me:SetCamPos(self.vpos)
        me:SetLookAt(self.vlook)
    end

    self:LOAD()

    -- BUTTONS PREV & NEXT

    self.NEXT = vgui.Create("DButton", self)
    self.NEXT:SetPos(sw*(.96),sh*(.5))
    self.NEXT:SetSize(sw*(.02/aw),sh*(.035/ah))
    self.NEXT:SetText("")
    self.NEXT._anim = 0
    self.NEXT.Paint = function(me,w,h)
        surface.SetDrawColor(255,255,255,255*self.alpha)
        surface.SetMaterial(Material("lotr/next.png"))
        surface.DrawTexturedRect(0 + w*.125,0 + h*.2,w*.75,h*.6)
    end
    self.NEXT.DoClick = function(me)
        self:nextwpn()
    end

    self.PREV = vgui.Create("DButton", self)
    self.PREV:SetPos(sw*(.02),sh*(.5))
    self.PREV:SetSize(sw*(.02/aw),sh*(.035/ah))
    self.PREV:SetText("")
    self.PREV._anim = 0
    self.PREV.Paint = function(me,w,h)
        surface.SetDrawColor(255,255,255,255*self.alpha)
        surface.SetMaterial(Material("lotr/prev.png"))
        surface.DrawTexturedRect(0 + w*.125,0 + h*.2,w*.75,h*.6)
    end
    self.PREV.DoClick = function(me)
        self:prevwpn()
    end

    self.pickup = vgui.Create("DPanel", self)
    self.pickup:SetPos(sw*(.8),sh*(.8))
    self.pickup:SetSize(sw*(.1/aw),sh*(.05/ah))
    self.pickup:SetText("")
    self.pickup.Paint = function(me,w,h)
        surface.SetDrawColor(255,255,255,255*self.alpha)
        surface.DrawLine(0,0,0,h)
        surface.DrawLine(w*.99,0,w*.99,h)
        --DrawOutRect(w, h, w*.1, h*.04)
    end
    self.pickup_key = vgui.Create("DPanel", self.pickup)
    self.pickup_key:SetPos(sw*(.01/aw),sh*(.008/ah))
    self.pickup_key:SetSize(sw*(.02/aw),sh*(.035/ah))
    self.pickup_key:SetText("")
    self.pickup_key.Paint = function(me,w,h)
        surface.SetDrawColor(255,255,255,255*self.alpha)
        DrawOutRect(w, h, w*.4, h*.1)
        draw.SimpleText("E", "lotr.font.arsenal.btn", w*.3, h*.35, Color(255,255,255,255*self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.pickup_btn = vgui.Create("DButton", self.pickup)
    self.pickup_btn:SetPos(sw*(.04/aw),sh*(.008/ah))
    self.pickup_btn:SetSize(sw*(.05/aw),sh*(.035/ah))
    self.pickup_btn:SetText("")
    self.pickup_btn._anim = 0
    self.pickup_btn.Paint = function(me,w,h)
        if me:IsHovered() and me:IsEnabled() then
            me._anim = math.Clamp(me._anim + 15 * FrameTime(), 0, 1)
        else
            me._anim = math.Clamp(me._anim - 15 * FrameTime(), 0, 1)
        end
        draw.SimpleText("Взять", "lotr.font.arsenal.btn2", w*.5, h*.5, Color(255,255,255,255*self.alpha - 255*me._anim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Взять", "lotr.font.arsenal.btn2", w*.5, h*.5, Color(241,199,25,255*self.alpha*me._anim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.pickup_btn.DoClick = function(me)
        self:Pick()
    end

    self.put_btn = vgui.Create("DButton", self.pickup)
    self.put_btn:SetPos(sw*(.035/aw),sh*(.008/ah))
    self.put_btn:SetSize(sw*(.06/aw),sh*(.035/ah))
    self.put_btn:SetText("")
    self.put_btn._anim = 0
    self.put_btn.Paint = function(me,w,h)
        if me:IsHovered() and me:IsEnabled() then
            me._anim = math.Clamp(me._anim + 15 * FrameTime(), 0, 1)
        else
            me._anim = math.Clamp(me._anim - 15 * FrameTime(), 0, 1)
        end
        draw.SimpleText("Положить", "lotr.font.arsenal.btn2", w*.5, h*.5, Color(255,255,255,255*self.alpha - 255*me._anim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Положить", "lotr.font.arsenal.btn2", w*.5, h*.5, Color(241,199,25,255*self.alpha*me._anim), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.put_btn.DoClick = function(me)
        self:Put()
    end
end
function pnl:Pick()
    net.Start("lotr.ars_pick")
    net.WriteString(self.tbl[self.s_wpn].path)
    net.SendToServer()
end
function pnl:Put()
    net.Start("lotr.ars_put")
    net.WriteString(self.tbl[self.s_wpn].path)
    net.SendToServer()
end
function pnl:Think()
    self.alpha = math.Clamp(self.alpha + 3 * FrameTime(), 0, 1)
    if self.s_wpn > 1 then
        self.PREV:SetVisible(true)
    else
        self.PREV:SetVisible(false)
    end
    if self.s_wpn < #self.tbl then
        self.NEXT:SetVisible(true)
    else
        self.NEXT:SetVisible(false)
    end
    if self.tbl[1] then
        self.model = self.tbl[self.s_wpn].model
        self.vpos = self.tbl[self.s_wpn].vpos
        self.vlook = self.tbl[self.s_wpn].vlook
        self.spec_name = self.tbl[self.s_wpn].name
        self.spec_desc = self.tbl[self.s_wpn].desc
        --
        if self.rt:GetText() != self.spec_desc then
            self.rt:SetText(self.spec_desc)
        end
        --
        self.specpnl_dmg.n = self.tbl[self.s_wpn].mod.dmg
        self.specpnl_acc.n = self.tbl[self.s_wpn].mod.acc
        self.specpnl_temp.n = self.tbl[self.s_wpn].mod.temp
        self.specpnl_mob.n = self.tbl[self.s_wpn].mod.mob
        self.specpnl_stab.n = self.tbl[self.s_wpn].mod.stab
        self.aviable = false
        for k,v in pairs(LocalPlayer():GetWeapons()) do
            if v:GetClass() == self.tbl[self.s_wpn].path then
                self.aviable = true
            end
        end
        if self.aviable then
            self.put_btn:SetVisible(true)
            self.pickup_btn:SetVisible(false)
        else
            self.put_btn:SetVisible(false)
            self.pickup_btn:SetVisible(true)
        end
    else
        self.model = ""
    end
end
function pnl:Paint(w,h)
    DrawBlur(self,10,255*self.alpha)
    surface.SetDrawColor(0,0,0,160*self.alpha)
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor(80,80,80,225)
    surface.SetMaterial(Material("lotr/logo.png"))
    surface.DrawTexturedRect(w*.3,h*.05,w*.4,h*.9)
end
function pnl:nextwpn()
    if self.s_wpn < #self.tbl then
        self.s_wpn = self.s_wpn + 1
        self.VIEW.ang = Angle(0,135,0)
    end
end
function pnl:prevwpn()
    if self.s_wpn > 1 then
        self.s_wpn = self.s_wpn - 1
        self.VIEW.ang = Angle(0,135,0)
    end
end
function pnl:LOAD()
    self.tbl = {}
    for k,v in pairs(LOTR_PLAYER_WEAPON_ACCESS) do
        if v.group == self.select then
            table.insert(self.tbl, v)
        end
    end
    self.s_wpn = 1
end
function pnl:Pistols()
    self.select = 1
    self.crt_text = "Бластерные пистолеты"
    self:LOAD()
end
function pnl:Blasters()
    self.select = 2
    self.crt_text = "Бластерные винтовки"
    self:LOAD()
end
function pnl:Others()
    self.select = 3
    self.crt_text = "Тяжелое оружие"
    self:LOAD()
end
function pnl:Snipers()
    self.crt_text = "Снайперские бластеры"
    self.select = 4
    self:LOAD()
end
function pnl:OnKeyCodePressed(key)
    if key == 34 then
        self:Remove()
    end
    if key == 2 then
        self:Pistols()
    end
    if key == 3 then
        self:Blasters()
    end
    if key == 4 then
        self:Others()
    end
    if key == 5 then
        self:Snipers()
    end
    if key == 89 or key == 11 then
        self:prevwpn()
    end
    if key == 91 or key == 14 then
        self:nextwpn()
    end
    if key == 15 then
        for k,v in pairs(LocalPlayer():GetWeapons()) do
            if self.aviable then
                self:Put()
            else
                self:Pick()
            end
        end
    end
    return true
end

function pnl:OnMousePressed(code)
    return true
end

derma.DefineControl('lotr.arsenal', '', pnl, 'EditablePanel')

local function LOTR_ARS_OPEN()
    local main = vgui.Create("lotr.arsenal")
end

net.Receive("lotr.ars_open", LOTR_ARS_OPEN)