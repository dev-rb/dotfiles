local DEFAULT_RATIO = 0.3
local BREAKPOINTS = {
  { max_columns = 80, ratio = 0.85 },
  { max_columns = 100, ratio = 0.7 },
  { max_columns = 120, ratio = 0.6 },
  { max_columns = 140, ratio = 0.5 },
  { max_columns = 160, ratio = 0.4 },
}

local M = {}

function M.get(screen_w)
  for _, breakpoint in ipairs(BREAKPOINTS) do
    if screen_w <= breakpoint.max_columns then
      return breakpoint.ratio
    end
  end

  return DEFAULT_RATIO
end

return M
