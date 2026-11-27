ed.uieditor = ed.uieditor or {}
ed.uieditor.roguePetNest = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 41.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_pet_nest.png",
      name = "image_nest",
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
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.3, h = 46.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_nest",
      res = "UI/alpha/1080P/rogue/instance/instance_pet_egg.png",
      name = "image_egg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(33.75, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_nest",
      res = "UI/alpha/1080P/rogue/instance/instance_egg_store_warning.png",
      name = "image_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 62.75)
    }
  }
}
