-- ROOT VARIABLE SPACE
pfStudio = { theme = {} }
pfStudio_config = {}
pfStudio_saved = {}

-- slash cmd
SLASH_STUDIO1 = '/studio'
function SlashCmdList.STUDIO(msg, editbox)
  if pfStudio.toolbar:IsShown() then
    pfStudio.toolbar:Hide()
    pfStudio.toolbar.title:Hide()
  else
    pfStudio.toolbar:Show()
    pfStudio.toolbar.title:Show()
  end
end

SLASH_RELOAD1 = '/rl'
function SlashCmdList.RELOAD(msg, editbox)
  ReloadUI()
end

SLASH_STUDIO_PAUSE1 = '/studiopause'
function SlashCmdList.STUDIO_PAUSE(msg, editbox)
  if pfStudio.paused then
    pfStudio.paused = nil
    pfStudio.events:RegisterAllEvents()
    pfStudio.events.input:AddMessage("|cff33ffccEvents resumed.|r\n")
  else
    pfStudio.paused = true
    pfStudio.events:UnregisterAllEvents()
    pfStudio.events.input:AddMessage("|cff33ffccEvents paused.|r\n")
  end
end

SLASH_STUDIO_REGISTER1 = '/studioregister'
function SlashCmdList.STUDIO_REGISTER(msg, editbox)
  -- register event 'msg'
  pfStudio.events:RegisterEvent(msg)
  pfStudio.events.input:AddMessage("|cff33ffccEvent " .. msg .. " registered.|r\n")
end

SLASH_STUDIO_UNREGISTER1 = '/studiounregister'
function SlashCmdList.STUDIO_UNREGISTER(msg, editbox)
  if(msg == "all") then
    -- unregister all events
    pfStudio.events:UnregisterAllEvents()
    pfStudio.events.input:AddMessage("|cff33ffccAll events unregistered.|r\n")
    return
  end

  -- unregister event 'msg'
  pfStudio.events:UnregisterEvent(msg)
  pfStudio.events.input:AddMessage("|cff33ffccEvent " .. msg .. " unregistered.|r\n")
end

-- functions
function pfStudio.strsplit(delimiter, subject)
  local delimiter, fields = delimiter or ":", {}
  local pattern = string.format("([^%s]+)", delimiter)
  string.gsub(subject, pattern, function(c) fields[table.getn(fields)+1] = c end)
  return unpack(fields)
end

-- initialize windgets (Arc-Theme)
function pfStudio.theme.arc()
  windget.widget.backdrop["bgFile"] = "Interface\\AddOns\\pfStudio\\img\\bg"
  windget.widget.backdrop["edgeFile"] = nil

  windget.window.backdrop["bgFile"] = "Interface\\AddOns\\pfStudio\\img\\bg"
  windget.window.backdrop["edgeFile"] = nil

  windget.window.close = "Interface\\AddOns\\pfStudio\\img\\close"
  windget.window.minimize = "Interface\\AddOns\\pfStudio\\img\\min"
  windget.window.maximize = "Interface\\AddOns\\pfStudio\\img\\max"

  windget.spacing = 5
  windget.color1 = { .18, .20, .25, .9 }
  windget.color2 = { .20, .22, .28, 1 }
  windget.color3 = { .20, 1, .8, 1 }

  windget.font = "Interface\\AddOns\\pfStudio\\fonts\\PT-Sans-Narrow-Bold.ttf"
  windget.fontsize = 12
  windget.fontmono = "Interface\\AddOns\\pfStudio\\fonts\\Envy-Code-R.ttf"
  windget.fontsizemono = 11
  windget.fontopts = "NORMAL"
end

-- initialize windgets (dark-Theme)
function pfStudio.theme.dark()
  windget.widget.backdrop["bgFile"] = "Interface\\AddOns\\pfStudio\\img\\bg"
  windget.widget.backdrop["edgeFile"] = nil

  windget.window.backdrop["bgFile"] = "Interface\\AddOns\\pfStudio\\img\\bg"
  windget.window.backdrop["edgeFile"] = nil

  windget.window.close = "Interface\\AddOns\\pfStudio\\img\\close"
  windget.window.minimize = "Interface\\AddOns\\pfStudio\\img\\min"
  windget.window.maximize = "Interface\\AddOns\\pfStudio\\img\\max"

  windget.spacing = 5
  windget.color1 = { .15, .15, .15, 1 }
  windget.color2 = { .2, .2, .2, .95 }
  windget.color3 = { .20, 1, .8, 1 }

  windget.font = "Interface\\AddOns\\pfStudio\\fonts\\PT-Sans-Narrow-Bold.ttf"
  windget.fontsize = 12
  windget.fontmono = "Interface\\AddOns\\pfStudio\\fonts\\Envy-Code-R.ttf"
  windget.fontsizemono = 11
  windget.fontopts = "NORMAL"
end

pfStudio.theme.dark()
