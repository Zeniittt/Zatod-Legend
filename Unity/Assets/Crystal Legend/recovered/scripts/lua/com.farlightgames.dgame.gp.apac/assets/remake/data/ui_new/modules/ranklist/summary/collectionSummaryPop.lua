local base = ed.ui.popwindow
local collectionSummaryPop = newclass(base.mt)
ed.ui.collectionSummaryPop = collectionSummaryPop

function collectionSummaryPop.create(param)
  local self = base.create("collectionSummaryPop", param)
  setmetatable(self, collectionSummaryPop.mt)
  self:init(param)
  self:popWindow()
  return self
end

function collectionSummaryPop:init(param)
  self.param = param
  self:initView()
  self:createView()
  self:addEventListener()
end

function collectionSummaryPop:initView()
  local container, ui = ed.editorui(ed.uieditor.collectionSummaryPop)
  self.ui = ui
  self.container:addChild(container)
  self:show()
end

function collectionSummaryPop:createView()
  local param = self.param
  local summary = param._user_summary
  local hand = ed.getTeamHead({
    id = summary._avatar or 1
  })
  hand:setPosition(129.5, 319)
  self.ui.bg:addChild(hand)
  hand:setScale(0.9)
  local name = ed.getPlayerName(ed.transBotName(summary._name or ""), summary._medal, {
    labelColor = "ccc3(253,240,119)",
    fontName = ed.fontBold
  })
  name:setPosition(129.5, 264)
  self.ui.bg:addChild(name)
  local rank = ed.rank_network.rank or 0
  rank = 100 < rank and T("100+") or rank
  rank = rank == 0 and T("\230\156\170\228\184\138\230\166\156") or rank
  self.ui.Label_guild_name:setString(summary._guild_name or T("\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154"))
  self.ui.Label_rank:setString(rank)
  self.ui.Label_avata:setString(param._avatar_num or 0)
  self.ui.Label_avata_f:setString(param._frame_num or 0)
  self.ui.Label_fashion:setString(param._fashion_num or 0)
  self.ui.Label_emg:setString(param._sticker_num or 0)
  self.ui.Label_pvp_bg:setString(param._background_num or 0)
  for i = 1, 4 do
    self.ui["ImageView_00" .. i]:setOpacity(100)
  end
end

function collectionSummaryPop:addEventListener()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "close",
    force = true,
    clickInterval = 0.2,
    clickHandler = function()
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.ImageView_btn,
    key = "ImageView_btn",
    pressScale = 0.96,
    clickHandler = function()
      local param = self.param
      local summary = param._user_summary
      if summary._level > 0 then
        if ed.getRoleId() ~= summary._role_id then
          ed.registerNetReply("req_home_page", function(data)
            local panel = ed.ui.PlayerInfoPanel.create(data, false)
            panel:popWindow()
          end)
          ed.PlayerInfoNetwork:requestHomePage(summary._role_id)
        else
          ed.registerNetReply("personal_home_page", function(data)
            local panel = ed.ui.PlayerInfoPanel.create(data, true)
            panel:popWindow()
          end)
          ed.PlayerInfoNetwork:openPanel()
        end
      else
        ed.showToast(T("\231\139\130\230\172\162\231\154\132\232\138\130\230\151\165\229\143\170\233\156\128\232\166\129\230\191\128\230\131\133\228\184\141\233\156\128\232\166\129\229\144\141\229\146\140\229\167\147"))
      end
    end
  })
end
