ed.uieditor = ed.uieditor or {}
ed.uieditor.petHousePetWindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(780, 443)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(7.5, 7.5, 1, 1),
      res = "UI/alpha/1080P/pet/hero_pet_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(416, 247.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(760, 360)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_showPet",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12, 70.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(664, 35)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_select",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(59.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(660, 31)
    },
    t = "Scale9Sprite",
    base = {
      name = "slot_bg_image",
      z = 0,
      parent = "panel_select",
      res = "UI/alpha/1080P/pet/pet_room_tag_not_chosen_2.png",
      capInsets = CCRectMake(50, 10, 5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(330, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 129, h = 194.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/pet_list_empty.png",
      name = "no_pet",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(244, 247)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 397.5, h = 91},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "no_pet",
      res = "UI/alpha/1080P/pet/pet_list_empty_bg.png",
      name = "no_pet_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(279.5, 88.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(222, 202, 180),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "no_pet_label",
      z = 0,
      parent = "no_pet",
      text = T("\229\136\171\231\156\139\229\149\166\233\157\147\228\187\148\239\188\140\232\191\153\233\135\140\231\169\186\231\169\186\229\166\130\228\185\159"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(279, 89.25)
    }
  }
}
