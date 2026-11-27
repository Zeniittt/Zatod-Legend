ed.uieditor = ed.uieditor or {}
ed.uieditor.package_stone_deco = {
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(228, 226, 211),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 18,
      text = T("\228\187\165\228\184\139\232\139\177\233\155\132\229\176\154\230\156\170\232\142\183\229\190\151"),
      name = "Label_1406",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Label_1406",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_1404",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187, 9)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Label_1406",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_1405",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-43, 9)
    }
  }
}
