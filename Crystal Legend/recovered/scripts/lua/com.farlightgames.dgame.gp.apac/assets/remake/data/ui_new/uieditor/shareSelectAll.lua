ed.uieditor = ed.uieditor or {}
ed.uieditor.shareSelectAll = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(456, 65.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(17, 17, 17, 17),
      res = "UI/alpha/1080P/sharefight/bg_2.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(229, 32.5)
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
      name = "label_type",
      z = 0,
      parent = "image_bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(81, 32.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/sharefight/checkbox.png",
      name = "btn_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(425.5, 33.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/sharefight/chat.png",
      name = "image_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 34.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.3, x = 1.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.15, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_select",
      res = "UI/alpha/1080P/common/account_sifting_mark.png",
      name = "image_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.5, 14.5)
    }
  }
}
