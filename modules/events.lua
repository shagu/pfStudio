local spacing = 10
local tabwidth = 150

pfStudio.events = windget.window:CreateWindow("Events", 400, 200)
pfStudio.events:SetMinResize(160, 60)

pfStudio.events:RegisterAllEvents()
pfStudio.events:SetScript("OnEvent", function()
  local count = 0
  local debuglink = "|H" .. event .. ":"
  local append = ""

  for i=1,30 do
    if getglobal("arg" .. i) then
      local text = tostring(getglobal("arg" .. i))
      if text == "" then text = "|cff555555nil|r" end
      text = string.gsub(text, ":",'⬥')
      text = string.gsub(text, "|",'⬦')
      debuglink = debuglink .. text .. ":"
      count = i
    end
  end

  if count > 0 then
    append = "|cff33ffcc" .. debuglink .. "|h[" .. count .. "]|h|r"
  end

  pfStudio.events.input:AddMessage("|cff555555" .. date("%H:%M:%S") .. "|r " .. event .. append .. "\n")
end)

pfStudio.events.input = windget.widget:CreateWidget("ScrollingMessageFrame", nil, pfStudio.events)
pfStudio.events.input:SetBackdropColor(0,0,0,.35)
pfStudio.events.input:SetPoint("TOPLEFT", pfStudio.events, "TOPLEFT", spacing, -spacing)
pfStudio.events.input:SetPoint("BOTTOMRIGHT", pfStudio.events, "BOTTOMRIGHT", -spacing, spacing)
pfStudio.events.input:SetFontObject(GameFontWhite)
pfStudio.events.input:SetFont(windget.fontmono, windget.fontsizemono, windget.fontopts)
pfStudio.events.input:SetMaxLines(150)
pfStudio.events.input:SetJustifyH("LEFT")
pfStudio.events.input:SetFading(false)

pfStudio.events.input:SetScript("OnHyperlinkClick", function()
  ShowUIPanel(ItemRefTooltip);
  ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
  ItemRefTooltip:SetFrameStrata("TOOLTIP")
  for num, text in ({ pfStudio.strsplit(":", arg1) }) do
    if num ~= 1 then
      text = string.gsub(text, '⬥', ":")
      text = string.gsub(text, '⬦', "|")

      ItemRefTooltip:AddLine("|cff33ffccArgument " .. num -1 .. ":|r|cffffffff " .. text)
    else
      ItemRefTooltip:AddLine(text,1,1,0)
    end
  end

  ItemRefTooltip:Show()
end)
