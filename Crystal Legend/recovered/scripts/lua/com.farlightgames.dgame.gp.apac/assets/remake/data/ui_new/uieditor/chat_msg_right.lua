ed.uieditor = ed.uieditor or {}
ed.uieditor.chat_msg_right = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "head_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(490, -30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 17},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chat/new/chat_level_bg.png",
      name = "level_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(432.5, -15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(430, 40)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 2, 2),
      res = "UI/alpha/1080P/chat/chat_input.png",
      name = "chat_msg_bg",
      z = 0
    },
    layout = {
      anchor = ccp(1, 1),
      position = ccp(450, -30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 43.8, h = 43.8},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/main/main_head_play.png",
      name = "head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(490, -30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/global/translate_button.png",
      name = "translate_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-2.5, -50.5)
    }
  }
}
