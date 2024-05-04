print("[CONTEXT] Client-Side work")

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

surface.CreateFont("lotr.font.context.btn", {
	font = "Montserrat Medium",
	size = (sw+sh)*(.012/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
})

surface.CreateFont("lotr.font.context.header", {
	font = "Montserrat Bold",
	size = (sw+sh)*(.014/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
})

surface.CreateFont("lotr.font.context.linkname", {
	font = "Montserrat SemiBold",
	size = (sw+sh)*(.016/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
})

surface.CreateFont("lotr.font.context.claim_reason", {
	font = "Montserrat SemiBold",
	size = (sw+sh)*(.014/(aw+ah)),
	weight = 200,
	antialias = true,
	extended = true,
	outline = false,
	shadow = false,
    scanlines = 0,
})

---------------------OTHER DERMA----------------------

local cm = {}

function cm:Init()
    self._btn_text = "Низкий"
    self._bool = false
    self.combo = vgui.Create("DButton", self)
    self.combo:Dock(FILL)
    self.combo:SetText("")
    self.combo.Paint = function(me,w,h)
        surface.SetDrawColor(60,60,60,255)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(120,120,120,225)
        surface.DrawOutlinedRect(0,0,w,h,1)
        draw.SimpleText(self._btn_text, "lotr.font.context.btn", w*.5, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.combo.DoClick = function(me)
        me.Menu = DermaMenu(false, self.combo)
        me.Menu:SetMinimumWidth(me:GetWide())
        me.btn = me.Menu:AddOption("Низкий", function()
            self._btn_text = "Низкий"
        end)
        me.btn:SetText("")
        me.btn._anim = 0
        me.btn.Paint = function(me,w,h)
            if me:IsHovered() then
                me._anim = math.Clamp(me._anim + 10 * FrameTime(), 0, 1)
            else
                me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
            end
            surface.SetDrawColor(60 + (45 * me._anim),60 + (45 * me._anim),60 + (45 * me._anim),255)
            surface.DrawRect(0,0,w,h)
            draw.SimpleText("Низкий", "lotr.font.context.btn", w*.5, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        me.Menu:AddSpacer()
        me.btn = me.Menu:AddOption("Средний", function()
            self._btn_text = "Средний"
        end)
        me.btn:SetText("")
        me.btn._anim = 0
        me.btn.Paint = function(me,w,h)
            if me:IsHovered() then
                me._anim = math.Clamp(me._anim + 10 * FrameTime(), 0, 1)
            else
                me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
            end
            surface.SetDrawColor(60 + (45 * me._anim),60 + (45 * me._anim),60 + (45 * me._anim),255)
            surface.DrawRect(0,0,w,h)
            draw.SimpleText("Средний", "lotr.font.context.btn", w*.5, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        me.Menu:AddSpacer()
        me.btn = me.Menu:AddOption("Высокий", function()
            self._btn_text = "Высокий"
        end)
        me.btn:SetText("")
        me.btn._anim = 0
        me.btn.Paint = function(me,w,h)
            if me:IsHovered() then
                me._anim = math.Clamp(me._anim + 10 * FrameTime(), 0, 1)
            else
                me._anim = math.Clamp(me._anim - 10 * FrameTime(), 0, 1)
            end
            surface.SetDrawColor(60 + (45 * me._anim),60 + (45 * me._anim),60 + (45 * me._anim),255)
            surface.DrawRect(0,0,w,h)
            draw.SimpleText("Высокий", "lotr.font.context.btn", w*.5, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        me.Menu:AddSpacer()
        local x, y = me:LocalToScreen( 0, me:GetTall() )
        me.Menu:Open(x,y,false,me)
    end
end
function cm:SetText(txt)
    self._text = txt
end
function cm:Paint(w,h)
end

derma.DefineControl('lotr.context_menu_element_claim_priority', '', cm, 'EditablePanel')


------------------------MENUS--------------------------

local claim = {}

function claim:Init()
    self.drag = false

    self.cx = 0
    self.cy = 0

    self:SetSize(sw*(.4/aw), sh*(.15/ah))
    self:MakePopup()
    self:LerpPositions(1.5, true)

    self.close = vgui.Create("DButton", self)
    self.close:SetSize(sw*(.041/aw),sh*(.012/ah))
    self.close:SetPos(sw*(.36/aw),sh*(.002/ah))
    self.close:SetText("")
    self.close.DoClick = function()
        self:Remove()
    end
    self.close.Paint = function(me,w,h)
        surface.SetDrawColor(223,45,45,255)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0 + w*.1,y=0},
            {x=w,y=0},
            {x=w,y=h},
            {x=0,y=h},
        })
    end

    self.bg_te = vgui.Create("EditablePanel", self)
    self.bg_te:SetSize(sw*(.25/aw),sh*(.03/ah))
    self.bg_te:SetPos(sw*(.01/aw),sh*(.042/ah))
    self.bg_te.Paint = function(me,w,h)
        surface.SetDrawColor(60,60,60,225)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(120,120,120,225)
        surface.DrawOutlinedRect(0,0,w,h,1)
    end

    self.te = vgui.Create("DTextEntry", self.bg_te)
    self.te:Dock(FILL)
    self.te:SetPaintBackground(false)
    self.te:SetTextColor(color_white)
    self.te:SetFont("lotr.font.context.claim_reason")
    self.te:SetPlaceholderText("Укажите причину вашей жалобы")
    self.te:SetDrawLanguageID(false)

    self.combo = vgui.Create("lotr.context_menu_element_claim_priority", self)
    self.combo:SetSize(sw*(.05/aw),sh*(.03/ah))
    self.combo:SetPos(sw*(.33/aw),sh*(.042/ah))

    self.btn = vgui.Create("DButton", self)
    self.btn:SetSize(sw*(.15/aw),sh*(.04/ah))
    self.btn:SetPos(self:GetWide()/2 - self.btn:GetWide()/1.9,sh*(.112/ah))
    self.btn:SetText("")
    self.btn.anim = 0
    self.btn.Paint = function(me,w,h)
        surface.SetDrawColor(211,169,1,255)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0 + w*.1,y=0},
            {x=w - w*.1,y=0},
            {x=w,y=h},
            {x=0,y=h},
        })
        draw.SimpleText("Отправить", "lotr.font.context.btn", w*.5, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end
function claim:Paint(w,h)
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    surface.SetDrawColor(255, 255, 255)
    draw.NoTexture()
    surface.DrawPoly({
        {x=0,y=0 + h*.09},
        {x=w,y=0 + h*.09},
        {x=w,y=h},
        {x=0,y=h},
    })
    surface.DrawPoly({
        {x=0,y=0},
        {x=0 + w*.27,y=0},
        {x=0 + w*.3,y=0 + h*.09},
        {x=0,y=0 + h*.09},
    })

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

    DrawBlur(self,10,255)
    surface.SetDrawColor(20,20,20,225)
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor(241,199,25,200)
    surface.SetMaterial(Material("vgui/gradient_up"))
    surface.DrawTexturedRect(0,h - h*.6,w,h*2)
    surface.SetDrawColor(120,120,120,100)
    surface.SetMaterial(Material("lotr/logo.png"))
    surface.DrawTexturedRect(w*.4,h*.07,w*.2,h*.9)

    draw.SimpleText("Меню подачи жалобы", "lotr.font.context.header", w*.02, h*.06, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText("Приоритет:", "lotr.font.context.claim_reason", w*.8, h*.37, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

    render.SetStencilEnable(false)
    render.ClearStencil()
end
function claim:Think()
    if self.drag then
        self:SetPos(gui.MouseX() - self.cx, gui.MouseY() - self.cy)
        if !input.IsMouseDown(107) then
            self.drag = false
        end
    end
end
function claim:OnMousePressed(key)
    if key == 107 then
        self.drag = true
        self.cx, self.cy = self:CursorPos()
    end
end
function claim:OnMouseReleased(key)
    if key == 107 then
        self.drag = false
    end
end

derma.DefineControl('lotr.context_menu_claim', '', claim, 'EditablePanel')


local link = {}

function link:Init()
    self.drag = false

    self.cx = 0
    self.cy = 0

    self:SetSize(sw*(.3/aw), sh*(.312/ah))
    self:MakePopup()
    self:LerpPositions(1.5, true)

    self.close = vgui.Create("DButton", self)
    self.close:SetSize(sw*(.041/aw),sh*(.015/ah))
    self.close:SetPos(sw*(.26/aw),sh*(.005/ah))
    self.close:SetText("")
    self.close.DoClick = function()
        self:Remove()
    end
    self.close.Paint = function(me,w,h)
        surface.SetDrawColor(223,45,45,255)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0 + w*.1,y=0},
            {x=w,y=0},
            {x=w,y=h},
            {x=0,y=h},
        })
    end

    self.lay = vgui.Create("DPanel", self)
    self.lay:SetSize(self:GetWide() - sw*(.01/aw), self:GetTall() - sh*(.04/ah))
    self.lay:SetPos(sw*(.005/aw), sh*(.03/ah))
    self.lay.Paint = nil
    self.lay.OnMousePressed = function(me,key)
        if key == 107 then
            self.drag = true
            self.cx, self.cy = self:CursorPos()
        end
    end
    self.lay.OnMouseReleased = function(me,key)
        if key == 107 then
            self.drag = false
        end
    end
    --------VK-------
    self.btn_vk = vgui.Create("DButton", self.lay)
    self.btn_vk:Dock(TOP)
    self.btn_vk:SetTall(sh*(.05/ah))
    self.btn_vk:SetText("")
    self.btn_vk.anim = 0
    self.btn_vk.Paint = function(me,w,h)
        surface.SetDrawColor(58,72,255,255)
        surface.SetMaterial(Material("vgui/gradient-r"))
        surface.DrawTexturedRect(0 + w*.5,0,w*2,h)
        surface.DrawTexturedRect(0 + w*.85,0,w/3,h)

        if me:IsHovered() then
            me.anim = math.Clamp(me.anim + 5 * FrameTime(), 0, 1)
        else
            me.anim = math.Clamp(me.anim - 5 * FrameTime(), 0, 1)
        end

        surface.SetDrawColor(241,199,25,255 * me.anim)
        surface.SetMaterial(Material("vgui/gradient-l"))
        surface.DrawTexturedRect(0 - w*1.5,0,w*2,h)
        surface.DrawTexturedRect(0 - w*.2,0,w/3,h)

        draw.SimpleText("Группа ВКонтакте", "lotr.font.context.linkname", w*.02, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetMaterial(Material("lotr/vk.png", "smooth"))
        surface.SetDrawColor(240,240,240,255)
        surface.DrawTexturedRect(0 + w*.88,0,w*.1,h)

        surface.SetDrawColor(120,120,120,255)
        surface.DrawOutlinedRect(0,0,w,h,1)
    end
    self.btn_vk.DoClick = function()
        gui.OpenURL("https://vk.com/light_of_the_republic")
    end
    --------Discord--------
    self.btn_ds = vgui.Create("DButton", self.lay)
    self.btn_ds:Dock(TOP)
    self.btn_ds:DockMargin(0,sh*(.005/ah),0,0)
    self.btn_ds:SetTall(sh*(.05/ah))
    self.btn_ds:SetText("")
    self.btn_ds.anim = 0
    self.btn_ds.Paint = function(me,w,h)
        surface.SetDrawColor(118,132,255,255)
        surface.SetMaterial(Material("vgui/gradient-r"))
        surface.DrawTexturedRect(0 + w*.5,0,w*2,h)
        surface.DrawTexturedRect(0 + w*.85,0,w/3,h)

        if me:IsHovered() then
            me.anim = math.Clamp(me.anim + 5 * FrameTime(), 0, 1)
        else
            me.anim = math.Clamp(me.anim - 5 * FrameTime(), 0, 1)
        end

        surface.SetDrawColor(241,199,25,255 * me.anim)
        surface.SetMaterial(Material("vgui/gradient-l"))
        surface.DrawTexturedRect(0 - w*1.5,0,w*2,h)
        surface.DrawTexturedRect(0 - w*.2,0,w/3,h)

        draw.SimpleText("Дискорд сервер", "lotr.font.context.linkname", w*.02, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetMaterial(Material("lotr/ds.png", "smooth"))
        surface.SetDrawColor(240,240,240,255)
        surface.DrawTexturedRect(0 + w*.89,0 + h*.12,w*.08,h*.8)

        surface.SetDrawColor(120,120,120,255)
        surface.DrawOutlinedRect(0,0,w,h,1)
    end
    self.btn_ds.DoClick = function()
        gui.OpenURL("https://discord.gg/pFS3CdYp2X")
    end
    -------------Site--------------
    self.btn_site = vgui.Create("DButton", self.lay)
    self.btn_site:Dock(TOP)
    self.btn_site:DockMargin(0,sh*(.005/ah),0,0)
    self.btn_site:SetTall(sh*(.05/ah))
    self.btn_site:SetText("")
    self.btn_site.anim = 0
    self.btn_site.Paint = function(me,w,h)
        surface.SetDrawColor(241,152,25,255)
        surface.SetMaterial(Material("vgui/gradient-r"))
        surface.DrawTexturedRect(0 + w*.5,0,w*2,h)
        surface.DrawTexturedRect(0 + w*.85,0,w/3,h)

        if me:IsHovered() then
            me.anim = math.Clamp(me.anim + 5 * FrameTime(), 0, 1)
        else
            me.anim = math.Clamp(me.anim - 5 * FrameTime(), 0, 1)
        end

        surface.SetDrawColor(241,199,25,255 * me.anim)
        surface.SetMaterial(Material("vgui/gradient-l"))
        surface.DrawTexturedRect(0 - w*1.5,0,w*2,h)
        surface.DrawTexturedRect(0 - w*.2,0,w/3,h)

        draw.SimpleText("Сайт", "lotr.font.context.linkname", w*.02, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetMaterial(Material("lotr/www.png", "smooth"))
        surface.SetDrawColor(240,240,240,255)
        surface.DrawTexturedRect(0 + w*.89,0 + h*.12,w*.08,h*.8)

        surface.SetDrawColor(120,120,120,255)
        surface.DrawOutlinedRect(0,0,w,h,1)
    end
    self.btn_site.DoClick = function()
        gui.OpenURL("https://forum.lotr-sw.ru")
    end
    --------------------Collection------------------
    self.btn_steam = vgui.Create("DButton", self.lay)
    self.btn_steam:Dock(TOP)
    self.btn_steam:DockMargin(0,sh*(.005/ah),0,0)
    self.btn_steam:SetTall(sh*(.05/ah))
    self.btn_steam:SetText("")
    self.btn_steam.anim = 0
    self.btn_steam.Paint = function(me,w,h)
        surface.SetDrawColor(63,127,127,255)
        surface.SetMaterial(Material("vgui/gradient-r"))
        surface.DrawTexturedRect(0 + w*.5,0,w*2,h)
        surface.DrawTexturedRect(0 + w*.85,0,w/3,h)

        if me:IsHovered() then
            me.anim = math.Clamp(me.anim + 5 * FrameTime(), 0, 1)
        else
            me.anim = math.Clamp(me.anim - 5 * FrameTime(), 0, 1)
        end

        surface.SetDrawColor(241,199,25,255 * me.anim)
        surface.SetMaterial(Material("vgui/gradient-l"))
        surface.DrawTexturedRect(0 - w*1.5,0,w*2,h)
        surface.DrawTexturedRect(0 - w*.2,0,w/3,h)

        draw.SimpleText("Коллекция", "lotr.font.context.linkname", w*.02, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetMaterial(Material("lotr/steam.png", "smooth"))
        surface.SetDrawColor(240,240,240,255)
        surface.DrawTexturedRect(0 + w*.89,0 + h*.12,w*.08,h*.8)

        surface.SetDrawColor(120,120,120,255)
        surface.DrawOutlinedRect(0,0,w,h,1)
    end
    self.btn_steam.DoClick = function()
        gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2489275119")
    end
    --------------------------УСТАВ----------------------------
    self.btn_slp = vgui.Create("DButton", self.lay)
    self.btn_slp:Dock(TOP)
    self.btn_slp:DockMargin(0,sh*(.005/ah),0,0)
    self.btn_slp:SetTall(sh*(.05/ah))
    self.btn_slp:SetText("")
    self.btn_slp.anim = 0
    self.btn_slp.Paint = function(me,w,h)
        surface.SetDrawColor(241,152,25,255)
        surface.SetMaterial(Material("vgui/gradient-r"))
        surface.DrawTexturedRect(0 + w*.5,0,w*2,h)
        surface.DrawTexturedRect(0 + w*.85,0,w/3,h)

        if me:IsHovered() then
            me.anim = math.Clamp(me.anim + 5 * FrameTime(), 0, 1)
        else
            me.anim = math.Clamp(me.anim - 5 * FrameTime(), 0, 1)
        end

        surface.SetDrawColor(241,199,25,255 * me.anim)
        surface.SetMaterial(Material("vgui/gradient-l"))
        surface.DrawTexturedRect(0 - w*1.5,0,w*2,h)
        surface.DrawTexturedRect(0 - w*.2,0,w/3,h)

        draw.SimpleText("Устав", "lotr.font.context.linkname", w*.02, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetMaterial(Material("lotr/www.png", "smooth"))
        surface.SetDrawColor(240,240,240,255)
        surface.DrawTexturedRect(0 + w*.89,0 + h*.12,w*.08,h*.8)

        surface.SetDrawColor(120,120,120,255)
        surface.DrawOutlinedRect(0,0,w,h,1)
    end
    self.btn_slp.DoClick = function()
        gui.OpenURL("https://sites.google.com/view/light-of-the-republic-slp")
    end
end
function link:Paint(w,h)
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    surface.SetDrawColor(255, 255, 255)
    draw.NoTexture()
    surface.DrawPoly({
        {x=0,y=0 + h*.06},
        {x=w,y=0 + h*.06},
        {x=w,y=h},
        {x=0,y=h},
    })
    surface.DrawPoly({
        {x=0,y=0},
        {x=0 + w*.2,y=0},
        {x=0 + w*.25,y=0 + h*.06},
        {x=0,y=0 + h*.06},
    })

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

    DrawBlur(self,10,255)
    surface.SetDrawColor(20,20,20,225)
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor(241,199,25,200)
    surface.SetMaterial(Material("vgui/gradient_up"))
    surface.DrawTexturedRect(0,h - h*.4,w,h*2)
    surface.SetDrawColor(120,120,120,100)
    surface.SetMaterial(Material("lotr/logo.png"))
    surface.DrawTexturedRect(w*.3,h*.05,w*.4,h*.9)

    draw.SimpleText("Ссылки", "lotr.font.context.header", w*.11, h*.03, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    render.SetStencilEnable(false)
    render.ClearStencil()
end
function link:Think()
    if self.drag then
        self:SetPos(gui.MouseX() - self.cx, gui.MouseY() - self.cy)
        if !input.IsMouseDown(107) then
            self.drag = false
        end
    end
end
function link:OnMousePressed(key)
    if key == 107 then
        self.drag = true
        self.cx, self.cy = self:CursorPos()
    end
end
function link:OnMouseReleased(key)
    if key == 107 then
        self.drag = false
    end
end

derma.DefineControl('lotr.context_menu_links', '', link, 'DPanel')






















-------------------------------------------------------





local btn = {}

function btn:Init()
    self.text = "Донат"
    self.icon = Material("lotr/donate.png", "smooth")

    self:SetSize(sw*(.07/aw), sh*(.12/ah))
    self:SetPos(sw*.0, 0)
    self:SetText("")
end
function btn:Setup(text,icon)
    self.text = text
    self.icon = Material(icon, "smooth")
end
function btn:Paint(w,h)
    if self:IsHovered() then
        surface.SetDrawColor(200,166,75,255)
        draw.SimpleText(self.text, "lotr.font.context.btn", w/2, h*.75, Color(225,166,25,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(self.text, "lotr.font.context.btn", w/2, h*.75, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        surface.SetDrawColor(255,255,255,255)
    end
    surface.SetMaterial(self.icon)
    surface.DrawTexturedRect(w*.325,h*.225,w*.35,h*.35)
end

derma.DefineControl('lotr.context_btn', '', btn, 'DButton')

local pnl = {}

function pnl:Init()
    self:SetSize(sw,sh)
    self:MakePopup()
    self:SetY(-sh)
    self:MoveTo(0, 0, .5, 0, .1)

    self.pnl_left = vgui.Create("DPanel", self)
    self.pnl_left:SetSize(sw*(.07/aw), sh*(.725/ah))
    self.pnl_left.Paint = function(me,w,h)
        render.ClearStencil()
        render.SetStencilEnable(true)
        render.SetStencilWriteMask(1)
        render.SetStencilTestMask(1)

        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
        render.SetStencilPassOperation(STENCILOPERATION_ZERO)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
        render.SetStencilReferenceValue(1)

        surface.SetDrawColor(255, 255, 255)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0,y=0},
            {x=w,y=0},
            {x=w,y=h - h*.2},
            {x=0,y=h},
        })

        render.SetStencilFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        render.SetStencilReferenceValue(1)

        DrawBlur(me,10,255)
        surface.SetDrawColor(53,53,53,225)
        surface.DrawRect(0,0,w,h)

        render.SetStencilEnable(false)
        render.ClearStencil()
    end

    self.donate = vgui.Create("lotr.context_btn", self.pnl_left)
    self.donate:SetY(sh*.03)

    self.skill = vgui.Create("lotr.context_btn", self.pnl_left)
    self.skill:SetY(sh*.17)
    self.skill:Setup("Навыки", "lotr/skills.png")

    self.doc = vgui.Create("lotr.context_btn", self.pnl_left)
    self.doc:SetY(sh*.31)
    self.doc:Setup("Документы", "lotr/doc.png")

    self.link = vgui.Create("lotr.context_btn", self.pnl_left)
    self.link:SetY(sh*.45)
    self.link:Setup("Ссылки", "lotr/link.png")
    self.link.DoClick = function(me)
        if !IsValid(self.links) then
            self.links = vgui.Create("lotr.context_menu_links")
            self.links:SetPos(me:GetX() + sw*.1, me:GetY())
        end
    end

    self.pnl_right = vgui.Create("DPanel", self)
    self.pnl_right:SetSize(sw*(.07/aw), sh*(.725/ah))
    self.pnl_right:SetX(sw - sw*(.069/aw))
    self.pnl_right.Paint = function(me,w,h)
        render.ClearStencil()
        render.SetStencilEnable(true)
        render.SetStencilWriteMask(1)
        render.SetStencilTestMask(1)

        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
        render.SetStencilPassOperation(STENCILOPERATION_ZERO)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
        render.SetStencilReferenceValue(1)

        surface.SetDrawColor(255, 255, 255)
        draw.NoTexture()
        surface.DrawPoly({
            {x=0,y=0},
            {x=w,y=0},
            {x=w,y=h},
            {x=0,y=h - h*.2},
        })

        render.SetStencilFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        render.SetStencilReferenceValue(1)

        DrawBlur(me,10,255)
        surface.SetDrawColor(53,53,53,225)
        surface.DrawRect(0,0,w,h)

        render.SetStencilEnable(false)
        render.ClearStencil()
    end

    self.view = vgui.Create("lotr.context_btn", self.pnl_right)
    self.view:SetY(sh*.03)
    self.view:Setup("Вид", "lotr/view.png")

    self.anim = vgui.Create("lotr.context_btn", self.pnl_right)
    self.anim:SetY(sh*.17)
    self.anim:Setup("Анимации", "lotr/animation.png")

    self.radio = vgui.Create("lotr.context_btn", self.pnl_right)
    self.radio:SetY(sh*.31)
    self.radio:Setup("Связь", "lotr/radio.png")

    self.claim = vgui.Create("lotr.context_btn", self.pnl_right)
    self.claim:SetY(sh*.45)
    self.claim:Setup("Жалоба", "lotr/claim.png")
    self.claim.DoClick = function(me)
        if !IsValid(self.claims) then
            self.claims = vgui.Create("lotr.context_menu_claim")
            self.claims:SetPos(sw - me:GetX() - self.claims:GetWide() - sw*.1, me:GetY())
        end
    end
    
end
function pnl:Paint(w,h)
    --DrawBlur(self,10,255)
end
derma.DefineControl('lotr.context', '', pnl, 'EditablePanel')

local function LotrContextMenu(toggle)
    if toggle then
        LOTRCONTEXTMENU = vgui.Create("lotr.context")
    else
        if IsValid(LOTRCONTEXTMENU) then
            LOTRCONTEXTMENU:Remove()
        end
    end
end

hook.Add("OnContextMenuOpen", "LOTR.ContextMenuOpen", function()
    LotrContextMenu(true)
    return false
end)

hook.Add("OnContextMenuClose", "LOTR.ContextMenuClose", function()
    LotrContextMenu(false)
end)