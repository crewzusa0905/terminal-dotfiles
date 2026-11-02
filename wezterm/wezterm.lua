-- Created with WezTerm Studio
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Keep Latin text monospaced and resolve Japanese through a Japanese font.
config.font = wezterm.font_with_fallback {
  'JetBrains Mono',
  { family = 'Hiragino Kaku Gothic ProN', weight = 'Light' },
  'Symbols Nerd Font Mono',
  'Noto Color Emoji',
}
-- Extra vertical space reduces crowding between Japanese lines.
config.line_height = 1.15
config.font_size = 14
config.colors = {
  ansi = { '#15161e', '#f7768e', '#9ece6a', '#e0af68', '#7aa2f7', '#bb9af7', '#7dcfff', '#c0caf5' },
  brights = { '#15161e', '#f7768e', '#9ece6a', '#e0af68', '#7aa2f7', '#bb9af7', '#7dcfff', '#c0caf5' },
  foreground = '#c0caf5',
  background = '#1a1b26',
  cursor_bg = '#7aa2f7',
  cursor_border = '#7aa2f7',
  tab_bar = {
    background = 'rgba(32, 34, 49, 0.8)',
    active_tab = { bg_color = 'rgba(122, 162, 247, 0.8)', fg_color = '#161720' },
    inactive_tab = { bg_color = 'rgba(32, 34, 49, 0.8)', fg_color = '#a3a9b1' },
    inactive_tab_hover = { bg_color = 'rgba(32, 34, 49, 0.8)', fg_color = '#a3a9b1' },
    new_tab_hover = { bg_color = 'rgba(32, 34, 49, 0.8)', fg_color = '#a3a9b1' },
    new_tab = { bg_color = 'rgba(32, 34, 49, 0.8)', fg_color = '#a3a9b1' },
  },
}
-- Shared terminal and tab background opacity (text remains opaque).
config.window_background_opacity = 0.8
config.window_padding = { left = 24, right = 24, top = 24, bottom = 24 }
config.default_cursor_style = 'BlinkingBar'
config.enable_tab_bar = true
-- Render the window buttons inside WezTerm's translucent tab bar.
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

-- Requested title bar opacity: 80%; native rendering is OS-dependent.
config.window_frame = { active_titlebar_fg = '#c0caf5', inactive_titlebar_fg = '#a3a9b1', active_titlebar_bg = 'rgba(22, 23, 32, 0.8)', inactive_titlebar_bg = 'rgba(22, 23, 32, 0.8)' }

-- Local panes only; Git must be installed and available on PATH.
config.status_update_interval = 2000
wezterm.on('update-right-status', function(window, pane)
  local parts = {}
  local cwd = pane:get_current_working_dir()
  if cwd then
    local path = cwd.file_path
    table.insert(parts, path)
    if pane:get_domain_name() == 'local' then
      local ok, success, branch = pcall(wezterm.run_child_process, { 'git', '-C', path, 'branch', '--show-current' })
      if ok and success then
        branch = branch:gsub('%s+$', '')
        if branch == '' then
          local hash_ok, hash_success, hash = pcall(wezterm.run_child_process, { 'git', '-C', path, 'rev-parse', '--short', 'HEAD' })
          if hash_ok and hash_success then branch = hash:gsub('%s+$', '') end
        end
        local dirty_ok, dirty_success, dirty = pcall(wezterm.run_child_process, { 'git', '-C', path, 'status', '--porcelain', '--untracked-files=no' })
        if branch ~= '' then table.insert(parts, 'git:' .. branch .. ((dirty_ok and dirty_success and dirty ~= '') and ' *' or '')) end
      end
    end
  end
  window:set_right_status(wezterm.format({ { Foreground = { Color = '#a3a9b1' } }, { Background = { Color = 'rgba(32, 34, 49, 0.8)' } }, { Text = ' ' .. table.concat(parts, ' | ') .. ' ' } }))
end)

return config
