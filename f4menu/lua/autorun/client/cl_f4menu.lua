print("$[F4MENU] Client side loaded")

lotr_fog = 2048
lotr_fog_bool = false

hook.Add("SetupWorldFog", "lotrfog", function()
    render.FogMode(MATERIAL_FOG_LINEAR)
    if (lotr_fog - 2048) >= 0 then
	    render.FogStart(lotr_fog - 2048)
    else
        render.FogStart(0)
    end
	render.FogEnd(lotr_fog)
    if lotr_fog_bool then
        render.FogMaxDensity(1)
    else
	    render.FogMaxDensity(0)
    end
	render.FogColor(.39 * 255, .49 * 255, .51 * 255)

	return true
end)

hook.Add("SetupSkyboxFog", "lotrfog", function(skyboxscale)
    render.FogMode(MATERIAL_FOG_LINEAR)
    if (lotr_fog - 1024) >= 0 then
	    render.FogStart((lotr_fog - 1024) * skyboxscale)
    else
        render.FogStart(0)
    end
	render.FogEnd(lotr_fog * skyboxscale)
	if lotr_fog_bool then
        render.FogMaxDensity(1)
    else
	    render.FogMaxDensity(0)
    end
	render.FogColor(.39 * 255, .49 * 255, .51 * 255)

	return true
end)

net.Receive("lotr.f4menu_admin_reply", function()
    local str = net.ReadString()
    notification.AddLegacy(str, 0, 4)
    surface.PlaySound("buttons/blip1.wav")
end)