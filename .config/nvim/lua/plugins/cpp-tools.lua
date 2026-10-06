-- Generate out-of-class definitions from declarations in a .h,
-- the way Visual Studio / JetBrains do it.
return {
  "Badhi/nvim-treesitter-cpp-tools",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "c", "cpp", "objc", "objcpp", "cuda" },
  config = function()
    require("nt-cpp-tools").setup({
      preview = {
        quit = "q", -- reject the generated snippet
        accept = "<tab>", -- insert it
      },
      header_extension = "h",
      source_extension = "cpp",
      -- The stock TSCppDefineClassFunc previews and inserts into the *current*
      -- buffer. This variant skips the preview and writes straight into the
      -- matching .cpp, which is the Visual Studio / JetBrains behaviour.
      custom_define_class_function_commands = {
        TSCppImplWrite = {
          output_handle = require("nt-cpp-tools.output_handlers").get_add_to_cpp(),
        },
      },
    })

    -- :CppImplMissing -- whole-header, no visual selection, and only emits
    -- definitions that don't already exist in the .cpp, so it is safe to rerun.
    -- (TSCppImplWrite regenerates everything in range and will duplicate.)
    -- Collapse whitespace to single spaces and drop it around punctuation, so
    -- `int  Widget :: get ( ) const` becomes `int Widget::get()const` while
    -- word boundaries (`int Widget`) survive for `has_definition` to check.
    local function normalize(text)
      return (text:gsub("%s+", " "):gsub(" ?([^%w_ ]) ?", "%1"))
    end

    local function signature_key(block)
      -- Collapse a generated definition down to `Class::name(args)[const]`,
      -- normalized the same way as the .cpp text it is matched against.
      local decl = block:match("^(.-)%s*%b{}$") or block
      decl = decl:gsub("template%s*<[^\n]*>", "") -- drop the template<> line
      local key = decl:match("[%w_~]+%s*::%s*[~%w_]+%s*%b()")
      if not key then
        return nil -- unparsed (e.g. operators); caller re-emits to be safe
      end
      if decl:match("%b()%s*const") then
        key = key .. "const"
      end
      return normalize(key)
    end

    -- The generated definitions are unqualified (`Widget::foo`, never
    -- `app::ui::Widget::foo`), so for a class inside a namespace they are only
    -- valid *inside* that same namespace block in the .cpp. These helpers find
    -- it, or build it when the source file doesn't have one yet.
    local ts = vim.treesitter

    local function root_of(buf)
      local ok, parser = pcall(ts.get_parser, buf, "cpp")
      if not ok or not parser then
        return nil
      end
      return parser:parse()[1]:root()
    end

    local function ns_name_parts(node, buf) -- handles `namespace a::b {`
      local parts = {}
      local name = node:field("name")[1]
      if name then -- anonymous namespaces contribute nothing
        for p in ts.get_node_text(name, buf):gmatch("[%w_]+") do
          parts[#parts + 1] = p
        end
      end
      return parts
    end

    -- Class/struct name -> enclosing namespace path, for every class in the
    -- header, so each generated definition lands in its own class's namespace.
    local function class_ns_paths(buf)
      local paths = {}
      local function walk(node, acc)
        for child in node:iter_children() do
          local t = child:type()
          local next_acc = acc
          if t == "namespace_definition" then
            next_acc = vim.list_extend(vim.deepcopy(acc), ns_name_parts(child, buf))
          elseif t == "class_specifier" or t == "struct_specifier" then
            local name = child:field("name")[1]
            if name and child:field("body")[1] then
              local class = ts.get_node_text(name, buf)
              paths[class] = paths[class] or acc
            end
          end
          walk(child, next_acc)
        end
      end
      local root = root_of(buf)
      if root then
        walk(root, {})
      end
      return paths
    end

    -- Class a generated definition belongs to (`Widget` in `int Widget::foo()`).
    local function block_class(block)
      local decl = block:match("^(.-)%s*%b{}$") or block
      return decl:match("([%w_]+)%s*::%s*~?[%w_]+%s*%b()") or decl:match("([%w_]+)%s*::%s*operator")
    end

    -- `existing` is the normalized .cpp text. A plain substring
    -- search would count `Widget::get()` as defined when only
    -- `Widget::get()const` is, or when `MyWidget::get()` is.
    local function has_definition(existing, key)
      local init = 1
      while true do
        local s, e = existing:find(key, init, true)
        if not s then
          return false
        end
        local prev = s > 1 and existing:sub(s - 1, s - 1) or ""
        local const_follows = key:sub(-5) ~= "const" and existing:sub(e + 1, e + 5) == "const"
        if not prev:match("[%w_]") and not const_follows then
          return true
        end
        init = e + 1
      end
    end

    -- Deepest namespace_definition in `buf` whose full path equals `target`.
    local function find_ns(node, buf, target, acc)
      local match
      for child in node:iter_children() do
        local next_acc = acc
        if child:type() == "namespace_definition" then
          next_acc = vim.list_extend(vim.deepcopy(acc), ns_name_parts(child, buf))
          if vim.deep_equal(next_acc, target) then
            match = child
          end
        end
        match = find_ns(child, buf, target, next_acc) or match
      end
      return match
    end

    -- Row to insert at so new lines go just inside the namespace's closing
    -- brace. If the brace shares its line with code (`namespace a { int x; }`),
    -- that line is split first so the brace sits on its own line.
    local function ns_insert_row(ns, buf)
      local body = ns:field("body")[1] or ns
      local _, _, row, col = body:range()
      local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
      local before = line:sub(1, col - 1):gsub("%s+$", "")
      if before == "" then
        return row
      end
      vim.api.nvim_buf_set_lines(buf, row, row + 1, false, { before, line:sub(col) })
      return row + 1
    end

    -- Insert one namespace's worth of definitions into `src_buf`.
    local function insert_group(src_buf, ns_path, blocks)
      local body = vim.split(table.concat(blocks, "\n\n"), "\n")
      local at, ns_note = -1, nil

      if #ns_path > 0 then
        local root = root_of(src_buf)
        local ns = root and find_ns(root, src_buf, ns_path, {})
        if ns then
          at = ns_insert_row(ns, src_buf)
          ns_note = "namespace " .. table.concat(ns_path, "::")
        else
          -- No such namespace in the .cpp yet: wrap the definitions in one.
          local open, close = {}, {}
          for _, part in ipairs(ns_path) do
            table.insert(open, "namespace " .. part .. " {")
            table.insert(close, 1, "} // namespace " .. part)
          end
          body = vim.list_extend(open, body)
          vim.list_extend(body, close)
          ns_note = "new namespace " .. table.concat(ns_path, "::")
        end
      end

      -- Keep one blank line on each side of the inserted block.
      local above = at == -1 and vim.api.nvim_buf_line_count(src_buf) - 1 or at - 1
      if above >= 0 and vim.api.nvim_buf_get_lines(src_buf, above, above + 1, false)[1] ~= "" then
        table.insert(body, 1, "")
      end
      if at ~= -1 then
        table.insert(body, "")
      end

      vim.api.nvim_buf_set_lines(src_buf, at, at, false, body)
      return ns_note
    end

    vim.api.nvim_create_user_command("CppImplMissing", function()
      local src = vim.fn.expand("%:p:r") .. ".cpp"
      if vim.fn.filereadable(src) == 0 then
        vim.notify("No matching source file: " .. src, vim.log.levels.ERROR)
        return
      end

      local header = vim.api.nvim_get_current_buf()
      local ns_paths = class_ns_paths(header)

      local src_buf = vim.fn.bufadd(src)
      vim.fn.bufload(src_buf)
      local existing = normalize(table.concat(vim.api.nvim_buf_get_lines(src_buf, 0, -1, false), "\n"))

      require("nt-cpp-tools.internal").imp_func(1, vim.api.nvim_buf_line_count(header), function(output)
        -- Group the missing definitions by namespace, keeping header order.
        local groups, order, count = {}, {}, 0
        for block in output:gmatch("%s*(.-%b{})") do
          local key = signature_key(block)
          if not key or not has_definition(existing, key) then
            local path = ns_paths[block_class(block) or ""] or {}
            local id = table.concat(path, "::")
            if not groups[id] then
              groups[id] = { path = path, blocks = {} }
              order[#order + 1] = id
            end
            table.insert(groups[id].blocks, block)
            count = count + 1
          end
        end

        if count == 0 then
          vim.notify("All declarations are already implemented in " .. vim.fn.fnamemodify(src, ":t"))
          return
        end

        local notes = {}
        for _, id in ipairs(order) do
          local note = insert_group(src_buf, groups[id].path, groups[id].blocks)
          if note then
            notes[#notes + 1] = note
          end
        end

        vim.cmd("vsplit " .. vim.fn.fnameescape(src))
        vim.notify(
          ("Added %d definition%s%s"):format(
            count,
            count == 1 and "" or "s",
            #notes > 0 and (" in " .. table.concat(notes, ", ")) or ""
          )
        )
      end)
    end, { desc = "Implement declarations missing from the .cpp" })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("cpp_tools_keymaps", { clear = true }),
      pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
      callback = function(ev)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
        end

        map("n", "<leader>cM", "<cmd>CppImplMissing<cr>", "Implement Missing Declarations -> .cpp")
        map({ "n", "v" }, "<leader>ci", "<cmd>TSCppImplWrite<cr>", "Implement Declarations -> .cpp")
        map({ "n", "v" }, "<leader>cI", "<cmd>TSCppDefineClassFunc<cr>", "Implement Declarations (preview, inline)")
        map({ "n", "v" }, "<leader>ce", "<cmd>TSCppMakeConcreteClass<cr>", "Implement Pure Virtuals")
        map("n", "<leader>c3", "<cmd>TSCppRuleOf3<cr>", "Rule of 3")
        map("n", "<leader>c5", "<cmd>TSCppRuleOf5<cr>", "Rule of 5")
      end,
    })
  end,
}
