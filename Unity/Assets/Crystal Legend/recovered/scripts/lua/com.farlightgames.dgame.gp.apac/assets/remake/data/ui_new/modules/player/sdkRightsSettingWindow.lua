local base = ed.ui.popwindow
local sdkRightsSettingWindow = newclass(base.mt)
ed.ui.sdkRightsSettingWindow = sdkRightsSettingWindow

function sdkRightsSettingWindow.open()
  sdkRightsSettingWindow.create():popWindow(500)
end

function sdkRightsSettingWindow.create(param)
  local self = base.create("sdkRightsSettingWindow")
  setmetatable(self, sdkRightsSettingWindow.mt)
  scope = {}
  self:initView()
  self:listenEvent("applicationWillEnterForeground", function()
    if self.uiPanel then
      self.uiPanel:removeFromParentAndCleanup(true)
      self:initView()
    end
  end)
  return self
end

function sdkRightsSettingWindow:initView()
  local container, ui = ed.editorui(ed.uieditor.sdkRightsSettingWindow)
  self.ui = ui
  self.uiPanel = container
  self.container:addChild(container)
  self:btRegisterButtonClick({
    button = self.ui.close,
    press = self.ui.close_press,
    pressScale = 0.9,
    key = "closeBtn",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.5,
    force = true,
    priority = -1
  })
  self:initDragList()
end

local rightsList = {
  {
    name = T("\229\164\150\233\131\168\229\173\152\229\130\168\232\175\187\229\143\150\230\157\131\233\153\144"),
    icon = "installer/service/service_power_disk.png",
    key = T("read_write_storage"),
    desc = T("\229\188\128\233\128\154\230\173\164\230\157\131\233\153\144\231\148\168\228\186\142\229\155\190\231\137\135\228\184\138\228\188\160\229\138\159\232\131\189\227\128\130")
  },
  {
    name = T("\232\174\190\229\164\135\228\191\161\230\129\175\230\157\131\233\153\144"),
    icon = "installer/service/service_power_rom.png",
    key = "phone_info",
    desc = T("\229\188\128\233\128\154\230\173\164\230\157\131\233\153\144\229\144\142\229\133\129\232\174\184APP\232\142\183\229\143\150\232\174\190\229\164\135ID,\228\184\186\230\130\168\230\184\184\230\136\143\232\180\166\229\143\183\232\142\183\229\190\151\230\155\180\229\174\137\229\133\168\231\154\132\230\149\176\230\141\174\228\191\157\233\154\156\227\128\130")
  }
}
if EDFLAGIOS then
  rightsList = {
    {
      name = T("\231\155\184\230\156\186\230\157\131\233\153\144"),
      icon = "installer/service/service_power_camara.png",
      key = "camera",
      desc = T("\229\188\128\233\128\154\230\173\164\230\157\131\233\153\144\231\148\168\228\186\142\230\139\141\230\145\132\231\133\167\231\137\135\227\128\130")
    },
    {
      name = T("\231\133\167\231\137\135\230\157\131\233\153\144"),
      icon = "installer/service/service_power_disk.png",
      key = "photo",
      desc = T("\229\188\128\233\128\154\230\173\164\230\157\131\233\153\144\231\148\168\228\186\142\229\143\145\233\128\129\229\155\190\231\137\135\227\128\130")
    },
    {
      name = T("\233\186\166\229\133\139\233\163\142\230\157\131\233\153\144"),
      icon = "installer/service/service_power_mic.png",
      key = "microphone",
      desc = T("\229\188\128\233\128\154\230\173\164\230\157\131\233\153\144\231\148\168\228\186\142\229\189\149\229\136\182\232\167\134\233\162\145\227\128\130")
    },
    {
      name = T("\230\149\176\230\141\174\232\191\189\232\184\170\230\157\131\233\153\144"),
      icon = "installer/service/service_power_rom.png",
      key = "idfa",
      desc = T("\229\188\128\233\128\154\230\173\164\230\157\131\233\153\144\229\144\142\229\133\129\232\174\184APP\232\142\183\229\143\150\232\174\190\229\164\135ID,\228\184\186\230\130\168\230\184\184\230\136\143\232\180\166\229\143\183\232\142\183\229\190\151\230\155\180\229\174\137\229\133\168\231\154\132\230\149\176\230\141\174\228\191\157\233\154\156\227\128\130")
    }
  }
end
sdkRightsSettingWindow.rightsList = rightsList

function sdkRightsSettingWindow:isAuthorized(data)
  if EDFLAGANDROID or EDFLAGIOS then
    return EDGetParam("checkPermission|" .. data.key) == "true"
  end
  return false
end

function sdkRightsSettingWindow:authorize()
  EDGetParam("openAppSetting")
end

function sdkRightsSettingWindow:initDragList()
  local function doPressIn(listdata)
    local function handler(x, y)
      for index, value in ipairs(listdata) do
        if value.portrait:isVisible() and ed.containsPoint(value.portrait, x, y) then
          return value
        end
      end
    end
    
    return handler
  end
  
  local function doClickInList(listdata)
    local function handler(x, y, data)
      self:authorize()
    end
    
    return handler
  end
  
  local size = self.ui.content_rights:getContentSize()
  local itemSize = ed.DGSizeMake(1101, 160)
  local param = {
    listData = rightsList,
    createIconHandler = function(data)
      local container, ui = ed.editorui(ed.uieditor.rightsSettingItem)
      ui.right_name:setString(data.name)
      ui.right_desc:setDimensions(ed.DGSizeMake(876, 71))
      ui.right_desc:setString(data.desc)
      local isAuthorized = self:isAuthorized(data)
      ui.right_ok:setVisible(isAuthorized)
      ui.right_no:setVisible(not isAuthorized)
      return container, ui.right_no
    end,
    container = self.ui.content_rights,
    cliprect = CCRect(0, 0, size.width, size.height),
    doPressIn = doPressIn,
    doClickInList = doClickInList,
    icon_ori_x = 5,
    icon_gap_x = itemSize.width,
    icon_ori_y = size.height - itemSize.height,
    icon_gap_y = itemSize.height,
    colunNum = 1,
    touchpriority = -301,
    noshade = true
  }
  self.draglist = ed.fastCreateDragList(self, param)
end
