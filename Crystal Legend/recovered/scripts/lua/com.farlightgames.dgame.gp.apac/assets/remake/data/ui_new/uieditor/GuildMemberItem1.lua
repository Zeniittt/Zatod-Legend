ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMemberItem1 = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(553.5, 60)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(5, 5, 543, 77),
      res = "UI/alpha/1080P/crusade/bg_replay_item.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "info",
      z = 0,
      parent = "bg",
      text = T("\229\156\168\231\186\191"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(373.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46.74999065, h = 46.9999906},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 103, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\228\188\154\233\149\191"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(241.75, 30)
    }
  }
}
