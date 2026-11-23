ed.uieditor = ed.uieditor or {}
ed.uieditor.fire_forge_lottery_effect_window = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1755, h = 1080},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/background.jpg",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(298, 100)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84.5, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summon/skip_btn.png",
      name = "btn_skip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(885, 502.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 222, 184),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skip",
      z = 0,
      parent = "btn_skip",
      text = T("\232\183\179\232\191\135"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(49.25, 20)
    }
  }
}
