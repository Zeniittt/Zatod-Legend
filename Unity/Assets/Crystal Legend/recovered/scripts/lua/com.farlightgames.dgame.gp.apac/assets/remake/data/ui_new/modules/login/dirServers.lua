local base = ed.ui.popwindow
local dirServersWin = newclass(base.mt)
ed.ui.dirServersWin = dirServersWin
local serverDirs = {
  "appstore",
  "android",
  "ctest",
  "ctest2",
  "ptr",
  "douyin",
  "media",
  "dev",
  "tw.cbt"
}
ed.ui.dirServersWin.Dirs = serverDirs

function dirServersWin.create()
  local self = base.create("dirServersWin")
  setmetatable(self, dirServersWin.mt)
  self:initView()
  self:registerCloseBtnClick()
  self:initContentView()
  return self
end

function dirServersWin:registerCloseBtnClick()
  self:btRegisterButtonClick({
    button = self.ui.closeBtn,
    press = self.ui.closeBtn_press,
    clickHandler = function()
      self:destroy({skipAnim = true})
    end
  })
end

function dirServersWin:initContentView()
  self.itemTotalH = 0
  self.itemArray = {}
  self:initListView()
  local curDir = ed.getCurDirServer()
  curDir = string.sub(curDir, 1, 20) .. "..." .. string.sub(curDir, -20)
  self:addTextItem("\229\189\147\229\137\141\230\156\141\229\138\161\229\153\168\229\156\176\229\157\128:" .. curDir, "title_yellow", 0)
  local dirs = ed.ui.dirServersWin.Dirs
  for i, v in ipairs(dirs) do
    self:addItem(v, i)
  end
end

function dirServersWin:initListView()
  local posX, posY = self.ui.content_rights:getPosition()
  local size = self.ui.content_rights:getContentSize()
  local dragListConfig = {
    cliprect = CCRectMake(0, 0, size.width, size.height),
    noshade = true,
    container = self.ui.content_rights,
    priority = self.mainTouchPriority - 5,
    zorder = 99,
    mcpMode = true,
    doPressIn = self:getPressInHandler()
  }
  self.dragList = ed.draglist.create(dragListConfig)
end

function dirServersWin:getPressInHandler()
  local origin_dir = dir_servers[1]
  print("origin_dir", origin_dir)
  
  local function delayRestart()
    ListenTimer(Timer:Once(1), function()
      EDRestartGame()
    end)
  end
  
  local function handler(x, y)
    for i, v in ipairs(self.itemArray) do
      if ed.containsPoint(v.label, x, y) then
        if v.idx == 0 then
          return
        end
        local match = string.match(origin_dir, "/1%.0/(.-)%.iPhone/")
        if match then
          local newDir = string.gsub(origin_dir, match .. ".iPhone/", v.text .. ".iPhone/")
          print("newDir", newDir)
          ed.showToast(newDir)
          ed.storage.setValue("cus_dir_servers", newDir)
          delayRestart()
        else
          ed.showToast("not supported!")
        end
      end
    end
  end
  
  return handler
end

function dirServersWin:addItem(text, idx)
  self:addTextItem(text, "normalButton", idx)
end

function dirServersWin:addTextItem(text, fontInfo, idx)
  local size = self.ui.content_rights:getContentSize()
  local posY = size.height
  local width = size.width
  local gapY = 8
  local label = ed.createLabelWithFontInfo(text, fontInfo)
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  local size = label:getContentSize()
  local width, height = size.width, size.height
  label:setPosition(ccp(width / 2, posY - (self.itemTotalH + gapY) - height / 2))
  self.itemTotalH = self.itemTotalH + height + gapY
  self.dragList:addItem(label)
  self.dragList:initListHeight(self.itemTotalH)
  table.insert(self.itemArray, {
    label = label,
    text = text,
    idx = idx
  })
end

function dirServersWin:initView()
  local dirServers = {
    {
      config = {
        rotation = 0,
        flip = "",
        opacity = 255,
        visible = true,
        scaleSize = CCSizeMake(635, 412.5)
      },
      t = "Scale9Sprite",
      base = {
        capInsets = CCRectMake(7.5, 7.5, 7.5, 7.5),
        res = "installer/login/serverlist_bg.png",
        name = "frame",
        z = 0
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(480, 270)
      }
    },
    {
      config = {
        rotation = 0,
        flip = "",
        opacity = 255,
        visible = true,
        scaleSize = CCSizeMake(626, 42)
      },
      t = "Scale9Sprite",
      base = {
        name = "title_bg",
        z = 0,
        parent = "frame",
        res = "installer/service/title_bg.png",
        capInsets = CCRectMake(50, 12.5, 50, 12.5)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(316.5, 382.75)
      }
    },
    {
      config = {
        rotation = 0,
        scalexy = {y = 1, x = 1},
        horizontalAlignment = 0,
        flip = "",
        color = ccc3(255, 210, 16),
        opacity = 255,
        verticalAlignment = 0,
        visible = true
      },
      t = "Label",
      base = {
        name = "title",
        z = 1,
        parent = "title_bg",
        text = "\229\136\135\230\141\162\230\156\141\229\138\161\229\153\168\231\155\174\229\189\149",
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(313, 21)
      }
    },
    {
      config = {
        rotation = 0,
        flip = "",
        opacity = 255,
        visible = true,
        scaleSize = CCSizeMake(570.5, 322)
      },
      t = "Layer",
      base = {
        parent = "frame",
        name = "content_rights",
        z = 2
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(32, 21.25)
      }
    },
    {
      config = {
        rotation = 0,
        scaleSize = CCSizeMake(54, 55),
        flip = "",
        labelConfig = {
          color = ccc3(253, 240, 158)
        },
        opacity = 255,
        visible = true,
        pressConfig = {flip = ""}
      },
      t = "DGButton",
      base = {
        normal = "UI/alpha/1080P/common/break_butt_bj.png",
        capInsets = CCRectMake(15, 15, 15, 10),
        name = "closeBtn",
        z = 0,
        parent = "frame",
        text = "",
        press = "UI/alpha/1080P/common/break_butt_bj.png",
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(610, 397.25)
      }
    },
    {
      config = {
        rotation = 0,
        fix_scale = {y = 1, x = 1},
        flip = "",
        opacity = 255,
        fix_wh = {w = 33, h = 33},
        visible = true
      },
      t = "Sprite",
      base = {
        parent = "closeBtn",
        res = "UI/alpha/1080P/common/butt_off.png",
        name = "ImageView_464",
        z = 0
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(27, 27.5)
      }
    }
  }
  local container, ui = ed.editorui(dirServers)
  self.container:addChild(container)
  self.ui = ui
end
