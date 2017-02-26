-- windget - Provides WINDow- and widGET elements.

-- windget.window:CreateTitleBar(name, parent)
-- name: window title
-- parent: docked window-frame

-- windget.window:CreateWindow(name, width, height, show, fixed)
-- name: frame name
-- width: width
-- height: height
-- show: shown by default
-- fixed: not resizable

-- windget.window:SetFocus(frame)
-- frame: window-frame

-- windget.window:MouseHandler(button, frame, force)
-- button: pressed mousebutton
-- frame: window-frame
-- force: always resize, not only if alt is pressed

-- windget.window:Maximize(frame)
-- frame: window-frame

-- windget.window:Minimize(frame)
-- frame: window-frame

-- windget.widget:CreateWidget(type, name, parent, template)
-- same as CreateFrame

-- windget.widget:SkinButton(frame, icon)
-- frame: button frame
-- icon: texture path, if not set, a text box will be created instead

windget = { window = {}, widget = {} }

-- setup default vars
windget.spacing = 5
windget.color1 = { .18, .20, .25, .9 }
windget.color2 = { .20, .22, .28, 1 }
windget.color3 = { .20, .80, 1.0, 1 }

windget.backdrop = {}
windget.window.backdrop = {
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8,
  insets = { left = 0, right = 0, top = 0, bottom = 0 }
}

windget.widget.backdrop = {
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8,
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 8, edgeSize = 8,
  insets = { left = -windget.spacing, right = -windget.spacing, top = -windget.spacing, bottom = -windget.spacing }
}

windget.window.close = 1
windget.window.minimize = 1
windget.window.maximize = 1

windget.font = "Fonts\\ARIALN.TTF"
windget.fontmono = "Fonts\\ARIALN.TTF"
windget.fontsize = 12
windget.fontsizemono = 12
windget.fontopts = "NORMAL"

--[[ Window Elements ]]--
function windget.window:CreateTitleBar(name, parent)
  local frame = CreateFrame("Button", name .. "TitleBar", UIParent)
  frame:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 0)
  frame:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT", 0, 0)
  frame:SetToplevel(true)
  frame:SetHeight(22)

  frame.docked = parent

  -- Window Caption
  frame.caption = frame:CreateFontString("Status", "DIALOG", "GameFontNormal")
  frame.caption:SetAllPoints(frame)
  frame.caption:SetFontObject(GameFontWhite)
  frame.caption:SetFont(windget.font, windget.fontsize, windget.fontopts)
  frame.caption:SetJustifyH("LEFT")
  frame.caption:SetJustifyV("CENTER")
  frame.caption:SetText("  " .. name)

  frame:SetBackdrop(windget.window.backdrop)
  frame:SetBackdropColor(unpack(windget.color1))
  frame:SetBackdropBorderColor(unpack(windget.color2))

  frame:SetScript("OnMouseDown",function()
    windget.window:MouseHandler(arg1, this.docked, true)
  end)

  frame:SetScript("OnMouseUp",function()
    this.docked:StopMovingOrSizing()
  end)

  frame:SetScript("OnDoubleClick", function()
    windget.window:Maximize(this)
  end)

  -- close
  frame.close = CreateFrame("Button", nil, frame)
  windget.widget:SkinButton(frame.close, windget.window.close)
  frame.close.tex:SetVertexColor(.84, .34, .36)
  frame.close:SetPoint("TOPRIGHT", -8, -3)
  frame.close:SetWidth(16)
  frame.close:SetHeight(16)
  frame.close:SetScript("OnClick", function()
    this:GetParent().docked:Hide()
    this:GetParent():Hide()
  end)

  frame.close:SetScript("OnEnter", function()
    this.tex:SetVertexColor(.8, .47, .49)
  end)

  frame.close:SetScript("OnLeave", function()
    this.tex:SetVertexColor(.84, .34, .36)
  end)

  if parent:IsResizable() then
    -- max
    frame.max = CreateFrame("Button", nil, frame)
    windget.widget:SkinButton(frame.max, windget.window.maximize)
    frame.max:SetPoint("TOPRIGHT", -32, -3)
    frame.max:SetWidth(16)
    frame.max:SetHeight(16)
    frame.max:SetScript("OnClick", function()
      windget.window:Maximize(this:GetParent())
    end)

    -- min
    frame.min = CreateFrame("Button", nil, frame)
    windget.widget:SkinButton(frame.min, windget.window.minimize)
    frame.min:SetPoint("TOPRIGHT", -56, -3)
    frame.min:SetWidth(16)
    frame.min:SetHeight(16)
    frame.min:SetScript("OnClick", function()
      windget.window:Minimize(this:GetParent())
    end)
  end

  return frame
end

function windget.window:CreateWindow(name, width, height, show, fixed)
  local frame = CreateFrame("Frame", name, UIParent)
  frame:SetToplevel(true)

  frame:SetPoint("CENTER", 0, 0)
  frame:SetWidth(width)
  frame:SetHeight(height)
  frame:SetBackdrop(windget.window.backdrop)
  frame:SetBackdropColor(unpack(windget.color1))
  frame:SetBackdropBorderColor(unpack(windget.color2))

  frame:SetMovable(true)

  if fixed then
    frame:SetResizable(false)
  else
    frame:SetResizable(true)
  end

  frame:EnableMouse(true)
  frame:SetScript("OnMouseDown",function()
    windget.window:MouseHandler(arg1, this)
  end)

  frame:SetScript("OnMouseUp",function()
    this:StopMovingOrSizing()
  end)

  frame.movable = frame

  frame.title = windget.window:CreateTitleBar(name, frame)

  if not show then
    frame:Hide()
    frame.title:Hide()
  end

  return frame
end

function windget.window:SetFocus(frame)
  frame:Raise()
  frame.title:Raise()
end

function windget.window:MouseHandler(button, frame, force)
  if frame.max then return end
  windget.window:SetFocus(frame)
  if force or ( IsAltKeyDown() and button == "LeftButton") then
    frame:StartMoving()
  elseif IsAltKeyDown() and button == "RightButton" and frame:IsResizable() then
    frame:StartSizing()
  end
end

function windget.window:Maximize(frame)
  -- prevent fixed windows from being maximized
  if not frame.docked:IsResizable() then return end

  -- if minimized, restore window and exit
  if not frame.docked:IsShown() then windget.window:Minimize(frame) return end

  -- frame: window decoration frame
  if not frame.docked.max then
    frame.docked.max = true
    frame.width = frame.docked:GetWidth()
    frame.height = frame.docked:GetHeight()

    frame.docked:ClearAllPoints()
    frame.docked:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -frame:GetHeight())
    frame.docked:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
  else
    frame.docked.max = nil
    frame.docked:ClearAllPoints()
    frame.docked:SetPoint("CENTER", 0, 0)
    frame.docked:SetWidth(frame.width)
    frame.docked:SetHeight(frame.height)
  end
end

function windget.window:Minimize(frame)
  if frame.docked:IsShown() then
    frame.docked:Hide()
  else
    frame.docked:Show()
  end
end

--[[ widgets ]]--
function windget.widget:CreateWidget(type, name, parent, template)
  local frame = CreateFrame(type, name, parent, template)

  frame:SetBackdrop(windget.widget.backdrop)
  frame:SetBackdropColor(0,0,0,.25)

  frame.movable = frame:GetParent().movable

  frame:SetScript("OnMouseDown",function()
    windget.window:MouseHandler(arg1, this.movable)
  end)

  frame:SetScript("OnMouseUp",function()
    this.movable:StopMovingOrSizing()
  end)

  return frame
end

function windget.widget:SkinButton(frame, icon)
  if icon then
    frame.tex = frame:CreateTexture("BACKGROUND")
    frame.tex:SetAllPoints(frame)
    frame.tex:SetTexture(icon)

    frame:SetScript("OnEnter", function()
      this.tex:SetVertexColor(unpack(windget.color3))
      if this.tooltip then
        GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT", 12, -12)
        GameTooltip:ClearLines()
        GameTooltip:AddLine(this.tooltip, 1,1,1)
        GameTooltip:Show()
        GameTooltip:SetBackdropColor(0,0,0,.8)
        GameTooltip:SetBackdropBorderColor(0,0,0,0)
      end
    end)

    frame:SetScript("OnLeave", function()
      this.tex:SetVertexColor(1,1,1,1)
      if this.tooltip then
        GameTooltip:Hide()
      end
    end)
  else
    frame.text = frame:CreateFontString("Status", "DIALOG", "GameFontNormal")
    frame.text:SetAllPoints(frame)
    frame.text:SetFontObject(GameFontWhite)
    frame.text:SetFont(windget.font, windget.fontsize, windget.fontopts)
    frame.text:SetJustifyH("CENTER")
    frame.text:SetJustifyH("CENTER")
  end

  frame:SetHitRectInsets(-windget.spacing,-windget.spacing,-windget.spacing,-windget.spacing)

  return frame
end
