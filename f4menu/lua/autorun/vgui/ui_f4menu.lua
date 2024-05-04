print("$[F4MENU] VGUI loaded")
local sw, sh = ScrW(), ScrH()
local aw = sw / 1920
local ah = sh / 1080


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
local function DrawCircle(iPosX, iPosY, iRadius, iVertices, bCache)
    iPosX = iPosX or 0
    iPosY = iPosY or 0
    iRadius = iRadius or 100
    iVertices = iVertices or 200 -- the more vertices, the better the quality
    
    local circle = {}
    local i = 0
    for ang = 1, 360, (360/iVertices) do
        i = i + 1
        circle[i] = {
            x = iPosX + (math.cos(math.rad(ang))) * iRadius, 
            y = iPosY + (math.sin(math.rad(ang))) * iRadius, 
        }
    end

    if bCache then
        return circle
    end
    
    surface.DrawPoly(circle)
end

surface.CreateFont("lotr.font.f4menu.title", {
	font = "Montserrat",
	size = (sw+sh)*(.012/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
})

surface.CreateFont("lotr.font.f4menu.header", {
	font = "Montserrat ExtraLight",
	size = (sw+sh)*(.019/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
})

surface.CreateFont("lotr.font.f4menu.header_glow", {
	font = "Montserrat ExtraLight",
	size = (sw+sh)*(.019/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
    blursize = 0,
})

surface.CreateFont("lotr.font.f4menu.btn", {
	font = "Montserrat ExtraLight",
	size = (sw+sh)*(.012/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
})

surface.CreateFont("lotr.font.f4menu.btn_02", {
	font = "Montserrat Light",
	size = (sw+sh)*(.012/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
})

surface.CreateFont("lotr.font.f4menu.btn_03", {
	font = "Montserrat SemiBold",
	size = (sw+sh)*(.014/(aw+ah)),
	weight = 10,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
})

local header = {}

function header:Init()
    self.lotr_lens = Material("lotr/lens.png")
    self._title = "Header"
    self:Dock(TOP)
    self:SetTall(sh*(.05/ah))
end
function header:SetTitle(txt)
    self._title = txt
end
function header:Paint(w,h)
    surface.SetDrawColor(color_white)
    --surface.DrawRect(0,0,w,h)
    draw.SimpleText(self._title, "lotr.font.f4menu.header_glow", w/2, h*.125, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(self._title, "lotr.font.f4menu.header", w/2, h*.125, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    surface.SetDrawColor(255,255,255,255)
    surface.SetMaterial(self.lotr_lens)
    surface.DrawTexturedRect(w*.35, 0, w*.3, h)
end

derma.DefineControl('lotr.header', '', header, 'EditablePanel')
--claim
local claim = {}

function claim:Init()
    self._title = "ClaimPlayer"
    self._priory = 3
    self._ply = Entity(1)
    self._tbl_priory = {
        ["1"] = "Низкий",
        ["2"] = "Средний",
        ["3"] = "Высокий",
    }
    self._tbl_priory_clr = {
        ["1"] = Color(104, 199, 70),--"Низкий",
        ["2"] = Color(241, 199, 25),--"Средний",
        ["3"] = Color(199, 104, 75),--"Высокий",
    }
    self:Dock(TOP)
    self:DockMargin(0,sh*(.005/ah),0,0)
    self:SetTall(sh*(.05/ah))

    self.avatar = vgui.Create("AvatarImage", self)
    self.avatar:SetSize(sw*(.025/aw), sh*(.044/ah))
    self.avatar:SetPos(sw*(.002/aw), sh*(.004/ah))

    self.btn1 = vgui.Create("DButton", self)
    self.btn1:SetSize(sw*(.08/aw), sh*(.022/ah))
    self.btn1:SetPos(sw*(.34/aw), sh*(.03/ah))
    self.btn1:SetText("")
    self.btn1._anim = 0
    self.btn1.Paint = function(me,w,h)
        if me:IsHovered() then
            me._anim = math.Clamp(me._anim + 10 * FrameTime(), 0, 1)
        else
            me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(198,164,73,255)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0, y=h},
            {x=0 + w*.15, y=0},
            {x=w - w*.15, y=0},
            {x=w, y=h},
        })
        surface.SetDrawColor(218,184,93,255 * me._anim)
        surface.DrawPoly({
            {x=0, y=h},
            {x=0 + w*.15, y=0},
            {x=w - w*.15, y=0},
            {x=w, y=h},
        })
        draw.SimpleText("Принять", "lotr.font.f4menu.btn_03", w/2, h/2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.btn1.DoClick = function(me)
        self:MoveTo(self:GetX() + self:GetWide(), self:GetY(), 0.2, 0, -1, function()
            self:Remove()
        end)
        local tbl = {
            ["ply"] = self._ply,
            ["str"] = LocalPlayer():Name().." принял вашу жалобу"
        }
        net.Start("lotr.f4menu_admin_reply")
        net.WriteTable(tbl)
        net.SendToServer()
    end
    self.btn2 = vgui.Create("DButton", self)
    self.btn2:SetSize(sw*(.08/aw), sh*(.022/ah))
    self.btn2:SetPos(sw*(.43/aw), sh*(.03/ah))
    self.btn2:SetText("")
    self.btn2._anim = 0
    self.btn2.Paint = function(me,w,h)
        if me:IsHovered() then
            me._anim = math.Clamp(me._anim + 10 * FrameTime(), 0, 1)
        else
            me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(198,164,73,255)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0, y=h},
            {x=0 + w*.15, y=0},
            {x=w - w*.15, y=0},
            {x=w, y=h},
        })
        surface.SetDrawColor(218,184,93,255 * me._anim)
        surface.DrawPoly({
            {x=0, y=h},
            {x=0 + w*.15, y=0},
            {x=w - w*.15, y=0},
            {x=w, y=h},
        })
        draw.SimpleText("Отклонить", "lotr.font.f4menu.btn_03", w/2, h/2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.btn2.DoClick = function(me)
        self:MoveTo(self:GetX() + self:GetWide(), self:GetY(), 0.2, 0, -1, function()
            self:Remove()
        end)
        local tbl = {
            ["ply"] = self._ply,
            ["str"] = LocalPlayer():Name().." отклонил вашу жалобу"
        }
        net.Start("lotr.f4menu_admin_reply")
        net.WriteTable(tbl)
        net.SendToServer()
    end
end
function claim:SetClaim(arg1, arg2, arg3)
    self._priory = arg1
    self._title = arg2
    self._ply = arg3
    self.avatar:SetPlayer(self._ply, 48)
end
function claim:Paint(w,h)
    local hw, hh = (w/2), (h/2)
    surface.SetDrawColor(68,68,68,255)
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor(45,45,45,255)
    draw.NoTexture()
    surface.DrawPoly({
        {x=hw - w*.1,y=0},
        {x=hw + w*.1,y=0},
        {x=hw + w*.075,y=h*.4},
        {x=hw - w*.075,y=h*.4},
    })
    draw.SimpleText(self._tbl_priory[self._priory], "lotr.font.f4menu.btn_03", w/2, h*.2, self._tbl_priory_clr[self._priory], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(self._ply:Name(), "lotr.font.f4menu.btn_02", w*.055, h*.35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText("STEAMID: "..self._ply:SteamID(), "lotr.font.f4menu.btn_02", w*.055, h*.65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(self._title, "lotr.font.f4menu.btn_03", w/2, h*.7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

derma.DefineControl('lotr.claim', '', claim, 'EditablePanel')
--comment
local comment = {}

function comment:Init()
    self._text = "Comment"
    self:Dock(TOP)
    self:SetTall(sh*(.035/ah))
end
function comment:SetText(txt)
    self._text = txt
end
function comment:Paint(w,h)
    draw.SimpleText(self._text, "lotr.font.f4menu.btn_02", w*.025, h/2, Color(150,150,150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

derma.DefineControl('lotr.option_comment', '', comment, 'EditablePanel')

--qmenu
local qmenu = {}

function qmenu:Init()
    self.name = "CFT|K1sel0ff"
    self.tbl = {
        ent = LocalPlayer(),
        count = 0
    }

    self:SetPos(0,0)
    self:SetSize(sw,sh)
    self:MakePopup()

    self.frame = vgui.Create("EditablePanel", self)
    self.frame:SetSize(sw*(.4/aw), sh*(.1/ah))
    self.frame:Center()
    self.frame.Paint = function(me,w,h)
        surface.SetDrawColor(65,65,65,255)
        surface.DrawRect(0,0,w,h)
    end

    self.ttl = vgui.Create("DPanel", self.frame)
    self.ttl:Dock(TOP)
    self.ttl:SetTall(sh*(.02/ah))
    self.ttl.Paint = function(me,w,h)
        surface.SetDrawColor(40,40,40,255)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("Транзакция", "lotr.font.f4menu.title", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    self.close = vgui.Create("DButton", self.ttl)
    self.close:Dock(RIGHT)
    self.close:SetWide(sw*(.02/aw))
    self.close:SetText("")
    self.close.Paint = function(me,w,h)
        surface.SetDrawColor(223,40,40,255)
        surface.DrawRect(0,0,w,h)
    end
    self.close.DoClick = function(me)
        self:Remove()
    end

    self.ply = vgui.Create("DPanel", self.frame)
    self.ply:SetSize(sw*(.08/aw), sh*(.03/ah))
    self.ply:SetPos(sw*(.01/aw), sh*(.03/ah))
    self.ply.Paint = function(me,w,h)
        surface.SetDrawColor(90,90,90,255)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText(self.tbl.ent, "lotr.font.f4menu.btn_02", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.ply_txt = vgui.Create("DPanel", self.frame)
    self.ply_txt:SetSize(sw*(.15/aw), sh*(.03/ah))
    self.ply_txt:SetPos(sw*(.09/aw), sh*(.03/ah))
    self.ply_txt.Paint = function(me,w,h)
        draw.SimpleText("Получит от вас ", "lotr.font.f4menu.btn_02", w*.015, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    self.count = vgui.Create("DPanel", self.frame)
    self.count:SetSize(sw*(.05/aw), sh*(.03/ah))
    self.count:SetPos(sw*(.142/aw), sh*(.03/ah))
    self.count.Paint = function(me,w,h)
        surface.SetDrawColor(90,90,90,255)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText(self.tbl.count, "lotr.font.f4menu.btn_02", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.count_txt = vgui.Create("DPanel", self.frame)
    self.count_txt:SetSize(sw*(.15/aw), sh*(.03/ah))
    self.count_txt:SetPos(sw*(.192/aw), sh*(.03/ah))
    self.count_txt.Paint = function(me,w,h)
        draw.SimpleText("кредитов.    Вы уверены?", "lotr.font.f4menu.btn_02", w*.015, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    self.btn = vgui.Create("DButton", self.frame)
    self.btn:SetSize(sw*(.1/aw), sh*(.03/ah))
    self.btn:SetPos(sw*(.28/aw), sh*(.06/ah))
    self.btn:SetText("")
    self.btn.Paint = function(me,w,h)
        surface.SetDrawColor(241,199,25,255)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("Подтвердить", "lotr.font.f4menu.btn_03", w/2, h/2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.btn.DoClick = function(me)
        self:Remove()
        net.Start("lotr.f4menu_credit")
        net.WriteTable(self.tbl)
        net.SendToServer()
    end
end
function qmenu:SetTable(tbl)
    self.tbl = tbl
end
function qmenu:Paint(w,h)
    DrawBlur(self, 3, 200)
end

derma.DefineControl('lotr.qmenu', '', qmenu, 'EditablePanel')


--qmenu
local qmenu2 = {}

function qmenu2:Init()

    self._bmap = true

    self:SetPos(0,0)
    self:SetSize(sw,sh)
    self:MakePopup()

    self.frame = vgui.Create("EditablePanel", self)
    self.frame:SetSize(sw*(.4/aw), sh*(.13/ah))
    self.frame:Center()
    self.frame.Paint = function(me,w,h)
        surface.SetDrawColor(65,65,65,255)
        surface.DrawRect(0,0,w,h)
    end

    self.ttl = vgui.Create("DPanel", self.frame)
    self.ttl:Dock(TOP)
    self.ttl:SetTall(sh*(.02/ah))
    self.ttl.Paint = function(me,w,h)
        surface.SetDrawColor(40,40,40,255)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("Ивент-меню", "lotr.font.f4menu.title", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    self.close = vgui.Create("DButton", self.ttl)
    self.close:Dock(RIGHT)
    self.close:SetWide(sw*(.02/aw))
    self.close:SetText("")
    self.close.Paint = function(me,w,h)
        surface.SetDrawColor(223,40,40,255)
        surface.DrawRect(0,0,w,h)
    end
    self.close.DoClick = function(me)
        self:Remove()
    end
    if self._bmap then
        self.cm = vgui.Create("lotr.combo_map", self.frame)
        self.cm:SetText("Карта: ")
        self.cm:RefreshCombo()
    end

    self.cs = vgui.Create("lotr.combo_sound", self.frame)
    self.cs:SetText("Фоновая музыка: ")
    self.cs:RefreshCombo()

    --self.void = vgui.Create("lotr.option_comment", self.frame)
    --self.void:SetText("")

    self.btn = vgui.Create("lotr.option_button", self.frame)
    self.btn:SetText("Начать", "Начато")

    self.click = self.btn.btn
    self.click.DoClick = function(me)
        self:Remove()
    end
end
function qmenu2:SetBool(b)
    self._bmap = b
end
function qmenu2:Think()
    if !self._bmap then
        self.cm:Remove()
    end
end
function qmenu2:Paint(w,h)
    DrawBlur(self, 3, 200)
end

derma.DefineControl('lotr.qmenu2', '', qmenu2, 'EditablePanel')
--btn
local button = {}

function button:Init()
    self._text = "Button"
    self._text2 = "Button2"
    self._anim = 0
    self:Dock(TOP)
    self:SetTall(sh*(.035/ah))

    self.btn = vgui.Create("DButton", self)
    self.btn:Dock(LEFT)
    self.btn:DockMargin(sw*(.025/aw),sh*(.0025/ah),0,sh*(.0025/ah))
    self.btn:SetWide(sw*(.1/aw))
    self.btn:SetText("")
    self.btn.Paint = function(me,w,h)
        self._anim = math.Clamp(self._anim - 2 * FrameTime(), 0, 1)
        surface.SetDrawColor(198,164,23,255)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(248,214,73,255 * self._anim)
        surface.DrawRect(0,0,w,h)
        if self._anim > 0 then
            draw.SimpleText(self._text2, "lotr.font.f4menu.btn_03", w/2, h/2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(self._text, "lotr.font.f4menu.btn_03", w/2, h/2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end
function button:SetText(txt, txt2)
    self._text = txt
    self._text2 = txt2
end
function button:Paint(w,h)
end

derma.DefineControl('lotr.option_button', '', button, 'EditablePanel')
--SLIDER
local option01 = {}

function option01:Init()
    self._text = "Option"
    self._num = 1
    self:Dock(TOP)
    self:SetTall(sh*(.035/ah))

    self.layout = vgui.Create("DPanel", self)
    self.layout:SetSize(sw*(.2/aw), sh*(.02/ah))
    self.layout.Paint = function(me,w,h)
        surface.SetDrawColor(65,65,65,255)
        surface.DrawRect(0,0,w,h)
    end

    self.slider = vgui.Create("DSlider", self.layout)
    self.slider:Dock(FILL)
    self.slider:DockMargin(sw*(.0025/aw),0,sw*(.0025/aw),0)
    self.slider:SetTrapInside(true)
    self.slider:SetSlideX(0)
    self.slider.Knob:LerpPositions(2, false)
    self.slider.Knob.Paint = function(me,w,h)
        surface.SetDrawColor(198,164,23,255)
        surface.DrawRect(0,0,w,h)
    end
    self.slider.OnValueChanged = function(me,x,y)
        self:change(self._num * x)
    end
end
function option01:RefreshSlider()
    surface.SetFont("lotr.font.f4menu.btn")
    local w, h = surface.GetTextSize(self._text)
    --self.layout:SetPos(self:GetWide()*.5 + w + sw*(.01/aw), self:GetTall()/2 - sh*(.0075/ah))
    self.layout:SetPos(sw*(.11/aw), sh*(.0075/ah))
end
function option01:SetNum(n)
    self._num = n
end
function option01:SetText(txt)
    self._text = txt
end
function option01:change(n)
    print(n)
end
function option01:Paint(w,h)
    surface.SetDrawColor(color_white)
    --surface.DrawRect(0,0,w,h)
    draw.SimpleText(self._text, "lotr.font.f4menu.btn", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

derma.DefineControl('lotr.option_slider', '', option01, 'EditablePanel')
--SWITCHER
local option02 = {}

function option02:Init()
    self._text = "Switch"
    self._bool = false
    self:Dock(TOP)
    self:SetTall(sh*(.035/ah))

    -- Pre-compute text size and layout position
    surface.SetFont("lotr.font.f4menu.btn")
    local textWidth, textHeight = surface.GetTextSize(self._text)
    local layoutX = sw*(.11/aw)  -- Adjust spacing as needed
    local layoutY = sh*(.0075/ah)

    self.layout = vgui.Create("DPanel", self)
    self.layout:SetSize(sw*(.02/aw), sh*(.02/ah))
    self.layout:SetPos(layoutX, layoutY)  -- Set position directly
    self.layout.Paint = function(me,w,h)
        surface.SetDrawColor(65,65,65,255)
        surface.DrawRect(0,0,w,h)
    end

    self.switch = vgui.Create("DButton", self.layout)
    self.switch:Dock(FILL)
    self.switch:DockMargin(sw*(.0025/aw), sh*(.0035/ah), sw*(.0025/aw), sh*(.0035/ah))
    self.switch:SetText("")
    self.switch.Paint = function(me,w,h)
        surface.SetDrawColor(198,164,23,255)
        if !self._bool then
            surface.DrawRect(0,0,w/2,h)
        else
            surface.DrawRect(w*.5,0,w/2,h)
        end
    end
    self.switch.DoClick = function(me)
        self._bool = !self._bool
        self:change(self._bool)
    end
end
function option02:change(bool)
    print(bool)
end
function option02:SetText(txt)
    self._text = txt
end
function option02:Paint(w,h)
    draw.SimpleText(self._text, "lotr.font.f4menu.btn", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

derma.DefineControl('lotr.option_switch', '', option02, 'EditablePanel')
--COMBOBOXER
local option03 = {}

function option03:Init()
    self._text = "Combo"
    self._btn_text = "Выберите игрока"
    self._bool = false
    self:Dock(TOP)
    self:SetTall(sh*(.035/ah))
    self.layout = vgui.Create("DPanel", self)
    self.layout:SetSize(sw*(.15/aw), sh*(.02/ah))
    self.layout.Paint = function(me,w,h)
        surface.SetDrawColor(45,45,45,255)
        surface.DrawRect(0,0,w,h)
    end
    self.combo = vgui.Create("DButton", self.layout)
    self.combo:Dock(FILL)
    self.combo:SetText("")
    self.combo.Paint = function(me,w,h)
        surface.SetDrawColor(65,65,65,255)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText(self._btn_text, "lotr.font.f4menu.btn_02", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    self.combo.DoClick = function(me)
        me.Menu = DermaMenu(false, self.combo)
        me.Menu:SetMinimumWidth(me:GetWide())
        for k,v in ipairs(player.GetAll()) do
            me.btn = me.Menu:AddOption(v:Name(), function()
                self._btn_text = v:Name()
            end)
            me.btn:SetText("")
            me.btn._anim = 0
            me.btn.Paint = function(me,w,h)
                if me:IsHovered() then
                    me._anim = math.Clamp(me._anim + 10 * FrameTime(), 0, 1)
                else
                    me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
                end
                surface.SetDrawColor(45 + (45 * me._anim),45 + (45 * me._anim),45 + (45 * me._anim),255)
                surface.DrawRect(0,0,w,h)
                draw.SimpleText(v:Name(), "lotr.font.f4menu.btn_02", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            me.Menu:AddSpacer()
        end
        local x, y = me:LocalToScreen( 0, me:GetTall() )
        me.Menu:Open(x,y,false,me)
    end
end
function option03:RefreshCombo()
    surface.SetFont("lotr.font.f4menu.btn")
    local w, h = surface.GetTextSize(self._text)
    self.layout:SetPos(sw*(.08/aw)--[[self:GetWide()*.5 + w + sw*(.01/aw)]], self:GetTall()/2 - sh*(.0075/ah))
end
function option03:SetText(txt)
    self._text = txt
end
function option03:Paint(w,h)
    draw.SimpleText(self._text, "lotr.font.f4menu.btn", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

derma.DefineControl('lotr.option_combo', '', option03, 'EditablePanel')

--COMBOBOXER_map
local cm = {}

function cm:Init()
    self._text = "ComboMap"
    self._btn_text = "gm_flatgrass"
    self._bool = false
    self:Dock(TOP)
    self:SetTall(sh*(.035/ah))
    self.layout = vgui.Create("DPanel", self)
    self.layout:SetSize(sw*(.15/aw), sh*(.02/ah))
    self.layout.Paint = function(me,w,h)
        surface.SetDrawColor(45,45,45,255)
        surface.DrawRect(0,0,w,h)
    end
    self.combo = vgui.Create("DButton", self.layout)
    self.combo:Dock(FILL)
    self.combo:SetText("")
    self.combo.Paint = function(me,w,h)
        surface.SetDrawColor(40,40,40,255)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText(self._btn_text, "lotr.font.f4menu.btn_02", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    self.combo.DoClick = function(me)
        me.Menu = DermaMenu(false, self.combo)
        me.Menu:SetMinimumWidth(me:GetWide())
        me.btn = me.Menu:AddOption("gm_construct", function()
            self._btn_text = "gm_construct"
        end)
        me.btn:SetText("")
        me.btn._anim = 0
        me.btn.Paint = function(me,w,h)
            if me:IsHovered() then
                me._anim = math.Clamp(me._anim + 10 * FrameTime(), 0, 1)
            else
                me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
            end
            surface.SetDrawColor(45 + (45 * me._anim),45 + (45 * me._anim),45 + (45 * me._anim),255)
            surface.DrawRect(0,0,w,h)
            draw.SimpleText("gm_construct", "lotr.font.f4menu.btn_02", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        me.Menu:AddSpacer()
        local x, y = me:LocalToScreen( 0, me:GetTall() )
        me.Menu:Open(x,y,false,me)
    end
end
function cm:RefreshCombo()
    surface.SetFont("lotr.font.f4menu.btn")
    local w, h = surface.GetTextSize(self._text)
    self.layout:SetPos(self:GetWide()*.5 + w + sw*(.01/aw), self:GetTall()/2 - sh*(.0075/ah))
end
function cm:SetText(txt)
    self._text = txt
end
function cm:Paint(w,h)
    draw.SimpleText(self._text, "lotr.font.f4menu.btn", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

derma.DefineControl('lotr.combo_map', '', cm, 'EditablePanel')

--COMBOBOXER_sound
local cs = {}

function cs:Init()
    self._text = "ComboSound"
    self._btn_text = "None"
    self._bool = false
    self:Dock(TOP)
    self:SetTall(sh*(.035/ah))
    self.layout = vgui.Create("DPanel", self)
    self.layout:SetSize(sw*(.15/aw), sh*(.02/ah))
    self.layout.Paint = function(me,w,h)
        surface.SetDrawColor(45,45,45,255)
        surface.DrawRect(0,0,w,h)
    end
    self.combo = vgui.Create("DButton", self.layout)
    self.combo:Dock(FILL)
    self.combo:SetText("")
    self.combo.Paint = function(me,w,h)
        surface.SetDrawColor(40,40,40,255)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText(self._btn_text, "lotr.font.f4menu.btn_02", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    self.combo.DoClick = function(me)
        me.Menu = DermaMenu(false, self.combo)
        me.Menu:SetMinimumWidth(me:GetWide())
        me.btn = me.Menu:AddOption("None", function()
            self._btn_text = "None"
        end)
        me.btn:SetText("")
        me.btn._anim = 0
        me.btn.Paint = function(me,w,h)
            if me:IsHovered() then
                me._anim = math.Clamp(me._anim + 10 * FrameTime(), 0, 1)
            else
                me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
            end
            surface.SetDrawColor(45 + (45 * me._anim),45 + (45 * me._anim),45 + (45 * me._anim),255)
            surface.DrawRect(0,0,w,h)
            draw.SimpleText("None", "lotr.font.f4menu.btn_02", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        me.Menu:AddSpacer()
        --
        me.btn = me.Menu:AddOption("sound01", function()
            self._btn_text = "sound01"
        end)
        me.btn:SetText("")
        me.btn._anim = 0
        me.btn.Paint = function(me,w,h)
            if me:IsHovered() then
                me._anim = math.Clamp(me._anim + 10 * FrameTime(), 0, 1)
            else
                me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
            end
            surface.SetDrawColor(45 + (45 * me._anim),45 + (45 * me._anim),45 + (45 * me._anim),255)
            surface.DrawRect(0,0,w,h)
            draw.SimpleText("sound01", "lotr.font.f4menu.btn_02", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        me.Menu:AddSpacer()
        --
        me.btn = me.Menu:AddOption("sound02", function()
            self._btn_text = "sound02"
        end)
        me.btn:SetText("")
        me.btn._anim = 0
        me.btn.Paint = function(me,w,h)
            if me:IsHovered() then
                me._anim = math.Clamp(me._anim + 10 * FrameTime(), 0, 1)
            else
                me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
            end
            surface.SetDrawColor(45 + (45 * me._anim),45 + (45 * me._anim),45 + (45 * me._anim),255)
            surface.DrawRect(0,0,w,h)
            draw.SimpleText("sound02", "lotr.font.f4menu.btn_02", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        me.Menu:AddSpacer()
        local x, y = me:LocalToScreen( 0, me:GetTall() )
        me.Menu:Open(x,y,false,me)
    end
end
function cs:RefreshCombo()
    surface.SetFont("lotr.font.f4menu.btn")
    local w, h = surface.GetTextSize(self._text)
    self.layout:SetPos(self:GetWide()*.5 + w + sw*(.01/aw), self:GetTall()/2 - sh*(.0075/ah))
end
function cs:SetText(txt)
    self._text = txt
end
function cs:Paint(w,h)
    draw.SimpleText(self._text, "lotr.font.f4menu.btn", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

derma.DefineControl('lotr.combo_sound', '', cs, 'EditablePanel')

--ENTRY
local option04 = {}

function option04:Init()
    self._text = "Option"
    self._count = 1000
    self._num = 1
    self:Dock(TOP)
    self:SetTall(sh*(.035/ah))

    self.layout = vgui.Create("DPanel", self)
    self.layout:SetSize(sw*(.0546/aw), sh*(.02/ah))
    self.layout.Paint = function(me,w,h)
        surface.SetDrawColor(65,65,65,255)
        surface.DrawRect(0,0,w,h)
    end
    self.layout.OnMouseWheeled = function(me, delta)
        if delta > 0 then
            self:Plus()
        else
            self:Minus()
        end
    end

    self.count = vgui.Create("DLabel", self.layout)
    self.count:Dock(LEFT)
    self.count:DockMargin(sw*(.0025/aw), sh*(.0035/ah), 0, sh*(.0035/ah))
    self.count:SetWide(self.count:GetWide() - sw*(.005/aw))
    self.count:SetFont("lotr.font.f4menu.btn_02")
    self.count:SetText(self._count)

    self.minus = vgui.Create("DButton", self.layout)
    self.minus:Dock(LEFT)
    self.minus:DockMargin(0, 0, sw*(.0015/aw), 0)
    self.minus:SetWide(self.minus:GetTall())
    self.minus:SetText("")
    self.minus._anim = 0
    self.minus.Paint = function(me,w,h)
        me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
        surface.SetDrawColor(45 + (40*me._anim),45 + (40*me._anim),45 + (40*me._anim),255)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("-", "lotr.font.f4menu.btn_02", w/2, h/2.25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.minus.DoClick = function(me)
        me._anim = 1
        self:Minus()
    end

    self.plus = vgui.Create("DButton", self.layout)
    self.plus:Dock(LEFT)
    self.plus:SetWide(self.plus:GetTall())
    self.plus:SetText("")
    self.plus._anim = 0
    self.plus.Paint = function(me,w,h)
        me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
        surface.SetDrawColor(45 + (40*me._anim),45 + (40*me._anim),45 + (40*me._anim),255)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("+", "lotr.font.f4menu.btn_02", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.plus.DoClick = function(me)
        me._anim = 1
        self:Plus()
    end
end
function option04:Plus()
    if self._count < 1000000 then
        self._count = self._count + 100
        self.count:SetText(self._count)
    end
end
function option04:Minus()
    if self._count > 100 then
        self._count = self._count - 100
        self.count:SetText(self._count)
    end
end
function option04:RefreshEntry()
    surface.SetFont("lotr.font.f4menu.btn")
    local w, h = surface.GetTextSize(self._text)
    self.layout:SetPos(self:GetWide()*.5 + w + sw*(.01/aw), self:GetTall()/2 - sh*(.0075/ah))
end
function option04:SetText(txt)
    self._text = txt
    self:RefreshEntry()
end
function option04:change(n)
    print(n)
end
function option04:Paint(w,h)
    draw.SimpleText(self._text, "lotr.font.f4menu.btn", w*.025, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

derma.DefineControl('lotr.option_entry', '', option04, 'EditablePanel')
--binder
local binder = {}

function binder:Init()
    self._text = "Binder"
    self._key = KEY_A
    self:Dock(TOP)
    self:SetTall(sh*(.035/ah))
    self.layout = vgui.Create("DPanel", self)
    self.layout:SetSize(sw*(.03/aw), sh*(.03/ah))
    self.layout.Paint = function(me,w,h)
        surface.SetDrawColor(65,65,65,255)
        surface.DrawRect(0,0,w,h)
    end
    self.binder = vgui.Create("DBinder", self.layout)
    self.binder:Dock(FILL)
    self.binder._anim = 0
    self.binder.OnChange = function(me, num)
        self._key = num
    end
    self.binder.Paint = function(me,w,h)
        if me.Trapping then
            me._anim = math.Clamp(me._anim + 10 * FrameTime(), 0, 1)
        else
            me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(65,65,65,255)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(198,164,23,150*me._anim)
        surface.DrawRect(0,0,w,h)
        if !(self._key == KEY_NONE) then
            draw.SimpleText(string.upper(input.GetKeyName(self._key)), "lotr.font.f4menu.btn", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
    self.binder.DoClick = function(me)
        input.StartKeyTrapping()
        me.Trapping = true
        self._key = KEY_NONE
    end
end
function binder:Refresh()
    surface.SetFont("lotr.font.f4menu.btn")
    local w, h = surface.GetTextSize(self._text)
    --self.layout:SetPos(self:GetWide()*.5 + w + sw*(.01/aw), self:GetTall()/2 - sh*(.0075/ah))
    self.layout:SetPos(sw*(.3/aw), sh*(.005/ah))
    --self.layout:SetPos(sw*(.3/aw), sh*(.0075/ah))
end
function binder:SetText(txt)
    self._text = txt
end
function binder:SetKey(key)
    self._key = key
end
function binder:Think()
    self.binder:SetText("")
end
function binder:Paint(w,h)
    draw.SimpleText(self._text, "lotr.font.f4menu.btn", w/2 - (w*.15), h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

derma.DefineControl('lotr.option_binder', '', binder, 'EditablePanel')

--checkbox
local checkbox = {}

function checkbox:Init()
    self._text = "Switch"
    self._bool = false
    self:Dock(TOP)
    self:SetTall(sh*(.035/ah))

    -- Pre-compute text size and layout position
    surface.SetFont("lotr.font.f4menu.btn")
    local textWidth, textHeight = surface.GetTextSize(self._text)
    local layoutX = sw*(.012/aw)  -- Adjust spacing as needed
    local layoutY = sh*(.0075/ah)

    self.layout = vgui.Create("DPanel", self)
    self.layout:SetSize(sw*(.011/aw), sh*(.02/ah))
    self.layout:SetPos(layoutX, layoutY)  -- Set position directly
    self.layout.Paint = function(me,w,h)
        surface.SetDrawColor(65,65,65,255)
        surface.DrawRect(0,0,w,h)
    end

    self.switch = vgui.Create("DButton", self.layout)
    self.switch:Dock(FILL)
    self.switch:SetText("")
    self.switch._anim = 0
    self.switch.Paint = function(me,w,h)
        if self._bool then
            me._anim = math.Clamp(me._anim + 10 * FrameTime(), 0, 1)
        else
            me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(65,65,65,255)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(198,164,23,255*me._anim)
        surface.DrawRect(0,0,w,h)
    end
    self.switch.DoClick = function(me)
        self._bool = !self._bool
        self:change(self._bool)
    end
end
function checkbox:change(bool)
    print(bool)
end
function checkbox:SetText(txt)
    self._text = txt
end
function checkbox:Paint(w,h)
    draw.SimpleText(self._text, "lotr.font.f4menu.btn", w*.05, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

derma.DefineControl('lotr.option_checkbox', '', checkbox, 'EditablePanel')

--Окно с настройками

local setting_panel = {}

function setting_panel:Init()
    self.vbar = self:GetVBar()
    self:GetCanvas():LerpPositions(1.5, false)
    self.vbar.btnGrip:LerpPositions(3, false)

    self.vbar.btnUp.Paint = nil
    self.vbar.btnDown.Paint = nil

    self.vbar.Paint = function(me,w,h)
        surface.SetDrawColor(40,40,40,50)
        surface.DrawRect(0,0,w,h)
    end

    self.vbar.btnGrip.Paint = function(me,w,h)
        surface.SetDrawColor(198,164,23,255)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0 + w*.6, y=0 + h*.1},
            {x=w, y=0},
            {x=w, y=h},
            {x=0 + w*.6, y=h - h*.1},
        })
    end

    self.vbar.BarScale = function(me)

        if ( me.BarSize == 0 ) then return 1 end
    
        return me.BarSize / (( me.CanvasSize + me.BarSize )*6)
    
    end

    self.panel1 = vgui.Create("lotr.header", self)
    self.panel1:SetTitle("Настройки")
    --Дальность прорисовки--
    self.option1 = vgui.Create("lotr.option_slider", self)
    self.option1:SetText("Дальность прорисовки")
    self.option1:RefreshSlider()
    self.option1:SetNum(20000)
    self.option1.change = function(me, n)
        lotr_fog = n + 1024
    end
    --Максимальное количество декалей
    self.option2 = vgui.Create("lotr.option_slider", self)
    self.option2:SetText("Количество декалей")
    self.option2:RefreshSlider()
    self.option2:SetNum(2040)
    self.option2.change = function(me, n)
        RunConsoleCommand("r_decals", n+8)
    end
    --fog switch
    self.option3 = vgui.Create("lotr.option_switch", self)
    self.option3:SetText("Включить туман")
    self.option3._bool = false
    self.option3.change = function(me, b)
        lotr_fog_bool = b
    end
    --void
    self.void1 = vgui.Create("lotr.option_comment", self)
    self.void1:SetText(" ")
    --stopsound
    self.btn1 = vgui.Create("lotr.option_button", self)
    self.btn1:SetText("Прервать звуки", "Прервано")
    self.click = self.btn1.btn
    self.click.DoClick = function(me)
        LocalPlayer():ConCommand("stopsound")
        self.btn1._anim = 1
    end
    --void
    self.void2 = vgui.Create("lotr.option_comment", self)
    self.void2:SetText(" ")
    --Громкость мечей
    self.option4 = vgui.Create("lotr.option_slider", self)
    self.option4:SetText("Громкость мечей")
    self.option4:RefreshSlider()
    self.option4:SetNum(2040)
    self.option4.change = function(me, n)
              
    end
    --Громкость [LFS]-техники
    self.option5 = vgui.Create("lotr.option_slider", self)
    self.option5:SetText("Громкость [LFS]-техники")
    self.option5:RefreshSlider()
    self.option5:SetNum(2040)
    self.option5.change = function(me, n)
        
    end
    --autorp
    self.option6 = vgui.Create("lotr.option_switch", self)
    self.option6:SetText("AutoRP")
    self.option6._bool = false
    self.option6.change = function(me, b)

    end

end


derma.DefineControl('lotr.setting_panel', '', setting_panel, 'DScrollPanel')

--Окно с биндами

local bind_panel = {}

function bind_panel:Init()
    self.vbar = self:GetVBar()
    self:GetCanvas():LerpPositions(1.5, false)
    self.vbar.btnGrip:LerpPositions(3, false)

    self.vbar.btnUp.Paint = nil
    self.vbar.btnDown.Paint = nil

    self.vbar.Paint = function(me,w,h)
        surface.SetDrawColor(40,40,40,50)
        surface.DrawRect(0,0,w,h)
    end

    self.vbar.btnGrip.Paint = function(me,w,h)
        surface.SetDrawColor(198,164,23,255)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0 + w*.6, y=0 + h*.1},
            {x=w, y=0},
            {x=w, y=h},
            {x=0 + w*.6, y=h - h*.1},
        })
    end

    self.vbar.BarScale = function(me)

        if ( me.BarSize == 0 ) then return 1 end
    
        return me.BarSize / (( me.CanvasSize + me.BarSize )*6)
    
    end

    self.panel1 = vgui.Create("lotr.header", self)
    self.panel1:SetTitle("Бинды")
    --flashlight
    self.bind1 = vgui.Create("lotr.option_binder", self)
    self.bind1:SetText("Фонарик")
    self.bind1:Refresh()
    self.bind1:SetKey(KEY_F)
    --lay
    self.bind2 = vgui.Create("lotr.option_binder", self)
    self.bind2:SetText("Лечь")
    self.bind2:Refresh()
    self.bind2:SetKey(KEY_Z)
    --jetpack
    self.bind3 = vgui.Create("lotr.option_binder", self)
    self.bind3:SetText("Джетпак")
    self.bind3:Refresh()
    self.bind3:SetKey(KEY_H)
    --anim
    self.bind4 = vgui.Create("lotr.option_binder", self)
    self.bind4:SetText("Быстрое меню анимаций")
    self.bind4:Refresh()
    self.bind4:SetKey(KEY_Y)
    
end


derma.DefineControl('lotr.bind_panel', '', bind_panel, 'DScrollPanel')

--Окно с жалобами

local admin_panel = {}

function admin_panel:Init()
    self.vbar = self:GetVBar()
    self:GetCanvas():LerpPositions(1.5, false)
    self.vbar.btnGrip:LerpPositions(3, false)

    self.vbar.btnUp.Paint = nil
    self.vbar.btnDown.Paint = nil

    self.vbar.Paint = function(me,w,h)
        surface.SetDrawColor(40,40,40,50)
        surface.DrawRect(0,0,w,h)
    end

    self.vbar.btnGrip.Paint = function(me,w,h)
        surface.SetDrawColor(198,164,23,255)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0 + w*.6, y=0 + h*.1},
            {x=w, y=0},
            {x=w, y=h},
            {x=0 + w*.6, y=h - h*.1},
        })
    end

    self.vbar.BarScale = function(me)

        if ( me.BarSize == 0 ) then return 1 end
    
        return me.BarSize / (( me.CanvasSize + me.BarSize )*6)
    
    end
    

    self.panel1 = vgui.Create("lotr.header", self)
    self.panel1:SetTitle("Жалобы")

    net.Receive("lotr.f4menu_admin", function()
        local arg = net.ReadTable()
        self.pnl = vgui.Create("lotr.claim", self)
        self.pnl:SetClaim(arg[1], arg[2], arg[3])
    end)

end


derma.DefineControl('lotr.admin_panel', '', admin_panel, 'DScrollPanel')

--Окно мини меню выбора персонажей

local pers_panel = {}

function pers_panel:Init()
    self.vbar = self:GetVBar()
    self:GetCanvas():LerpPositions(1.5, false)
    self.vbar.btnGrip:LerpPositions(3, false)

    self.vbar.btnUp.Paint = nil
    self.vbar.btnDown.Paint = nil

    self.vbar.Paint = function(me,w,h)
        surface.SetDrawColor(40,40,40,50)
        surface.DrawRect(0,0,w,h)
    end

    self.vbar.btnGrip.Paint = function(me,w,h)
        surface.SetDrawColor(198,164,23,255)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0 + w*.6, y=0 + h*.1},
            {x=w, y=0},
            {x=w, y=h},
            {x=0 + w*.6, y=h - h*.1},
        })
    end

    self.vbar.BarScale = function(me)

        if ( me.BarSize == 0 ) then return 1 end
    
        return me.BarSize / (( me.CanvasSize + me.BarSize )*6)
    
    end

    self.panel1 = vgui.Create("lotr.header", self)
    self.panel1:SetTitle("Персонажи")

    self._char = 1
    self.x_pos = sw*(.17/aw)
    self._anim = false

    self.layout = vgui.Create("DPanel", self)
    self.layout:SetPos(0 + self.x_pos, sh*(.05/ah))
    self.layout:SetSize(sw*(.52/aw), sh*(.3/ah))
    self.layout.Paint = function(me,w,h)
        surface.SetDrawColor(0,0,0,0)
        surface.DrawRect(0,0,w,h)
    end

    self.char1 = vgui.Create("DPanel", self.layout)
    self.char1:SetSize(sw*(.12/aw), sh*(.3/ah))
    self.char1:SetPos(sw*(.265/aw) - (self.char1:GetWide()/2) - (self.char1:GetWide()*1.4), 0)
    self.char1.Paint = function(me,w,h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(Material("lotr/pm 1.png"))
        surface.DrawTexturedRect(0,0,w,h)
    end

    self.char2 = vgui.Create("DPanel", self.layout)
    self.char2:SetSize(sw*(.12/aw), sh*(.3/ah))
    self.char2:SetPos(sw*(.265/aw) - (self.char1:GetWide()/2), 0)
    self.char2.Paint = function(me,w,h)
        surface.SetDrawColor(190,25,25,255)
        surface.SetMaterial(Material("lotr/pm 1.png"))
        surface.DrawTexturedRect(0,0,w,h)
    end

    self.char3 = vgui.Create("DPanel", self.layout)
    self.char3:SetSize(sw*(.12/aw), sh*(.3/ah))
    self.char3:SetPos(sw*(.265/aw) - (self.char1:GetWide()/2) + (self.char1:GetWide()*1.4), 0)
    self.char3.Paint = function(me,w,h)
        surface.SetDrawColor(190,25,25,255)
        surface.SetMaterial(Material("lotr/pm 1.png"))
        surface.DrawTexturedRect(0,0,w,h)
    end

    self.btn_n = vgui.Create("DButton", self)
    self.btn_n:SetSize(sw*(.015/aw), sh*(.025/ah))
    self.btn_n:SetPos(sw*(.005/aw), sh*(.2/ah))
    self.btn_n:SetText("")
    self.btn_n.Paint = function(me,w,h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(Material("lotr/prev.png"))
        surface.DrawTexturedRect(0,0,w,h)
    end
    self.btn_n.DoClick = function(me)
        self:Prev()
    end

    self.btn_n = vgui.Create("DButton", self)
    self.btn_n:SetSize(sw*(.015/aw), sh*(.025/ah))
    self.btn_n:SetPos(sw*(.51/aw), sh*(.2/ah))
    self.btn_n:SetText("")
    self.btn_n.Paint = function(me,w,h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(Material("lotr/next.png"))
        surface.DrawTexturedRect(0,0,w,h)
    end
    self.btn_n.DoClick = function(me)
        self:Next()
    end

    self.btn_buy = vgui.Create("DButton", self)
    self.btn_buy:SetSize(sw*(.1/aw), sh*(.04/ah))
    self.btn_buy:SetPos(sw*(.265/aw) - (self.btn_buy:GetWide()/2), sh*(.36/ah))
    self.btn_buy:SetText("")
    self.btn_buy.Paint = function(me,w,h)
        surface.SetDrawColor(55, 203, 52, 203)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("Купить слот", "lotr.font.f4menu.btn", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.btn_buy:SetVisible(false)

end
function pers_panel:Next()
    if self._char < 3 then
        self._char = self._char + 1
    end
    self._anim = true
end
function pers_panel:Prev()
    if self._char > 1 then
        self._char = self._char - 1
    end
    self._anim = true
end
function pers_panel:Think()
    if self._anim then
        if self._char == 2 then
            self.x_pos = 0
            self.btn_buy:SetVisible(true)
        elseif self._char == 1 then
            self.x_pos = sw*(.17/aw)
            self.btn_buy:SetVisible(false)
            --print(self.layout:GetY()/1080 .. " " .. self.layout:GetWide()/1920)
        else
            self.btn_buy:SetVisible(true)
            self.x_pos = -(sw*(.17/aw))
        end
        self.layout:MoveTo(0 + self.x_pos, sh*(.05/ah), .2, 0, -1)
    end
    self._anim = false
end

derma.DefineControl('lotr.pers_panel', '', pers_panel, 'DScrollPanel')

--Окно ивентов

local event_panel = {}

function event_panel:Init()
    self.vbar = self:GetVBar()
    self:GetCanvas():LerpPositions(1.5, false)
    self.vbar.btnGrip:LerpPositions(3, false)

    self.vbar.btnUp.Paint = nil
    self.vbar.btnDown.Paint = nil

    self.vbar.Paint = function(me,w,h)
        surface.SetDrawColor(40,40,40,50)
        surface.DrawRect(0,0,w,h)
    end

    self.vbar.btnGrip.Paint = function(me,w,h)
        surface.SetDrawColor(198,164,23,255)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0 + w*.6, y=0 + h*.1},
            {x=w, y=0},
            {x=w, y=h},
            {x=0 + w*.6, y=h - h*.1},
        })
    end

    self.vbar.BarScale = function(me)

        if ( me.BarSize == 0 ) then return 1 end
    
        return me.BarSize / (( me.CanvasSize + me.BarSize )*6)
    
    end

    self.panel1 = vgui.Create("lotr.header", self)
    self.panel1:SetTitle("Ивент-меню")
    --Кнопки победителей
    self.winners = vgui.Create("EditablePanel", self)
    self.winners:Dock(TOP)
    self.winners:SetTall(sh*(.05/ah))
    self.winners.Paint = function(me,w,h)

    end
    self.winbtn1 = vgui.Create("DButton", self.winners)
    self.winbtn1:SetSize(sw*(.1/aw), sh*(.03/ah))
    self.winbtn1:SetPos(sw*(.1/aw), sh*(.012/ah))
    self.winbtn1:SetText("")
    self.winbtn1.Paint = function(me,w,h)
        surface.SetDrawColor(0,100,192,255)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("Победа ВАР", "lotr.font.f4menu.btn_02", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.winbtn2 = vgui.Create("DButton", self.winners)
    self.winbtn2:SetSize(sw*(.1/aw), sh*(.03/ah))
    self.winbtn2:SetPos(sw*(.3/aw), sh*(.012/ah))
    self.winbtn2:SetText("")
    self.winbtn2.Paint = function(me,w,h)
        surface.SetDrawColor(216,63,63,255)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("Победа КНС/САД", "lotr.font.f4menu.btn_02", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    --Подготовка
    self.timebefore = vgui.Create("lotr.option_entry", self)
    self.timebefore:SetText("Подготовка к ивенту (мин)")
    self.timebefore._count = 1
    self.timebefore.count:SetText(self.timebefore._count)
    self.timebefore.Plus = function(me)
        if me._count < 60 then
            me._count = me._count + 1
            me.count:SetText(me._count)
        end
    end
    self.timebefore.Minus = function(me)
        if me._count > 1 then
            me._count = me._count - 1
            me.count:SetText(me._count)
        end
    end
    --Продолжительность
    self.timeafter = vgui.Create("lotr.option_entry", self)
    self.timeafter:SetText("Длительность ивента (мин)")
    self.timeafter._count = 1
    self.timeafter.count:SetText(self.timeafter._count)
    self.timeafter.Plus = function(me)
        if me._count < 60 then
            me._count = me._count + 1
            me.count:SetText(me._count)
        end
    end
    self.timeafter.Minus = function(me)
        if me._count > 1 then
            me._count = me._count - 1
            me.count:SetText(me._count)
        end
    end
    --Выдать/забрать у всего сервера фонарики
    self.cb1 = vgui.Create("lotr.option_checkbox", self)
    self.cb1:SetText("Выдать/забрать у всего сервера фонарики")
    self.cb1._bool = false
    self.cb1.change = function(me, b)

    end
    --Запросить оценку ивента
    self.cb2 = vgui.Create("lotr.option_checkbox", self)
    self.cb2:SetText("Запросить оценку ивента")
    self.cb2._bool = false
    self.cb2.change = function(me, b)
        
    end
    --Выдать/забрать у всего сервера монтировку
    self.cb3 = vgui.Create("lotr.option_checkbox", self)
    self.cb3:SetText("Выдать/забрать у всего сервера монтировку")
    self.cb3._bool = false
    self.cb3.change = function(me, b)
        
    end
    --Забрать у всего сервера оружие
    self.cb4 = vgui.Create("lotr.option_checkbox", self)
    self.cb4:SetText("Забрать у всего сервера оружие")
    self.cb4._bool = false
    self.cb4.change = function(me, b)
        
    end
    --Сохранить настройки после смены карты
    self.cb5 = vgui.Create("lotr.option_checkbox", self)
    self.cb5:SetText("Сохранить настройки после смены карты")
    self.cb5._bool = false
    self.cb5.change = function(me, b)
        
    end
    --Ивент со сменой карты
    self.cb6 = vgui.Create("lotr.option_checkbox", self)
    self.cb6:SetText("Ивент со сменой карты")
    self.cb6._bool = false
    self.cb6.change = function(me, b)
        
    end

    --Done
    self.btn = vgui.Create("lotr.option_button", self)
    self.btn:SetText("Начать", "Начато")

    self.click = self.btn.btn
    self.click.DoClick = function(me)
        local qmenu = vgui.Create("lotr.qmenu2")
        qmenu:SetBool(self.cb6._bool)
    end

end


derma.DefineControl('lotr.event_panel', '', event_panel, 'DScrollPanel')

--Окно переводов

local credit_panel = {}

function credit_panel:Init()

    self.scroll = vgui.Create("DScrollPanel", self)
    self.scroll:Dock(FILL)
    --Header
    self.panel1 = vgui.Create("lotr.header", self.scroll)
    self.panel1:SetTitle("Кредиты")
    --Combobox
    self.combo = vgui.Create("lotr.option_combo", self.scroll)
    self.combo:SetText("Получатель:")
    self.combo:RefreshCombo()
    --dTextEntry
    self.entry = vgui.Create("lotr.option_entry", self.scroll)
    self.entry:SetText("Введите сумму")
    --Comment wheel
    self.comment1 = vgui.Create("lotr.option_comment", self.scroll)
    self.comment1:SetText("*-Можете использовать колесо мыши для прибавление или понижения суммы перевода")
    --Done
    self.btn = vgui.Create("lotr.option_button", self.scroll)
    self.btn:SetText("Перевести", "Переведено")
    --Comment 2
    self.comment2 = vgui.Create("lotr.option_comment", self.scroll)
    self.comment2:SetText("*-Администрация не вернет вам кредиты, в случае ошибочного перевода")
    --Interactive
    self.click = self.btn.btn
    self.click.DoClick = function(me)
        self._recipient = self.combo._btn_text
        self._count = self.entry._count
        if self._recipient == "Выберите игрока" then 
            print("Игрок не выбран") 
        else 
            if self._recipient != LocalPlayer():Name() then
                local q_menu = vgui.Create("lotr.qmenu")
                self.tbl = {
                    ent = self._recipient,
                    count = self._count
                }
                q_menu:SetTable(self.tbl)
                self.btn._anim = 1
            end
        end
    end
end


derma.DefineControl('lotr.credit_panel', '', credit_panel, 'EditablePanel')


--f4

local pnl = {}

function pnl:Init()
    self.gradient = Material("gui/gradient_up")
    self.lotr_logo = Material("lotr/logo.png")
    self.lotr_lens = Material("lotr/lens.png")
    self._btn = 0
    self:SetSize(sw*(.54/aw), sh*(.52/ah))
    self:Center()
    self:SetVisible(false)

    self.mainpanel = vgui.Create("DPanel", self)
    self.mainpanel:SetPos(0,0)
    self.mainpanel:SetSize(self:GetWide(), self:GetTall())
    self.mainpanel.Paint = function(me,w,h)
        surface.SetDrawColor(45,45,45,230)
        surface.DrawRect(0,0,w,h)
    end

    self.main_layout = vgui.Create("DPanel", self)
    self.main_layout:SetPos(self:GetWide()*.01, sh*(.04/ah))
    self.main_layout:SetSize(self:GetWide()*.98, self:GetTall() - sh*(.04/ah) - sh*(.079/ah))
    self.main_layout.Paint = nil

    self.settings_panel = vgui.Create("lotr.setting_panel", self.main_layout)
    self.settings_panel:Dock(FILL)

    self.bind_panel = vgui.Create("lotr.bind_panel", self.main_layout)
    self.bind_panel:Dock(FILL)

    self.admin_panel = vgui.Create("lotr.admin_panel", self.main_layout)
    self.admin_panel:Dock(FILL)

    self.pers_panel = vgui.Create("lotr.pers_panel", self.main_layout)
    self.pers_panel:Dock(FILL)

    self.event_panel = vgui.Create("lotr.event_panel", self.main_layout)
    self.event_panel:Dock(FILL)

    self.credit_panel = vgui.Create("lotr.credit_panel", self.main_layout)
    self.credit_panel:Dock(FILL)

    self._panels = {
        self.settings_panel,
        self.bind_panel,
        self.admin_panel,
        self.pers_panel,
        self.event_panel,
        self.credit_panel,
    }

    self.labelpanel1 = vgui.Create("DPanel", self)
    self.labelpanel1:SetPos(0, 0)
    self.labelpanel1:SetSize(self:GetWide(), sh*(.03/ah))
    self.labelpanel1.Paint = function(me,w,h)
        local hw, hh = (w/2), (h/2)
        surface.SetDrawColor(60,60,60,255)
        surface.DrawRect(0,0,w,hh)
        draw.NoTexture()
        surface.DrawPoly({
            {x=w*.05,y=hh},
            {x=w*.2,y=hh},
            {x=w*.18,y=h},
            {x=w*.07,y=h},
        })
        surface.SetDrawColor(198,164,23,255)
        surface.SetMaterial(self.lotr_lens)
        surface.DrawTexturedRect(w*.06,0,w*.13,h*1.95)
        draw.SimpleText(" F4 Меню ", "lotr.font.f4menu.title", w*.125, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.labelpanel2 = vgui.Create("DPanel", self)
    self.labelpanel2:SetPos(0, self:GetTall() - sh*(.069/ah))
    self.labelpanel2:SetSize(self:GetWide(), sh*(.07/ah))
    self.labelpanel2.Paint = function(me,w,h)
        local hw, hh = (w/2), (h/2)
        surface.SetDrawColor(45,45,45,255)
        surface.DrawRect(0,h*.4,w,h)
        draw.NoTexture()
        surface.DrawPoly({
            {x=hw - w*.1,y=0},
            {x=hw + w*.1,y=0},
            {x=hw + w*.2,y=h*.4},
            {x=hw - w*.2,y=h*.4},
        })
    end

    self.panel_layout = vgui.Create("DPanel", self)
    self.panel_layout:SetPos((self:GetWide()/2) - (self:GetWide()*.127), self:GetTall() - sh*(.069/ah) + sh*(.018/ah))
    self.panel_layout:SetSize(sw*(.1398/aw), sh*(.035/ah)) --self:GetWide()/2) - (self:GetWide()*.2)
    self.panel_layout.Paint = nil

    self.list_btn = vgui.Create("DIconLayout", self.panel_layout)
    self.list_btn:Dock(FILL)
    self.list_btn:SetSpaceX(sh*(.008/ah))

    self.mat_setting = Material("lotr/setting.png")
    self.mat_binds = Material("lotr/binds.png")
    self.mat_admin = Material("lotr/administration.png")
    self.mat_pers = Material("lotr/slots_pers.png")
    self.mat_event = Material("lotr/eventmanagers.png")
    self.mat_transfer = Material("lotr/transfer.png")

    self.btn1 = self.list_btn:Add("DButton") --settings
    self.btn1:SetSize(sw*(.0196/aw), sh*(.035/ah))
    self.btn1:SetText("")
    self.btn1._anim = 0
    self.btn1.Paint = function(me,w,h)
        if me:IsHovered() then
            self.btn1._anim = math.Clamp(self.btn1._anim + 10 * FrameTime(), 0, 1)
        else
            self.btn1._anim = math.Clamp(self.btn1._anim - 10 * FrameTime(), 0, 1)
        end
        if self._btn == 0 then
            surface.SetDrawColor(241, 199, 25, 255)
        else    
            surface.SetDrawColor(color_white)
        end
        surface.SetMaterial(self.mat_setting)
        surface.DrawTexturedRect(0 + ((w*.125) * self.btn1._anim),0 + ((h*.125) * self.btn1._anim),w - ((w*.25) * self.btn1._anim),h - ((h*.25) * self.btn1._anim))
    end
    self.btn1.DoClick = function()
        self._btn = 0
    end

    self.btn2 = self.list_btn:Add("DButton") --binds
    self.btn2:SetSize(sw*(.0196/aw), sh*(.035/ah))
    self.btn2:SetText("")
    self.btn2._anim = 0
    self.btn2.Paint = function(me,w,h)
        if me:IsHovered() then
            self.btn2._anim = math.Clamp(self.btn2._anim + 10 * FrameTime(), 0, 1)
        else
            self.btn2._anim = math.Clamp(self.btn2._anim - 10 * FrameTime(), 0, 1)
        end
        if self._btn == 1 then
            surface.SetDrawColor(241, 199, 25, 255)
        else    
            surface.SetDrawColor(color_white)
        end
        surface.SetMaterial(self.mat_binds)
        surface.DrawTexturedRect(0 + ((w*.125) * self.btn2._anim),0 + ((h*.125) * self.btn2._anim),w - ((w*.25) * self.btn2._anim),h - ((h*.25) * self.btn2._anim))
    end
    self.btn2.DoClick = function()
        self._btn = 1
    end

    self.btn3 = self.list_btn:Add("DButton") --adminmanager
    self.btn3:SetSize(sw*(.0196/aw), sh*(.035/ah))
    self.btn3:SetText("")
    self.btn3._anim = 0
    self.btn3.Paint = function(me,w,h)
        if me:IsHovered() then
            self.btn3._anim = math.Clamp(self.btn3._anim + 10 * FrameTime(), 0, 1)
        else
            self.btn3._anim = math.Clamp(self.btn3._anim - 10 * FrameTime(), 0, 1)
        end
        if self._btn == 2 then
            surface.SetDrawColor(241, 199, 25, 255)
        else    
            surface.SetDrawColor(color_white)
        end
        surface.SetMaterial(self.mat_admin)
        surface.DrawTexturedRect(0 + ((w*.125) * self.btn3._anim),0 + ((h*.125) * self.btn3._anim),w - ((w*.25) * self.btn3._anim),h - ((h*.25) * self.btn3._anim))
    end
    self.btn3.DoClick = function()
        self._btn = 2
    end

    self.btn4 = self.list_btn:Add("DButton") --characters
    self.btn4:SetSize(sw*(.0196/aw), sh*(.035/ah))
    self.btn4:SetText("")
    self.btn4._anim = 0
    self.btn4.Paint = function(me,w,h)
        if me:IsHovered() then
            self.btn4._anim = math.Clamp(self.btn4._anim + 10 * FrameTime(), 0, 1)
        else
            self.btn4._anim = math.Clamp(self.btn4._anim - 10 * FrameTime(), 0, 1)
        end
        if self._btn == 3 then
            surface.SetDrawColor(241, 199, 25, 255)
        else    
            surface.SetDrawColor(color_white)
        end
        surface.SetMaterial(self.mat_pers)
        surface.DrawTexturedRect(0 + ((w*.125) * self.btn4._anim),0 + ((h*.125) * self.btn4._anim),w - ((w*.25) * self.btn4._anim),h - ((h*.25) * self.btn4._anim))
    end
    self.btn4.DoClick = function()
        self._btn = 3
    end

    self.btn5 = self.list_btn:Add("DButton") --event-manager
    self.btn5:SetSize(sw*(.0196/aw), sh*(.035/ah))
    self.btn5:SetText("")
    self.btn5._anim = 0
    self.btn5.Paint = function(me,w,h)
        if me:IsHovered() then
            self.btn5._anim = math.Clamp(self.btn5._anim + 10 * FrameTime(), 0, 1)
        else
            self.btn5._anim = math.Clamp(self.btn5._anim - 10 * FrameTime(), 0, 1)
        end
        if self._btn == 4 then
            surface.SetDrawColor(241, 199, 25, 255)
        else    
            surface.SetDrawColor(color_white)
        end
        surface.SetMaterial(self.mat_event)
        surface.DrawTexturedRect(0 + ((w*.125) * self.btn5._anim),0 + ((h*.125) * self.btn5._anim),w - ((w*.25) * self.btn5._anim),h - ((h*.25) * self.btn5._anim))
    end
    self.btn5.DoClick = function()
        self._btn = 4
    end

    self.btn6 = self.list_btn:Add("DButton") --credit
    self.btn6:SetSize(sw*(.0196/aw), sh*(.035/ah))
    self.btn6:SetText("")
    self.btn6._anim = 0
    self.btn6.Paint = function(me,w,h)
        if me:IsHovered() then
            self.btn6._anim = math.Clamp(self.btn6._anim + 10 * FrameTime(), 0, 1)
        else
            self.btn6._anim = math.Clamp(self.btn6._anim - 10 * FrameTime(), 0, 1)
        end
        if self._btn == 5 then
            surface.SetDrawColor(241, 199, 25, 255)
        else    
            surface.SetDrawColor(color_white)
        end
        surface.SetMaterial(self.mat_transfer)
        surface.DrawTexturedRect(0 + ((w*.125) * self.btn6._anim),0 + ((h*.125) * self.btn6._anim),w - ((w*.25) * self.btn6._anim),h - ((h*.25) * self.btn6._anim))
    end
    self.btn6.DoClick = function()
        self._btn = 5
    end    
end
function pnl:switch_panel(id)
    id = id + 1
    if self._panels[id] then
        if !self._panels[id]:IsVisible() then
            self._panels[id]:SetVisible(true)
        end
    end
    for k,v in pairs(self._panels) do
        if id != k then
            v:SetVisible(false)
        end
    end
end
function pnl:Think()
    self:switch_panel(self._btn)
end
function pnl:Paint(w,h)
    DrawBlur(self, 7, 255)
    surface.SetDrawColor(20,20,20,10)
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor(198,164,23,200)
    surface.SetMaterial(self.gradient)
    surface.DrawTexturedRect(0,h*.45,w,h)
    surface.SetDrawColor(255,255,255,160)
    surface.SetMaterial(self.lotr_logo)
    surface.DrawTexturedRect(w/3,h*.1,w/3,h/1.2)
end



derma.DefineControl('lotr.f4menu', '', pnl, 'EditablePanel')