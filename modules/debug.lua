local spacing = 10
local tabwidth = 150

pfStudio.debug = windget.window:CreateWindow("Debug", 600, 300)
pfStudio.debug:SetMinResize(160, 60)

pfStudio.debug.scroll = windget.widget:CreateWidget("ScrollingMessageFrame", nil, pfStudio.debug)
pfStudio.debug.scroll:SetBackdropColor(0,0,0,.35)
pfStudio.debug.scroll:SetPoint("TOPLEFT", pfStudio.debug, "TOPLEFT", spacing, -spacing)
pfStudio.debug.scroll:SetPoint("BOTTOMRIGHT", pfStudio.debug, "BOTTOMRIGHT", -spacing, spacing)
pfStudio.debug.scroll:SetFontObject(GameFontWhite)
pfStudio.debug.scroll:SetFont(windget.fontmono, windget.fontsizemono, windget.fontopts)
pfStudio.debug.scroll:SetMaxLines(150)
pfStudio.debug.scroll:SetJustifyH("LEFT")
pfStudio.debug.scroll:SetFading(false)

pfStudio.debug.scroll:SetScript("OnHyperlinkClick", function()
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
