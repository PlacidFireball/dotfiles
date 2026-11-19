-- Rex config migrated from tmux, Herdr and Ghostty.

-- tmux (~/.tmux.conf), prefix ctrl+space
rex.bind("ctrl+space>ctrl+space", "pane.send_key", { key = "ctrl+space" })
rex.bind("ctrl+space>r", "client.config.reload")
rex.bind("ctrl+space>c", "client.tab.new")
rex.bind("ctrl+space>n", "client.tab.next")
rex.bind("ctrl+space>p", "client.tab.previous")
rex.bind("ctrl+space>f", "pane.new_floating")
rex.bind("ctrl+t", "client.tab.new")
rex.bind("ctrl+shift+t", "client.tab.close")

-- Herdr (~/.config/herdr/config.toml), prefix ctrl+space
rex.bind("ctrl+space>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+space>shift+5", "pane.split", { direction = "right" })

-- Ghostty (~/.config/ghostty/config)
rex.bind("cmd+c", "pane.copy")
rex.bind("cmd+v", "pane.paste")
rex.bind("cmd+a", "pane.select_all")
rex.bind("cmd+r", "client.config.reload")

-- Pane focus on ctrl+h/j/k/l, vim-tmux-navigator style: when (n)vim runs in
-- the focused pane the key goes to it, and nvim hands focus back to Rex at
-- the edge of its own splits (see ~/.config/nvim/init.lua).
local function is_vim(name)
  name = (name or ""):gsub("^g", "")
  return name == "vim" or name == "nvim" or name == "vi" or name == "view"
    or name == "vimdiff" or name == "nvimdiff" or name == "fzf"
end

rex.action{
  name  = "vim_nav",
  title = "Focus Pane or Send Key to Vim",
  args  = { direction = "string", key = "string" },
  run   = function(ctx, args)
    local proc = rex.block.call("com.superlogical.terminal", "process",
      { block_id = ctx.block_id })
    if proc and proc.foreground and is_vim(proc.foreground.name) then
      rex.client.queue("pane.send_key", { key = args.key })
    else
      rex.client.queue("pane.focus", { direction = args.direction })
    end
  end,
}

rex.bind("ctrl+h", "vim_nav", { direction = "left",  key = "ctrl+h" })
rex.bind("ctrl+j", "vim_nav", { direction = "down",  key = "ctrl+j" })
rex.bind("ctrl+k", "vim_nav", { direction = "up",    key = "ctrl+k" })
rex.bind("ctrl+l", "vim_nav", { direction = "right", key = "ctrl+l" })

-- Resize splits
rex.bind("alt+shift+h", "pane.resize", { direction = "left" })
rex.bind("alt+shift+j", "pane.resize", { direction = "down" })
rex.bind("alt+shift+k", "pane.resize", { direction = "up" })
rex.bind("alt+shift+l", "pane.resize", { direction = "right" })

-- Session cycling
rex.bind("cmd+n", "session.next")
rex.bind("cmd+p", "session.previous")

-- Question with a choice of answers in the command palette. From a shell:
--   rex do confirm question="Ship it?"                         -> {"answer":"Yes"} or {"answer":"No"}
--   rex do confirm question="Deploy to?" options="staging:Staging,prod:Production"
--   rex do confirm --args '{"question":"Pick","options":["a:A, then B","c"]}'
-- Each option is <id>[:<label>]; the answer is the id. With no answer (closed,
-- timed out), the result is {"reason":"cancelled"} or similar.
rex.action{
  name  = "confirm",
  title = "Confirm…",
  args  = { question = "string", options = "any?" },
  run   = function(ctx, args)
    local options = args.options or { "Yes", "No" }
    if type(options) == "string" then
      local list = {}
      for item in options:gmatch("[^,]+") do
        item = item:match("^%s*(.-)%s*$")
        if item ~= "" then list[#list + 1] = item end
      end
      options = list
    end
    if type(options) ~= "table" or #options == 0 then
      error("options must be a comma-separated string or a list of strings", 0)
    end

    local items = {}
    for _, option in ipairs(options) do
      local id, label = tostring(option):match("^%s*(.-)%s*:%s*(.-)%s*$")
      if id == nil or id == "" then id, label = tostring(option), nil end
      items[#items + 1] = { id = id, title = (label ~= "" and label) or id }
    end

    local answer, why = rex.ui.pick{ title = args.question, items = items }
    if answer == nil then return { reason = why } end
    return { answer = answer }
  end,
}
