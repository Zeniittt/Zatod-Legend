local base = ed.ui.baseres
local class = newclass(base.mt)
ed.ui.uires = class
setfenv(1, class)
local winLeft, winRight, winTop, winBottom = ed.getDisplayVertex()
local d_pos = ccp(62, 0)
vit_gap = math.floor(sync_vitality_gap / 60)
shortcut_board_to_right = 60
shortcut_board_pos = ccp(winRight - shortcut_board_to_right, winBottom + 40)
shortcut_board_pop_time = 0.3
shortcut_board_height = 62
shortcut_board_touch_height = 100
shortcut_board_width_max = 400
shortcut_board_width_min = 0
shortcut_pos_x = shortcut_board_pos.x
shortcut_pos_y = shortcut_board_pos.y
s_b_offset_y = -70
local offY = shortcut_pos_x - 11
local heig = 86
shortcutBoardButtonPosX = {
  offY,
  offY - heig * 1,
  offY - heig * 2,
  offY - heig * 3,
  offY - heig * 4
}
for i = 1, #shortcutBoardButtonPosX do
  shortcutBoardButtonPosX[i] = shortcutBoardButtonPosX[i] + s_b_offset_y
end
shortcut_board_rect = CCRectMake(shortcut_board_pos.x - shortcut_board_touch_height / 2, 0, shortcut_board_touch_height, 480)
local ori_pos = ccp(winRight - 70, winTop - 82)
head_bg_pos = ccp(winLeft + 250 + 45, winTop - 10)
head_icon_pos = ccp(40, 44)
fourth_pos = ccpSub(ori_pos, ccpMult(d_pos, 3))
third_pos = ccpSub(ori_pos, ccpMult(d_pos, 2))
recharge_pos = ccpSub(ori_pos, ccpMult(d_pos, 1))
recharge_radius = 23
dailylogin_pos = ori_pos
dailylogin_radius = 23
mrv_scale = 1
mrv_scale_large = 1.5
