-- seamless-nav: smart-splits.nvim `at_edge` handler.
--
-- smart-splits already crosses from Neovim into neighboring herdr panes. When
-- Neovim and herdr are both at an edge, this opens herdr's workspace sidebar
-- (left) or hands focus to the neighboring WezTerm pane. Outside herdr it does
-- nothing, like `at_edge = "stop"`.
local source = debug.getinfo(1, "S").source:sub(2)
local script = vim.fn.fnamemodify(source, ":p:h:h") .. "/scripts/navigate.sh"

return function(ctx)
  if (vim.env.HERDR_ENV or "") == "" then
    return nil
  end
  -- The deployed script has a pinned Bash shebang and runtime dependencies.
  return vim.system { script, "edge", ctx.direction }
end
