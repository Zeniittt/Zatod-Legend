ed.uieditor = ed.uieditor or {}
ed.uieditor.languageSettingSelectionItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 218, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/global/language_bg2.png",
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
      name = "label_language",
      z = 0,
      parent = "bg",
      text = T("\232\142\183\229\143\150\233\128\148\229\190\1321"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(51, 25)
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
      parent = "bg",
      res = "UI/alpha/1080P/sharefight/checkbox.png",
      name = "ImageView_29368",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.5, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/account_sifting_mark.png",
      name = "img_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.5, 24.5)
    }
  }
}
