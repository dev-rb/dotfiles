local root = assert(arg[1], "repository source path is required")
local function run(target)
  local events = {}
  local color = {}
  function color:lighten() return self end
  function color:darken() return self end
  local wezterm = {
    target_triple = target,
    home_dir = root .. "/tests/unused-home",
    nerdfonts = setmetatable({}, { __index = function(_, key) return key end }),
    color = { parse = function() return color end },
    config_builder = function() return {} end,
    font = function(name) return name end,
    format = function(value) return value end,
    truncate_right = function(value) assert(type(value) == "string"); return value end,
    on = function(event, callback) events[event] = callback end,
    action = setmetatable({}, { __index = function(_, key)
      return function(value) return { [key] = value } end
    end }),
  }
  package.loaded.wezterm = wezterm
  local original_dofile = dofile
  _G.dofile = function(path)
    if path == wezterm.home_dir .. "/.config/wezterm/windows.lua" then
      return original_dofile(root .. "/modules/features/wezterm/windows.lua")
    end
    return original_dofile(path)
  end
  local config = original_dofile(root .. "/modules/features/wezterm/wezterm.lua")
  _G.dofile = original_dofile
  if target:find("windows") then
    assert(config.default_domain == "WSL:Ubuntu")
    assert(config.default_prog[1] == "wsl.exe")
    assert(config.background[1].source.File:find("D:/", 1, true))
  else
    assert(config.default_domain == nil)
    assert(config.default_prog == nil)
    assert(config.background == nil)
  end
  for _, tab in ipairs({
    { active_pane = { title = "shell" } },
    { active_pane = { current_working_dir = { file_path = "/tmp/project/" } } },
    { tab_title = "---" },
    {},
  }) do
    events["format-tab-title"](tab, nil, nil, nil, false, 80)
  end
end
run("aarch64-apple-darwin")
run("x86_64-unknown-linux-gnu")
run("x86_64-pc-windows-msvc")
print("WezTerm platform and tab-title checks passed.")
