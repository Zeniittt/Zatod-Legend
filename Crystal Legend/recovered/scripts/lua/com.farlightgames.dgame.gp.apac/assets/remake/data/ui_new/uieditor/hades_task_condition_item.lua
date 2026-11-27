ed.uieditor = ed.uieditor or {}
ed.uieditor.hades_task_condition_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 560.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/hades/hades_task_des_1.png",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(30, 30)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9.75, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 30)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(53.25, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.8, h = 40.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_hot.png",
      name = "image_heat_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(463.75, 15)
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
      name = "label_heat_amount",
      z = 0,
      parent = "image_bg",
      text = "1234",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(479.25, 15.5)
    }
  }
}
