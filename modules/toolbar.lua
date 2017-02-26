local spacing = 10
local tabwidth = 150

pfStudio.toolbar = windget.window:CreateWindow("Toolbar", 220, 36, true, true)

local buttons = {
  { "run", "Run LUA Code" },
  { "debug", "Run LUA Code in Debug Window" },
  { "spacer", nil },
  { "editor", "Toggle Editor" },
  { "events", "Toggle Event Logger" },
  { "info", "Toggle Info Console" },
  { "time", "Toggle Performance Overview" },
}

for i, button in pairs( buttons ) do
  local name, tooltip = unpack(button)
  pfStudio.toolbar[name] = windget.widget:CreateWidget("Button", "pfStudio_Button_" .. name, pfStudio.toolbar)
  windget.widget:SkinButton(pfStudio.toolbar[name], "Interface\\AddOns\\pfStudio\\img\\" .. name)
  if name == "spacer" then
    pfStudio.toolbar[name]:Hide()
  else
    pfStudio.toolbar[name]:SetWidth(16)
    pfStudio.toolbar[name]:SetHeight(16)
    pfStudio.toolbar[name]:SetPoint("TOPLEFT", 10+(30*(i-1)), -10)
  end

  if tooltip then
    pfStudio.toolbar[name].tooltip = tooltip
  end
end

pfStudio.toolbar["run"]:SetScript("OnClick", function()
  pfStudio.editor:RunCode()
end)

pfStudio.toolbar["debug"]:SetScript("OnClick", function()
  pfStudio.editor:DebugCode()
end)

pfStudio.toolbar["editor"]:SetScript("OnClick", function()
  if pfStudio.editor.title:IsShown() then
    pfStudio.editor:Hide()
    pfStudio.editor.title:Hide()
  else
    pfStudio.editor:Show()
    pfStudio.editor.title:Show()
  end
end)

pfStudio.toolbar["events"]:SetScript("OnClick", function()
  if pfStudio.events.title:IsShown() then
    pfStudio.events:Hide()
    pfStudio.events.title:Hide()
  else
    pfStudio.events:Show()
    pfStudio.events.title:Show()
  end
end)

pfStudio.toolbar["info"]:SetScript("OnClick", function()
  if pfStudio.debug.title:IsShown() then
    pfStudio.debug:Hide()
    pfStudio.debug.title:Hide()
  else
    pfStudio.debug:Show()
    pfStudio.debug.title:Show()
  end
end)
