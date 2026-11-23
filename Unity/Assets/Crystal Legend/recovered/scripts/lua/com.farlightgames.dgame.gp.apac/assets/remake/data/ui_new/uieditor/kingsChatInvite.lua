ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsChatInvite = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 340, h = 86},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_invite_bg_2.png",
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
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\232\175\184\231\142\139\228\186\137\233\156\184-\228\184\128\229\177\128\232\131\156\232\180\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(95, 60)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 191, 171),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 0,
      parent = "image_bg",
      text = T("\230\157\165\228\184\141\229\143\138\232\167\163\233\135\138\228\186\134\239\188\140\229\191\171\228\184\138\232\189\166\239\188\129"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(96, 32)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 225, 123),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tips",
      z = 0,
      parent = "image_bg",
      text = T("\227\128\144\231\130\185\229\135\187\229\138\160\229\133\165\227\128\145"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(298.5, 15.5)
    }
  }
}
