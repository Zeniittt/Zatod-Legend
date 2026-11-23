ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonSpecialStageInfo = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 776.5, h = 207},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/stageinfo/popup.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 281)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "stage_name",
      z = 0,
      parent = "image_bg",
      text = T("\229\133\179\229\141\161\232\175\166\230\131\133"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(387.75, 183)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "stage_desc",
      z = 0,
      parent = "image_bg",
      text = T("\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(388.25, 94)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(199, 174, 115),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "close_tip",
      z = 0,
      parent = "image_bg",
      text = T("\231\130\185\229\135\187\231\169\186\231\153\189\229\164\132\229\133\179\233\151\173"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(388.25, 13)
    }
  }
}
