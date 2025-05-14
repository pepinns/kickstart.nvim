function add_wrap(result, lhs, rhs)
  return function()
    return { { result .. lhs }, { rhs } }
  end
end

function fn_find()
  local config = require 'nvim-surround.config'
  if vim.g.loaded_nvim_treesitter then
    local selection = config.get_selection {
      query = {
        capture = '@call.outer',
        type = 'textobjects',
      },
    }
    if selection then
      return selection
    end
  end
  return config.get_selection { pattern = '[^=%s%(%){}]+%b()' }
end
function type_find()
  local config = require 'nvim-surround.config'
  if vim.g.loaded_nvim_treesitter then
    local selection = config.get_selection {
      query = {
        capture = '@type.outer',
        type = 'textobjects',
      },
    }
    if selection then
      return selection
    end
  end
  return config.get_selection { pattern = '[^=%s%<%>{}]+%b<>' }
end

function make_type_change(ty_name)
  return make_type_change_cb(function()
    return ty_name
  end)
end
function make_type_change_cb(get_ty_name)
  local type_delete = '^.-([%w_]+%<)().-(%>)()$'
  local type_change_target = '^.-([%w_]+)()%<.-%>()()$'
  return {
    add = function()
      local ty = get_ty_name()
      return { { ty .. '<' }, { '>' } }
    end,
    -- delete = "^.-([%w_]+%<)().-(%>)()$",
    delete = type_delete,
    find = type_find,
    change = {
      target = type_change_target,
      replacement = function()
        local result = get_ty_name()
        if result then
          return { { result }, { '' } }
        end
      end,
    },
  }
end

function make_fn_change(fn_name)
  return make_fn_change_cb(function()
    return fn_name
  end)
end
function make_fn_change_cb(get_ty_name)
  local fn_delete = '^(.-%()().-(%))()$'
  local fn_change_target = '^.-([%w:_]+)()%(.-%)()()$'
  return {
    add = function()
      local ty = get_ty_name()
      return { { ty .. '(' }, { ')' } }
    end,
    delete = fn_delete,
    find = fn_find,
    change = {
      target = fn_change_target,
      replacement = function()
        local result = get_ty_name()
        if result then
          return { { result }, { '' } }
        end
      end,
    },
  }
end

return {
  'kylechui/nvim-surround',
  version = '*', -- Use for stability; omit to use `main` branch for the latest features
  event = 'VeryLazy',
  config = function()
    local surround = require 'nvim-surround'
    local config = require 'nvim-surround.config'

    surround.setup {
      keymaps = {
        visual = 's',
        visual_line = 'gS',
      },
      aliases = {
        ['a'] = 'a',
        ['b'] = 'b',
        ['B'] = 'B',
        ['q'] = { '"', "'", '`' },
        ['s'] = { '}', ']', ')', '>', '"', "'", '`' },
      },
      surrounds = {
        ['<'] = make_type_change_cb(function()
          return config.get_input 'Enter Type name:'
        end),
        ['r'] = make_type_change 'Result',
        ['o'] = make_type_change 'Option',
        ['v'] = make_type_change 'Vec',
        ['a'] = make_type_change 'Arc',
        ['m'] = make_type_change 'Mutex',
        ['b'] = make_type_change 'Box',
        ['O'] = make_fn_change 'Ok',
        ['S'] = make_fn_change 'Some',
        ['E'] = make_fn_change 'Err',
        ['A'] = make_fn_change 'Arc::new',
        ['M'] = make_fn_change 'Mutex::new',
        ['B'] = make_fn_change 'Box::new',
      },
    }
  end,
}
