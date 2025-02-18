local M = {}
local alpha = prequire('alpha')
if not alpha then
  return
end

local kind = require("arcane.utils.kind")

------------------------ Heading -------------------------
local banner = {
  type = "text",
  val = require("arcane.utils.banners").rand_banner(),
  opts = {
    position = "center",
    hl = "Comment",
  },
}

local function get_plugin_count()
  local plugins = ""

  if vim.fn.has("linux") == 1 or vim.fn.has("mac") == 1 then
    local handle = io.popen(
      'fd -d 1 . $HOME"/.local/share/nvim/lazy/" | wc -l'
    )
    plugins = handle:read("*a")
    handle:close()
    plugins = plugins:gsub("^%s*(.-)%s*$", "%1")
  else
    plugins = "N/A"
  end

  return plugins
end

local function get_date()
  local date = ""

  if vim.fn.has("linux") == 1 or vim.fn.has("mac") == 1 then
    local thingy = io.popen('echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"')
    date = thingy:read("*a")
    thingy:close()
  else
    date = "  whatever "
  end

  return date
end

local heading = {
  type = "text",
  val = "┌─ " .. kind.misc.calendar .. "  Today is " .. get_date() .. " ─┐",
  opts = {
    position = "center",
    hl = "String",
  },
}

local plugin_count = {
  type = "text",
  val = "└─ " .. kind.symbols_outline.Module .. "   " .. get_plugin_count() .. " plugins in total ─┘",
  opts = {
    position = "center",
    hl = "String",
  },
}

------------------------ Actions -------------------------
local function button(sc, txt, keybind)
  local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
  local opts = {
    position = "center",
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 24,
    align_shortcut = "right",
    hl_shortcut = "Number",
    hl = "Function",
  }
  if keybind then
    opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
  end
  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
      vim.api.nvim_feedkeys(key, "normal", false)
    end,
    opts = opts,
  }
end

local buttons = {
  type = "group",
  val = {
    button("e", " " .. kind.symbols_outline.File .. " New file", ":ene <BAR> startinsert <CR>"),
    button("f", " " .. kind.symbols_outline.Folder .. " Explore", ":Telescope find_files<CR>"),
    button("p", " " .. kind.nvim_tree_icons.folder.default .. "  Projects", ":Telescope projects<CR>"),
    button("s", " " .. kind.misc.magic .. " Restore", ":SessionManager load_session<cr>"),
    button("r", " " .. kind.misc.clock .. " Recents", ":Telescope oldfiles<CR>"),
    button("g", " " .. kind.git.branch .. " Git Status", "<cmd>lua _LAZYGIT_TOGGLE()<CR>"),
    button("c", " " .. kind.misc.settings .. " Config", ":e ~/.config/nvim/init.lua <CR>"),
    button("q", " " .. kind.misc.quit .. " Quit", ":qa<CR>"),
  },
  opts = {
    spacing = 1,
  },
}

------------------------ Footer -------------------------
local get_lazy_plugins = function()
  local stats = require("lazy").stats()
  local ms = math.floor(stats.startuptime) .. " ms"

  local txt = "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. msaa
  local txt_count = #txt

  local border = string.rep(txt_count, "-")

  return {
    border,
    txt,
    border
  }
end

local lazy_plugins = {
    type = "group",
    val = get_lazy_plugins(),
    opts = {
        spacing = 1,
    }
}

local fortune = require("alpha.fortune")()
local footer = {
  type = "text",
  val = fortune,
  opts = {
    position = "center",
    hl = "Comment",
    hl_shortcut = "Comment",
  },
}

------------------------ Config -------------------------
local section = {
  banner = banner,
  buttons = buttons,
  plugin_count = plugin_count,
  heading = heading,
  footer = footer,
}

local opts = {
  layout = {
    { type = "padding", val = 1 },
    section.banner,
    { type = "padding", val = 2 },
    section.heading,
    section.plugin_count,
    { type = "padding", val = 1 },
    section.buttons,
    lazy_plugins,
    section.footer,
  },
  opts = {
    margin = 5,
  },
}

alpha.setup(opts)

return M
