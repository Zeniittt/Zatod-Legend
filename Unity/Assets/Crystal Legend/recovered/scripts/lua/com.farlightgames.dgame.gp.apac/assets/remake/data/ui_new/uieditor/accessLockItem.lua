ed.uieditor = ed.uieditor or {}
ed.uieditor.accessLockItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 204,
      visible = true,
      scaleSize = CCSizeMake(264.5, 46)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(9.5, 15, 9.5, 15),
      res = "UI/alpha/1080P/package/access_unlock.png",
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
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_info",
      z = 0,
      parent = "bg",
      text = T("\232\142\183\229\143\150\233\128\148\229\190\1321"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(13.25, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_lock",
      z = 0,
      parent = "bg",
      text = T("\230\156\170\229\188\128\230\148\190"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232.25, 23)
    }
  }
}
