ed.uieditor = ed.uieditor or {}
ed.uieditor.chat_msg_system = {
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
      anchor = ccp(0, 1),
      position = ccp(75, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/headline/notice.png",
      name = "image_notice",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, -20)
    }
  }
}
