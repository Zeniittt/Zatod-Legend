local module = {
  editorui = function(self)
    local mainLayer = self.mainLayer
    local frameContainer, frameui = ed.editorui(ed.uieditor.GuildClashRankScene)
    mainLayer:addChild(frameContainer)
    local addWid, addHei = ed.display.halfFixedWidth, ed.display.halfFixedHeight
    frameui.ImageView_700:setPositionX(frameui.ImageView_700:getPositionX() - addWid)
    frameui.ImageView_700:setPositionY(frameui.ImageView_700:getPositionY() + addHei)
    frameui.Label_936:setFontName(ed.fontBold)
    frameui.Label_936:setStroke(ed.toccc3(4273197), 1.2)
    ed.UITool.createSceneTitle(T("\230\142\146\232\161\140\230\166\156"), frameui.ImageView_700, {
      position = ccp(9, 18)
    })
    return frameContainer, frameui
  end,
  top3 = {
    create = function(this, scene)
      this.rankNumberRes = {
        "1st",
        "2nd",
        "3rd"
      }
      this.rankLightRes = {
        "ranking_yellow",
        "ranking_blue",
        "ranking_gold"
      }
      this.rankheadScale = {
        1,
        0.85,
        0.85
      }
      this.rankheadAddY = {
        60,
        55,
        55
      }
      this:refresh(scene)
    end,
    refresh = function(this, scene)
      local data = scene.data:getNewRankData()
      if not data then
        return
      end
      for i = 1, 3 do
        scene.ui["ImageView_head_" .. i]:removeAllChildrenWithCleanup(true)
        scene.ui["ImageView_nameBj_" .. i]:removeAllChildrenWithCleanup(true)
        if data[i] then
          if scene.data.newMode == "guild_rank" then
            scene.ui["Label_" .. i]:setAnchorPoint(ccp(0.5, 0.5))
            scene.ui["Label_" .. i]:setPositionX(80)
            scene.ui["Label_" .. i]:setString(T(scene.data:getNewRankLabel(), data[i].number, data[i].number2))
          else
            scene.ui["Label_" .. i]:setAnchorPoint(ccp(0, 0.5))
            scene.ui["Label_" .. i]:setPositionX(18)
            scene.ui["Label_" .. i]:setString(scene.data:getNewRankLabel() .. ":" .. data[i].number)
          end
          scene.ui["Label_" .. i]:setOpacity(0)
          scene.ui["Label_" .. i]:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.03), CCFadeIn:create(0.1)))
          local size = scene.ui["ImageView_head_" .. i]:getContentSize()
          local hand
          local guildSummary = data[i].guildSummary or {}
          if scene.data.newMode == "guild_rank" then
            local avatarData = ed.analyzeAvatar(guildSummary._avatar)
            hand = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
          else
            hand = ed.getTeamHead({
              id = data[i].avatar
            })
          end
          hand:setPosition(size.width / 2, size.height / 2 + this.rankheadAddY[i])
          scene.ui["ImageView_head_" .. i]:addChild(hand)
          hand:setScale(this.rankheadScale[i])
          hand:setCascadeOpacityEnabled(true)
          hand:setOpacity(0)
          hand:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.03), CCFadeIn:create(0.1)))
          local light = ed.createSpriteTools({
            res = string.format("UI/alpha/1080P/rankingscene/%s.png", this.rankLightRes[i]),
            pos = ccp(15, size.height + this.rankheadAddY[i] - 20),
            parent = scene.ui["ImageView_head_" .. i]
          })
          local number = ed.createSpriteTools({
            res = string.format("UI/alpha/1080P/rankingscene/%s.png", this.rankNumberRes[i]),
            pos = ccp(15, size.height + this.rankheadAddY[i] - 20),
            parent = scene.ui["ImageView_head_" .. i]
          })
          size = scene.ui["ImageView_nameBj_" .. i]:getContentSize()
          if scene.data.newMode == "guild_rank" then
            local label = ed.createLabelTools({
              txt = T(guildSummary._name),
              size = 18,
              pos = ccp(size.width / 2, size.height / 2 + 2),
              color = ccc3(255, 252, 231),
              parent = scene.ui["ImageView_nameBj_" .. i],
              stroke = {
                ccc3(ed.colorToStr("#614017")),
                1
              }
            })
            label:setOpacity(0)
            label:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.03), CCFadeIn:create(0.1)))
          else
            local sameGuild = data[i].number2 and data[i].number2 == 1
            local name, _, autoText = ed.getPlayerName(data[i].name, data[i].medal, {
              anchorPoint = ccp(0.5, 0.5),
              labelColor = sameGuild and "ccc3(67,59,56)" or "ccc3(255,156,108)",
              labelStroke = sameGuild and "nil" or "ccc3(82,25,19)"
            })
            name:setPosition(size.width / 2, size.height / 2 + 2)
            scene.ui["ImageView_nameBj_" .. i]:addChild(name)
            autoText.node:setOpacity(0)
            autoText.node:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.03), CCFadeIn:create(0.1)))
          end
          scene:btRemoveMainTouchHandler({
            key = "hand_" .. i
          })
          if scene.data.newMode == "guild_rank" then
            hand = hand.icon
          end
          scene:btRegisterButtonClick({
            button = hand,
            key = "hand_" .. i,
            clickHandler = function()
              if scene.data.newMode == "guild_rank" then
                if not guildSummary or not guildSummary._president then
                  return
                end
                local president = guildSummary._president
                local guild_summary = {
                  _avatar = guildSummary._avatar,
                  _name = guildSummary._name,
                  _id = guildSummary._id,
                  _president = {
                    _name = president._name or "",
                    _medal = president._medal
                  },
                  _member_cnt = guildSummary._member_cnt,
                  _slogan = guildSummary._slogan,
                  power = data[i].power,
                  server = data[i].server
                }
                ed.ui.guildSummaryWin.create(i, guild_summary):popWindow()
              else
                ed.registerNetReply("req_home_page", function(datas)
                  local panel = ed.ui.PlayerInfoPanel.create(datas, false)
                  panel:popWindow()
                end)
                ed.PlayerInfoNetwork:requestHomePage(data[i].role_id)
              end
            end,
            force = true,
            mcpMode = true,
            pressScale = hand:getScale() - 0.05,
            normalScale = hand:getScale()
          })
        else
          scene.ui["Label_" .. i]:setString("")
        end
      end
    end
  },
  dragList = {
    create = function(this, scene)
      this.myIcon = nil
      this.thisCon = scene.ui.Panel_697:getContentSize()
      this.dragList = ed.draglist.create({
        cliprect = CCRectMake(0, 0, this.thisCon.width, this.thisCon.height),
        container = scene.ui.Panel_697,
        cancelClickIn = function()
          this.moving = true
        end,
        doPressIn = function()
          if this.myIcon then
            this.moving = false
            for _, v in ipairs(this.myIcon.acttab) do
              v:stopAllActions()
              v:runAction(CCFadeTo:create(0.3, 50))
            end
          end
          return true
        end,
        cancelPressIn = function()
          if this.myIcon and not this.moving then
            for _, v in ipairs(this.myIcon.acttab) do
              v:stopAllActions()
              v:runAction(CCFadeTo:create(0.5, 255))
            end
          end
        end,
        stopMoveFun = function()
          if this.myIcon then
            for _, v in ipairs(this.myIcon.acttab) do
              v:stopAllActions()
              v:runAction(CCFadeTo:create(0.5, 255))
            end
            this.moving = false
          end
        end
      })
      this:refresh(scene)
    end,
    createItem = function(data, isAct, index, rankLabel, isSelf, scene)
      local acttab = {}
      local sprite = CCSprite:create()
      sprite:setContentSize(CCSizeMake(725, 82))
      if isSelf then
        table.insert(acttab, ed.createSpriteTools({
          res = "UI/alpha/1080P/guild/guild_clash_rank/info_my_floor.png",
          pos = ccp(362, 41),
          rectMake = CCRectMake(30, 21, 300, 40),
          sizeMake = CCSizeMake(732, 86),
          parent = sprite
        }))
      else
        table.insert(acttab, ed.createSpriteTools({
          res = "UI/alpha/1080P/crusade/bg_replay_item.png",
          pos = ccp(362, 41),
          rectMake = CCRectMake(25, 17, 500, 50),
          sizeMake = CCSizeMake(725, 82),
          parent = sprite
        }))
      end
      local pattern = ed.createSpriteTools({
        res = "UI/alpha/1080P/rankingscene/pattern_2.png",
        pos = ccp(72, 52),
        parent = sprite
      })
      local num = ed.getNumberNode({text = index, folder = "big_pvp"}).node
      num:setPosition(50, 41)
      sprite:addChild(num)
      local head
      local guildSummary = data.guildSummary
      if scene.data.newMode == "guild_rank" then
        local avatarData = ed.analyzeAvatar(guildSummary._avatar)
        head = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
      else
        head = ed.getTeamHead({
          id = data.avatar
        })
      end
      head:setPosition(130, 41)
      sprite:addChild(head)
      head:setScale(0.7)
      head:setCascadeOpacityEnabled(true)
      table.insert(acttab, head)
      if scene.data.newMode ~= "guild_rank" then
        local lvBg = ed.createSpriteTools({
          res = "UI/alpha/1080P/ranking/lv_bg.png",
          pos = ccp(35, 2),
          parent = head,
          scale = 1.1
        })
        local levelLabel = ed.createLabelTTF(data.level or 0, 16)
        ed.setLabelStroke(levelLabel, ccc3(43, 28, 8), 1)
        ed.setLabelColor(levelLabel, ccc3(251, 224, 116))
        levelLabel:setPosition(35, 2)
        head:addChild(levelLabel)
        local sameGuild = data.number2 and data.number2 == 1
        local name, _, autoText = ed.getPlayerName(data.name, data.medal, {
          anchorPoint = ccp(0, 0.5),
          labelColor = isSelf and "ccc3(255,252,231)" or sameGuild and "ccc3(67,59,56)" or "ccc3(255,156,108)",
          labelStroke = isSelf and "ccc3(39,37,36)" or sameGuild and "nil" or "ccc3(82,25,19)"
        })
        name:setPosition(180, 41)
        sprite:addChild(name)
        table.insert(acttab, autoText.node)
      else
        local stroke = isSelf and {
          ccc3(ed.colorToStr("#614017")),
          1
        } or nil
        local label = ed.createLabelTools({
          txt = T(guildSummary._name),
          size = 18,
          pos = ccp(180, 41),
          anchor = ccp(0, 0.5),
          color = isSelf and ccc3(255, 252, 231) or ccc3(67, 59, 56),
          parent = sprite,
          stroke = stroke
        })
        table.insert(acttab, label)
      end
      local numberBg = ed.createSpriteTools({
        res = "UI/alpha/1080P/guild/guild_clash_rank/info_others_rankbasis.png",
        rectMake = CCRectMake(15, 12, 1, 2),
        sizeMake = CCSizeMake(195, 26),
        pos = ccp(600, 41),
        parent = sprite
      })
      table.insert(acttab, numberBg)
      local numberIcon = ed.createSpriteTools({
        res = "UI/alpha/1080P/guild/guild_clash_rank/info_all_basisicon.png",
        pos = ccp(0, 15),
        parent = numberBg
      })
      table.insert(acttab, numberIcon)
      local str = rankLabel .. ":" .. data.number
      if scene.data.newMode == "guild_rank" then
        str = T(rankLabel, data.number, data.number2)
      end
      local number = ed.createttf(str, 16)
      number:setPosition(23, 13)
      number:setAnchorPoint(ccp(0, 0.5))
      if isSelf then
        number:setColor(ccc3(ed.colorToStr("#fffce7")))
        number:setStroke(ccc3(ed.colorToStr("#272524")), 1)
      else
        number:setColor(ccc3(ed.colorToStr("#433b38")))
      end
      numberBg:addChild(number)
      table.insert(acttab, number)
      if isAct and index and index < 20 or isSelf then
        local Children = num:getChildren()
        local node = Children:objectAtIndex(0)
        if node and node.getChildren then
          Children = node:getChildren()
          if Children then
            local nums = Children:count()
            for i = 0, nums - 1 do
              local v = Children:objectAtIndex(i)
              if v.setOpacity then
                table.insert(acttab, v)
              end
            end
          end
        end
        for _, v in ipairs(acttab) do
          v:setOpacity(isSelf and 50 or 0)
          v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(isSelf and 5 < index and 0.5 or 0.05 * (index - 2)), CCFadeTo:create(isSelf and 5 < index and 0.7 or 0.1, 255)))
        end
      end
      sprite.acttab = acttab
      return sprite, head
    end,
    refresh = function(this, scene)
      this.dragList:clearList()
      local height = 3
      local data, selfData = scene.data:getNewRankData()
      if not data then
        return
      end
      for i = 4, #data do
        height = height + 85
        local icon, hand = this.createItem(data[i], true, i, scene.data:getNewRankLabel(), false, scene)
        this.dragList:addItem(icon, ccp(367, this.thisCon.height - height + 42))
        scene:btRemoveMainTouchHandler({
          key = "hand_" .. i
        })
        if scene.data.newMode == "guild_rank" then
          hand = hand.icon
        end
        scene:btRegisterButtonClick({
          button = hand,
          key = "hand_" .. i,
          clickHandler = function(param, x, y)
            if not ed.containsPoint(scene.ui.Panel_697, x, y) then
              return
            end
            if scene.data.newMode == "guild_rank" then
              if not (data[i] and data[i].guildSummary) or not data[i].guildSummary._president then
                return
              end
              local guildSummary = data[i].guildSummary
              local president = guildSummary._president
              local guild_summary = {
                _avatar = guildSummary._avatar,
                _name = guildSummary._name,
                _id = guildSummary._id,
                _president = {
                  _name = president._name or "",
                  _medal = president._medal
                },
                _member_cnt = guildSummary._member_cnt,
                _slogan = guildSummary._slogan,
                power = data[i].power,
                server = data[i].server
              }
              ed.ui.guildSummaryWin.create(i, guild_summary):popWindow()
            else
              ed.registerNetReply("req_home_page", function(datas)
                local panel = ed.ui.PlayerInfoPanel.create(datas, false)
                panel:popWindow()
              end)
              ed.PlayerInfoNetwork:requestHomePage(data[i].role_id)
            end
          end,
          force = true,
          mcpMode = true,
          pressScale = hand:getScale() - 0.05,
          normalScale = hand:getScale()
        })
      end
      this.dragList:initListHeight(height)
      if this.myIcon then
        this.myIcon:removeFromParentAndCleanup(true)
        this.myIcon = nil
      end
      if selfData then
        this.myIcon = this.createItem(selfData, true, selfData.selfPos, scene.data:getNewRankLabel(), true, scene)
        this.myIcon:setPosition(367, 45)
        scene.ui.Panel_697:addChild(this.myIcon)
      end
    end
  },
  accordion = {
    treeBtnRes = {
      {
        normal = "UI/alpha/1080P/rankingscene/tab1.png",
        press = "UI/alpha/1080P/rankingscene/tab4.png",
        height = 46
      },
      {
        normal = "",
        press = "UI/alpha/1080P/rankingscene/tab2.png",
        height = 38
      },
      {
        normal = "",
        press = "UI/alpha/1080P/rankingscene/tab3.png",
        height = 33
      }
    },
    treeList = {
      {
        name = T("<lable color=ccc3(255,245,235) fontSize=f19 strokeColor=rankStrokeColor1 strokeSize=1>\233\152\159\228\188\141\230\136\152\229\138\155</lable> "),
        name2 = T("<lable color=ccc3(66,70,91) fontSize=f19 strokeColor=rankStrokeColor2 strokeSize=2>\233\152\159\228\188\141\230\136\152\229\138\155</lable> "),
        limitWidth = 90,
        tree = {
          {
            name = T("<lable color=ccc3(196,196,196) fontSize=f16>\229\133\168\233\131\168\233\152\159\228\188\141</lable>"),
            name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\229\133\168\233\131\168\233\152\159\228\188\141</lable>"),
            limitWidth = 80,
            data = {
              config = {mode = "team_gs"}
            }
          },
          {
            name = T("<lable color=ccc3(196,196,196) fontSize=f16>\230\136\145\230\150\185\233\152\159\228\188\141</lable>"),
            name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\230\136\145\230\150\185\233\152\159\228\188\141</lable>"),
            limitWidth = 80,
            data = {
              config = {mode = "team_gs", type = "self"}
            }
          },
          {
            name = T("<lable color=ccc3(196,196,196) fontSize=f16>\230\149\140\230\150\185\233\152\159\228\188\141</lable>"),
            name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\230\149\140\230\150\185\233\152\159\228\188\141</lable>"),
            limitWidth = 80,
            data = {
              config = {mode = "team_gs", type = "enemy"}
            }
          }
        }
      },
      {
        name = T("<lable color=ccc3(255,245,235) fontSize=f19 strokeColor=rankStrokeColor1 strokeSize=1>\230\136\152\229\134\181</lable><sprite src=UI/alpha/1080P/rankingscene/arrow_1.png >"),
        name2 = T("<lable color=ccc3(66,70,91) fontSize=f19 strokeColor=rankStrokeColor2 strokeSize=2>\230\136\152\229\134\181</lable><sprite src=UI/alpha/1080P/rankingscene/arrow.png >"),
        limitWidth = 90,
        tree = {
          {
            name = T("<lable color=ccc3(196,196,196) fontSize=f16>\229\135\187\232\180\165\233\152\159\228\188\141</lable>"),
            name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\229\135\187\232\180\165\233\152\159\228\188\141</lable>"),
            limitWidth = 80,
            data = {
              config = {mode = "team_kill"}
            }
          },
          {
            name = T("<lable color=ccc3(196,196,196) fontSize=f16>\230\182\136\231\129\173\232\139\177\233\155\132</lable>"),
            name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\230\182\136\231\129\173\232\139\177\233\155\132</lable>"),
            limitWidth = 80,
            data = {
              config = {mode = "hero_kill"}
            }
          }
        }
      },
      {
        name = T("<lable color=ccc3(255,245,235) fontSize=f19 strokeColor=rankStrokeColor1 strokeSize=1>\229\133\172\228\188\154\230\142\146\229\144\141</lable> "),
        name2 = T("<lable color=ccc3(66,70,91) fontSize=f19 strokeColor=rankStrokeColor2 strokeSize=2>\229\133\172\228\188\154\230\142\146\229\144\141</lable> "),
        limitWidth = 90,
        tree = {
          {
            name = "<lable color=ccc3(196,196,196) fontSize=f16>%s</lable>",
            name2 = "<lable color=ccc3(255,245,235) fontSize=f16>%s</lable>",
            limitWidth = 80,
            data = {
              config = {mode = "guild_rank"}
            }
          }
        }
      }
    },
    create = function(this, scene, params)
      this.accordion = ed.accordion.createAccordion(scene.ui.Panel_699, {
        vertex = {
          winLeft = -63,
          winRight = 0,
          winTop = 10,
          winBottom = 10
        },
        doClickOut = function(isPas, data)
          if params and params.doClickOut then
            params.doClickOut(data)
          end
        end,
        doAllClickOut = function(isLeaf, isPas, data)
        end,
        isBoom = true,
        treeBtnRes = this.treeBtnRes,
        anchor = 0,
        isTakeBack = true
      })
      local rateInfo = ed.GuildClashManager:getRateInfo()
      local zone_str = "nil"
      if rateInfo and rateInfo._zone_id and rateInfo._grade then
        zone_str = T("%s%s\230\136\152\229\140\186", ed.ui.guildClashGradeResultScene.GUILD_GRADE_TO_NAME[rateInfo._grade], rateInfo._zone_id)
      end
      this.treeList[3].tree[1].name = T(this.treeList[3].tree[1].name, zone_str)
      this.treeList[3].tree[1].name2 = T(this.treeList[3].tree[1].name2, zone_str)
      this.accordion:addAcclist(this.treeList)
      this.accordion:passTreeIndex(true, 1)
    end
  }
}
local data = {
  label = {
    team_gs = T("\233\152\159\228\188\141\230\128\187\230\136\152\229\138\155"),
    team_kill = T("\229\135\187\232\180\165\233\152\159\228\188\141\230\149\176\233\135\143"),
    hero_kill = T("\230\182\136\231\129\173\232\139\177\233\155\132\230\149\176\233\135\143"),
    guild_rank = T("%s\232\131\156%s\232\180\159")
  },
  init = function(self)
    self.data = {}
    self.selfData = {}
    self.newMode = "team_gs"
    self.newType = ""
    return self
  end,
  setNewType = function(self, config)
    self.newMode = config.mode
    self.newType = config.type
  end,
  setRankData = function(self, data)
    if data then
      local newData = {}
      for i, v in ipairs(data._rank_list or {}) do
        local item = {
          userSummary = v._user_summary,
          guildSummary = v._guild_summary
        }
        for ii = 1, 6 do
          if v["_param" .. ii] then
            item["param" .. ii] = v["_param" .. ii]
          end
        end
        table.insert(newData, item)
      end
      self.data[self.newMode] = newData
      if data._self_rank and (data._self_rank._user_summary or data._self_rank._guild_summary) then
        local item = {
          userSummary = data._self_rank._user_summary,
          selfPos = data._self_pos,
          guildSummary = data._self_rank._guild_summary
        }
        for ii = 1, 6 do
          if data._self_rank["_param" .. ii] then
            item["param" .. ii] = data._self_rank["_param" .. ii]
          end
        end
        self.selfData[self.newMode] = item
      end
    end
  end,
  getNewRankData = function(self)
    if not self.data[self.newMode] then
      return
    end
    local data = {}
    for i, v in ipairs(self.data[self.newMode] or {}) do
      local user = v.userSummary or {}
      local isAdd = true
      if self.newType == "self" then
        if v.param2 and v.param2 ~= 1 then
          isAdd = false
        end
      elseif self.newType == "enemy" and v.param2 and v.param2 == 1 then
        isAdd = false
      end
      if isAdd then
        table.insert(data, {
          guildSummary = v.guildSummary,
          name = user._name,
          level = user._level,
          avatar = user._avatar,
          number = v.param1,
          number2 = v.param2,
          medal = user._medal,
          role_id = user._role_id,
          guild_name = user._guild_name or "",
          power = v.param3,
          server = v.param4
        })
      end
    end
    local selfData = self.selfData[self.newMode]
    if not selfData then
      return data
    end
    if self.newType == "enemy" then
      return data
    end
    local user = selfData.userSummary or {}
    local selfPos = selfData.selfPos
    if self.newType == "self" then
      for i, v in ipairs(data) do
        if v.name == user._name and user._role_id == v.role_id then
          selfPos = i
          break
        end
      end
    end
    return data, {
      guildSummary = selfData.guildSummary,
      name = user._name,
      level = user._level,
      avatar = user._avatar,
      number = selfData.param1,
      selfPos = selfPos,
      medal = user._medal,
      role_id = user._role_id,
      number2 = selfData.param2,
      guild_name = user._guild_name or ""
    }
  end,
  getNewRankLabel = function(self)
    return self.label[self.newMode]
  end
}
local network = {
  label = {
    team_gs = 1,
    team_kill = 2,
    hero_kill = 3,
    guild_rank = 4
  },
  init = function(self)
    return self
  end
}
local base = ed.ui.basescene
local guildClashRankScene = newclass(base.mt)
ed.guildClashRankScene = guildClashRankScene
ed.UITool.registViewOpenFunc("guildClashRankScene", function(param)
  ed.pushScene(guildClashRankScene.create(param))
end)

function guildClashRankScene.create(param)
  return setmetatable(base.create("guildClashRankScene"), guildClashRankScene.mt):init(param)
end

function guildClashRankScene:initObject()
  self.data = setmetatable({}, {__index = data}):init()
  self.module = setmetatable({}, {__index = module})
  self.network = setmetatable({}, {__index = network}):init()
end

function guildClashRankScene:init(param)
  self.param = param
  self:initObject()
  self.frameContainer, self.ui = self.module.editorui(self)
  self:moduleInitCreate()
  self:registerTouchHandler()
  return self
end

function guildClashRankScene:moduleInitCreate()
  local param = self.param
  local top3 = self.module.top3
  top3.create(top3, self)
  local dragList = self.module.dragList
  dragList.create(dragList, self)
  local accordion = self.module.accordion
  accordion.create(accordion, self, {
    doClickOut = function(data)
      self.data:setNewType(data.config)
      data = self.data:getNewRankData()
      if not data then
        ed.GuildClashNetwork:sendQueryRank(self.network.label[self.data.newMode])
      else
        top3:refresh(self)
        dragList:refresh(self)
        self.ui.ImageView_nil:setVisible(#data == 0)
      end
    end
  })
  self:listenEvent("guildClashRankBreak", function(data)
    self.data:setRankData(data)
    top3:refresh(self)
    dragList:refresh(self)
    self.ui.ImageView_nil:setVisible(not data._rank_list or not (#data._rank_list > 0))
  end)
end

function guildClashRankScene:registerTouchHandler()
  ed.UITool.registerBtn(self, "ImageView_702", function()
    ed.popScene()
  end, {pressScale = 0.75, normalScale = 0.8})
end

function guildClashRankScene:refresh(info)
end
