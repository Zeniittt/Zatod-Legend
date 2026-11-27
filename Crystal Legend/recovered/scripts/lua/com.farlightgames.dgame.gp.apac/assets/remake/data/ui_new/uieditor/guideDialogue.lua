ed.uieditor = ed.uieditor or {}
ed.uieditor.guideDialogue = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(241.5, 60)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(90, 15, 25, 30),
      res = "UI/alpha/1080P/guide/dialogmask2.png",
      name = "dialog_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(89.5, 60)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 142.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dialog_bg",
      res = "UI/alpha/1080P/guide/tutorial_head_coco.png",
      name = "head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-30, 66)
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
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "dialog_text",
      z = 0,
      parent = "dialog_bg",
      text = T("\229\174\140\230\136\144\228\187\187\229\138\161\229\174\140\230\136\144\228\187\187"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(37, 56)
    }
  }
}
