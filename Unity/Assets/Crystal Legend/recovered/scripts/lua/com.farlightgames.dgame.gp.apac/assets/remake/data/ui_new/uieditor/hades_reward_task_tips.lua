ed.uieditor = ed.uieditor or {}
ed.uieditor.hades_reward_task_tips = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 779, h = 93},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/hades/hades_preview_bg.png",
      name = "image_bg",
      z = 0
    },
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
      color = ccc3(255, 221, 145),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_new_task_tips",
      z = 0,
      parent = "image_bg",
      text = T("\231\131\173\229\138\155\230\140\145\230\136\152\228\187\187\229\138\161\229\176\134\229\156\16810\230\156\13631\230\151\165\229\143\145\229\184\131"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(393, 47)
    }
  }
}
