ed.uieditor = ed.uieditor or {}
ed.uieditor.chatTopWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(535, 58)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(12, 7.5, 13, 195),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "tpBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(121, 238, 239),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_168",
      z = 0,
      parent = "tpBg",
      text = T("\230\150\176\231\167\129\228\191\161"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "tpBg",
      res = "UI/alpha/1080P/friend/friend_line_2.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89, 31)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(425, 50)
    },
    t = "Layer",
    base = {
      parent = "tpBg",
      name = "clipLayer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(105, 6.5)
    }
  }
}
