ed.uieditor = ed.uieditor or {}
ed.uieditor.fire_forge_handbook_title = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1035, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/bag/only_title.png",
      name = "image_bg",
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
      color = ccc3(255, 250, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\229\148\175\228\184\128\232\163\133\229\164\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(516, 29.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 196, 103),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_collect",
      z = 0,
      parent = "image_bg",
      text = T("\229\183\178\230\148\182\233\155\134\239\188\1364/4\239\188\137"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(165, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(191, 115, 70),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tips",
      z = 0,
      parent = "image_bg",
      text = T("\230\175\143\231\167\141\229\148\175\228\184\128\232\163\133\229\164\135\229\143\170\232\131\189\230\139\165\230\156\137\228\184\128\228\187\182\230\149\180\232\163\133\239\188\140\228\185\139\229\144\142\230\137\128\229\190\151\229\157\135\230\152\175\232\163\133\229\164\135\231\162\142\231\137\135"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(517.5, 3.25)
    }
  }
}
