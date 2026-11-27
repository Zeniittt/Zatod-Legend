ed.uieditor = ed.uieditor or {}
ed.uieditor.GiftDetailItem = {
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
      size = 15,
      text = T("\233\129\147\229\133\183\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      name = "label_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(60.5, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_name",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-32.5, -3.75)
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
      name = "label_num",
      z = 0,
      parent = "label_name",
      text = "x100",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, -11.25)
    }
  }
}
