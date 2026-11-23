ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_calender_tips = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(408.5, 220)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(13, 83, 13, 120.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "image_bg",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\232\191\156\229\190\129\233\135\145\229\184\129\231\191\187\229\128\141"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(204.25, 198)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "image_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.25, 196)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "image_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(311.75, 196)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "image_bg",
      text = T("3\230\156\13615\230\151\165 05:00 - 3\230\156\13619\230\151\165 04:00"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(204.25, 169)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(358, 136.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "layer_text",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(26.25, 19)
    }
  }
}
