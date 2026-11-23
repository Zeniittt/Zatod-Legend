ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildApplyItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 63.5)
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(77.5, 43)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_agree",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(25, 11.5, 25, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(425, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(77.5, 43)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_unagree",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(25, 11.5, 25, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(505, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_tip",
      z = 0,
      parent = "bg",
      text = T("\229\183\178\230\139\146\231\187\157\229\138\160\229\133\165"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476, 32.25)
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
      name = "head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 31.75)
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
      name = "Label_12960",
      z = 0,
      parent = "btn_agree",
      text = T("\229\144\140\230\132\143"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.75, 22.5)
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
      name = "Label_12960",
      z = 0,
      parent = "btn_unagree",
      text = T("\230\139\146\231\187\157"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.75, 22.5)
    }
  }
}
