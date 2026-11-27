ed.uieditor = ed.uieditor or {}
ed.uieditor.kaelSkillCombineWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(684, 388)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 19, 27),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 257.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 646, h = 162.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/battle/skill_combine_des_bg.png",
      name = "bg_des",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(340.5, 104.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 72, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_des",
      res = "UI/alpha/1080P/battle/skill_combine_title_line.png",
      name = "title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(253.5, 145.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_des",
      res = "UI/alpha/1080P/battle/skill_combine_title_line.png",
      name = "title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(393, 145.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(176, 167, 161),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "bg_des",
      text = T("\232\175\180\230\152\142"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(323, 145.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_quit_button.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(678.5, 384)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(630, 165)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_group",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(28.5, 195)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 35)
    },
    t = "Layer",
    base = {
      parent = "bg_des",
      name = "panel_element",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17.5, 90.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 80)
    },
    t = "Layer",
    base = {
      parent = "bg_des",
      name = "panel_des",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17.5, 8.25)
    }
  }
}
