local spacing = 10
local tabwidth = 150

pfStudio.editor = windget.window:CreateWindow("Editor", 800, 400)
pfStudio.editor:SetMinResize(300, 200)
pfStudio.editor.tabs = {}

pfStudio.editor:RegisterEvent("VARIABLES_LOADED")
pfStudio.editor:SetScript("OnEvent", function()
  pfStudio.editor:RefreshTabs()
end)

pfStudio.editor.input = windget.widget:CreateWidget("EditBox", nil, pfStudio.editor)
pfStudio.editor.input:SetBackdropColor(0,0,0,.35)
pfStudio.editor.input:SetPoint("TOPLEFT", pfStudio.editor, "TOPLEFT", tabwidth, -spacing)
pfStudio.editor.input:SetPoint("BOTTOMRIGHT", pfStudio.editor, "BOTTOMRIGHT", -spacing, spacing)
pfStudio.editor.input:SetFontObject(GameFontWhite)
pfStudio.editor.input:SetFont(windget.fontmono, windget.fontsizemono, windget.fontopts)
pfStudio.editor.input:SetAutoFocus(false)
pfStudio.editor.input:SetMultiLine(true)
pfStudio.editor.input:SetScript("OnEscapePressed", function(self)
  this:ClearFocus()
end)

pfStudio.editor.input:SetScript("OnTextChanged", function(self)
  local id = pfStudio.editor:GetID()
  if not pfStudio.editor.tabs[id] then return end

  local index = pfStudio.editor.tabs[id]:GetID()
  pfStudio_saved.code[index] = pfStudio.editor.input:GetText()

  if pfStudio.editor.tabs[id] then
    pfStudio.editor.tabs[id].text:SetText(pfStudio.editor:GetTitle(id))
  end
end)

pfStudio.editor.input:SetScript("OnTabPressed", function()
  this:Insert("  ")
end)

-- create tab button
pfStudio.editor.createtab = windget.widget:CreateWidget("Button", nil, pfStudio.editor)
windget.widget:SkinButton(pfStudio.editor.createtab)
pfStudio.editor.createtab:SetWidth(tabwidth - spacing*2)
pfStudio.editor.createtab:SetHeight(5)
pfStudio.editor.createtab.text:SetText("+")
pfStudio.editor.createtab:SetScript("OnClick", function()
  pfStudio.editor:NewTab()
end)

--[[ Functions ]]--
function pfStudio.editor:RunCode()
  local activeTab = pfStudio.editor.tabs[pfStudio.editor:GetID()]
  RunScript(pfStudio_saved.code[activeTab:GetID()])
end

function pfStudio.editor:DebugCode()
  -- save old environment
  local old_message = message
  local old_error = ScriptErrors:GetScript("OnShow")
  local old_default = DEFAULT_CHAT_FRAME

  -- switch to debug
  DEFAULT_CHAT_FRAME = pfStudio.debug.scroll

  message = function (msg)
    pfStudio.debug.scroll:AddMessage("|cff555555" .. date("%H:%M:%S") .. "|r " .. "|cffcccc33INFO  |cffffffff"..msg)
  end

  ScriptErrors:SetScript("OnShow", function(msg)
    pfStudio.debug.scroll:AddMessage("|cff555555" .. date("%H:%M:%S") .. "|r " .. "|cffcc3333ERROR |cffffffff"..ScriptErrors_Message:GetText())
    ScriptErrors:Hide()
  end)

  -- run code
  local activeTab = pfStudio.editor.tabs[pfStudio.editor:GetID()]
  local title = pfStudio.editor:GetTitle(pfStudio.editor:GetID())
  pfStudio.debug.scroll:AddMessage("|cff555555" .. date("%H:%M:%S") .. "|r " .. "|cffccccccSTART |cffaaaaaa'" .. title .. "'")
  RunScript(pfStudio_saved.code[activeTab:GetID()])
  pfStudio.debug.scroll:AddMessage("|cff555555" .. date("%H:%M:%S") .. "|r " .. "|cffccccccDONE")

  if not pfStudio.debug:IsShown() then
    pfStudio.debug:Show()
    pfStudio.debug.title:Show()
  end

  -- restore old environment
  message = old_message
  DEFAULT_CHAT_FRAME = old_default
  ScriptErrors:SetScript("OnShow", old_error)
end

function pfStudio.editor:GetTitle(id)
  local index = pfStudio.editor.tabs[id]:GetID()
  local text = pfStudio_saved.code[index]

  if not text or ( text and text == "" ) then
    return "[Empty]"
  end

  text = strsub(text, 0, string.find(text, "\n") or 20)
  text = string.gsub(text, "%W",'')
  text = strsub(text, 0, 20)
  return text
end

function pfStudio.editor:NewTab()
  local max = 0
  for i,_ in pairs(pfStudio_saved.code) do
    if i > max then max = i end
  end
  pfStudio_saved.code[max+1] = ""
  pfStudio.editor:RefreshTabs(true)
end

function pfStudio.editor:DeleteTab(id)
  local index = pfStudio.editor.tabs[id]:GetID()
  pfStudio.editor.tabs[id]:Hide()
  pfStudio_saved.code[index] = nil

  -- table.getn aborts on the first "nil", get the max number...
  local max = 0
  for index, _ in pairs(pfStudio_saved.code) do
    if index > max then max = index end
  end

  -- add tab if none is existing
  if max == 0 then pfStudio.editor:NewTab() end
  if max == id then
    pfStudio.editor:RefreshTabs(1)
  else
    pfStudio.editor:RefreshTabs()
  end
end

function pfStudio.editor:SelectTab(id)
  for _,frame in pairs(pfStudio.editor.tabs) do
    frame:SetAlpha(.5)
  end

  pfStudio.editor.tabs[id]:SetAlpha(1)
  pfStudio.editor.input:SetText(pfStudio_saved.code[pfStudio.editor.tabs[id]:GetID()] or "")
  pfStudio.editor:SetID(id)
  pfStudio_saved.tab = id
end

function pfStudio.editor:RefreshTabs(latest)
  if not pfStudio_saved.code then pfStudio_saved.code = { [1] = ""} end

  -- hide all tabs
  for _,f in pairs(pfStudio.editor.tabs) do f:Hide() end

  -- table.getn aborts on the first "nil", get the max number...
  local max = 0
  for index, _ in pairs(pfStudio_saved.code) do
    if index > max then max = index end
  end

  -- inpairs is randomly sorted, iterating manually...
  local i = 0
  for index=0,max do
    if pfStudio_saved.code[index] then
      -- create frame if required
      if not pfStudio.editor.tabs[i] then
        pfStudio.editor.tabs[i] = windget.widget:CreateWidget("Button", nil, pfStudio.editor)
        windget.widget:SkinButton(pfStudio.editor.tabs[i])
        pfStudio.editor.tabs[i]:SetBackdropColor(0,0,0,.35)
        pfStudio.editor.tabs[i]:SetPoint("TOPLEFT", spacing, -(i)*(24+1+spacing) -spacing)
        pfStudio.editor.tabs[i]:SetWidth(tabwidth - spacing*2)
        pfStudio.editor.tabs[i]:SetHeight(24)
        pfStudio.editor.tabs[i]:SetAlpha(.5)
        pfStudio.editor.tabs[i].tab = i

        pfStudio.editor.tabs[i]:SetScript("OnClick", function()
          pfStudio.editor:SelectTab(this.tab)
        end)

        pfStudio.editor.tabs[i].close = windget.widget:CreateWidget("Button", nil, pfStudio.editor.tabs[i])
        windget.widget:SkinButton(pfStudio.editor.tabs[i].close, "Interface\\AddOns\\pfStudio\\img\\delete")
        pfStudio.editor.tabs[i].close:SetFrameLevel(pfStudio.editor.tabs[i]:GetFrameLevel() + 1)
        pfStudio.editor.tabs[i].close:SetPoint("LEFT", pfStudio.editor.tabs[i], "LEFT", 8, 0)
        pfStudio.editor.tabs[i].close:SetWidth(8)
        pfStudio.editor.tabs[i].close:SetHeight(8)
        pfStudio.editor.tabs[i].close:SetAlpha(pfStudio.editor.tabs[i]:GetAlpha())
        pfStudio.editor.tabs[i].close:SetScript("OnClick", function()
          pfStudio.editor:DeleteTab(this:GetParent().tab)
        end)
      end

      pfStudio.editor.tabs[i]:Show()
      pfStudio.editor.tabs[i]:SetID(index)
      pfStudio.editor.tabs[i].text:SetText(pfStudio.editor:GetTitle(i))

      -- if arg is set, focus the newest tab
      if latest then pfStudio.editor:SelectTab(i) end
      i = i + 1
    end
  end

  -- adjust window and other widgets
  pfStudio.editor.createtab:ClearAllPoints()
  pfStudio.editor.createtab:SetPoint("TOPLEFT", spacing, -(i)*(24+1+spacing) -spacing)

  local minheight = i*(25+spacing) + 2*spacing + 5
  pfStudio.editor:SetMinResize(300, minheight)
  if pfStudio.editor:GetHeight() < minheight then
    pfStudio.editor:SetHeight(minheight)
  end

  if pfStudio.editor.tabs[pfStudio_saved.tab or 1] then
    pfStudio.editor:SelectTab(pfStudio_saved.tab or 1)
  end
end
