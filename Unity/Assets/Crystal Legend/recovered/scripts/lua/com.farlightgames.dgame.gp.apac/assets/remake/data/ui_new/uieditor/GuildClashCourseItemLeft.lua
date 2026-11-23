ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashCourseItemLeft = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(295.5, 55.5)
    },
    t = "Layer",
    base = {name = "image_bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(133, 198, 188),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_date",
      z = 0,
      parent = "image_bg",
      text = T("1\230\156\13615\230\151\165"),
      size = 19
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(288, 39)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(208, 205, 192),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "image_bg",
      text = "5:00",
      size = 19
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(287.5, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(202, 178, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 0,
      parent = "image_bg",
      text = T("\229\175\185\230\137\139\239\188\154\229\133\172\228\188\154\229\144\141\229\173\151\229\133\173\228\184\170\229\173\151"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 1),
      position = ccp(203, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(202, 178, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\231\172\172\228\184\128\232\189\174 \232\131\156\229\136\169"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(203, 39.5)
    }
  }
}
